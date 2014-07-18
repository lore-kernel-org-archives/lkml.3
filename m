Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762097AbaGRMdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:33:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40260 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761556AbaGRMdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:33:04 -0400
Date: Fri, 18 Jul 2014 13:32:39 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Sahasrabudhe, Sheetal" <sheetals@quicinc.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: perf: child events not killed on release paths, survive indefinitely
Message-ID: <20140718123238.GF25180@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Thread-Topic: Child events live forever after a fork, penalizing new events
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Sheetal reported a weird issue on arm where events which have been
closed seem to stay around and compete for HW counters if an application
has forked between the events being opened and them being closed.

I've reproduced this in mainline and linux-next and this seems to be a
generic issue; the below test case fires on my x86-64 workstation as
well as on arm and arm64.

The problem is the way we (don't) handle child events when releasing a
parent in perf_release and perf_event_release_kernel. We call put_event
on the parent when it is released, but this will exit early having done
nothing because each child will have incremented the parent refcount
when initialised from perf_event_init_task. We don't seem to do anything
about the children in this case.

Thus the parent event can't be killed until all the children have first
been killed. As the only places references to them exist are the
parent's child_list and their respective tasks' hardware
perf_event_context, they'll only get killed when their respective tasks
exit (I confirmed this with some printks in hw_perf_event_destroy and
put_event). Until that happens they remain in their respective contexts
and continue to compete for HW counters, adversely affecting events
opened later.

I'm not sure what the best way of handling this is. We need to clean up
the children when the last possible user of the event is gone, but it
looks to me like we'd need to have a separate child_refcount or
reader_refcount to be able to tell when the events are still useful and
when the only references which remain are internal.

Any ideas?

Cheers,
Mark.

---->8----
/*
 * It looks like events which we close are hanging around in
 * kernel-space, and remain schedulable unexpectedly, penalizing events
 * we later open. Let's try to detect that...
 */
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <linux/perf_event.h>

#include <asm/unistd.h>

/*
 * Something the children can block on indefinitely without wasting CPU time.
 */
int pipefd[2];

void *block_forever(void *unused)
{
	read(pipefd[0], NULL, 1);
	return NULL;
}

void create_child(void)
{
	pthread_t child;
	if (pthread_create(&child,  NULL, block_forever, NULL) == 0)
		return;

	printf("Unable to create child thread.\n");
	exit(1);
}

/* There's no libc wrapper... */
int perf_event_open(struct perf_event_attr *attr,
		    pid_t pid, int cpu, int group_fd,
		    unsigned long flags)
{
	return syscall(__NR_perf_event_open, attr, pid, cpu, group_fd, flags);
}

struct perf_event_attr attr = {
	.type = PERF_TYPE_HARDWARE,
	.size = sizeof(attr),
	.config = PERF_COUNT_HW_INSTRUCTIONS,
	.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
		       PERF_FORMAT_TOTAL_TIME_RUNNING,
	.inherit = 1,
};

int create_event(void)
{
	int event_fd = perf_event_open(&attr, 0, -1, -1, 0);
	if (event_fd >= 0)
		return event_fd;

	printf("Unable to open event\n");
	exit(1);
}

void validate_event(int fd)
{
	struct read_format {
		uint64_t value;
		uint64_t enabled;
		uint64_t running;
	} data;

	if (read(fd, &data, sizeof(data)) != sizeof(data)) {
		printf("Unable to read event.\n");
		exit(1);
	}

	/*
	 * When there's no competition for counters, eligible events should
	 * always be scheduled. Given we closed all prior events, there should
	 * be no contention in the absence of events owned by other tasks.
	 */
	if (data.enabled != data.running) {
		printf("HW counter contention detected\n");
		exit(1);
	}
}

int main(int argc, char *argv[])
{
	if (pipe(pipefd) != 0) {
		printf("Unable to open pipe\n");
		exit(1);
	}

	for (;;) {
		int event_fd = create_event();
		create_child();
		validate_event(event_fd);
		close(event_fd);
		printf(".");
	};

	return 0;
}
