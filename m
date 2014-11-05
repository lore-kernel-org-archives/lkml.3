Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaKEQMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:12:31 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34518 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754930AbaKEQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:12:29 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: acme@kernel.org, drew.richardson@arm.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, vincent.weaver@maine.edu, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/1] perf: fix corruption of sibling list with hotplug
Date: Wed,  5 Nov 2014 16:11:43 +0000
Message-Id: <1415203904-25308-1-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patch prevents events from being freed while still part of a
sibling list, which can happen if all references to CPU-bound events in a
sibling list are dropped while the relevant CPU is offline.

We currnetly rely on a cross call to __perf_remove_from_context to remove an
event from its sibling list when it is destroyed, but this can fail for
CPU-bound events if the CPU is already offline. We then free the event without
having removed it from the sibling list, leaving siblings pointing at memory
that may be reallocated at any time.

To work around this I forcefully tear apart CPU-bound event groups upon CPU hot
unplug. We already force the events out of their context, and they'll never be
scheduled again. We could instead try to tear apart the groups from another CPU
if the cross-call fails, but that seemed more complex.

Without this patch, the below test case (when run with sufficient privileges)
can trigger a dereference of a garbage pointer in perf_group_detach, leading to
an Oops and a possible panic.

Thanks,
Mark.

---->8----
#include <errno.h>
#include <fcntl.h>
#include <linux/perf_event.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#define CPU 1
#define DELAY_SECS 4

#define _STR(x) #x
#define STR(x) _STR(x)
#define CPU_S STR(CPU)

int sys_perf_event_open(struct perf_event_attr *attr, pid_t pid, int cpu,
			       int group_fd, unsigned long flags)
{
	return syscall(__NR_perf_event_open, attr, pid, cpu, group_fd, flags);
}

int cpufd;

/* Arbitrary CPU-bound event */
struct perf_event_attr attr = {
	.type = PERF_TYPE_SOFTWARE,
	.config = PERF_COUNT_SW_CONTEXT_SWITCHES,
	.sample_period = 100000000,
	.sample_type = PERF_SAMPLE_TIME,
};

void trigger(void)
{
	int leader, follower;

	leader = sys_perf_event_open(&attr, -1, CPU, -1, 0);
	if (leader < 0)
		exit(errno);

	follower = sys_perf_event_open(&attr, -1, CPU, leader, 0);
	if (follower < 0)
		exit(errno);

	/* Make cpu_call_funcion on CPU fail when killing the follower */
	if (write(cpufd, "0", 1) != 1)
		exit(EIO);

	close(follower);

	/* Ensure cpu_call_function succeeds when killing the leader */
	if (write(cpufd, "1", 1) != 1)
		exit(EIO);

	/* hope something else re-uses the memory */
	sleep(DELAY_SECS);

	close(leader);
}

int main(void)
{
	cpufd = open("/sys/devices/system/cpu/cpu" CPU_S "/online", O_WRONLY);
	if (cpufd < 0)
		exit(errno);

	/* make sure the CPU is online to begin with */
	if (write(cpufd, "1", 1) != 1)
		exit(EIO);

	for (;;)
		trigger();

	return 0;
}
---->8----

Mark Rutland (1):
  perf: fix corruption of sibling list with hotplug

 kernel/events/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

-- 
1.9.1

