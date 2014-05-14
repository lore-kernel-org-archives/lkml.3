Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaENHhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:37:03 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43691 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaENHhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:37:00 -0400
Message-ID: <53731D12.7040804@linux.vnet.ibm.com>
Date: Wed, 14 May 2014 15:36:50 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <537192D3.5030907@linux.vnet.ibm.com> <20140513094737.GU30445@twins.programming.kicks-ass.net> <53721FD4.6060300@redhat.com> <20140513142328.GE2485@laptop.programming.kicks-ass.net>
In-Reply-To: <20140513142328.GE2485@laptop.programming.kicks-ass.net>
Content-Type: multipart/mixed;
 boundary="------------070107070000070607010405"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051407-1396-0000-0000-000004D6AACE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070107070000070607010405
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi, Peter

On 05/13/2014 10:23 PM, Peter Zijlstra wrote:
[snip]
> 
> I you want to investigate !spinners, replace the ABC with slightly more
> complex loads like: https://lkml.org/lkml/2012/6/18/212

I've done a little reform, enabled multi-threads and add a mutex,
please check the code below for details.

I built it by:
	gcc -o my_tool cgroup_tool.c -lpthread

distro mount cpu-subsys under '/sys/fs/cgroup/cpu', create group like:
	mkdir /sys/fs/cgroup/cpu/A
	mkdir /sys/fs/cgroup/cpu/B
	mkdir /sys/fs/cgroup/cpu/C

and then:
	echo $$ > /sys/fs/cgroup/cpu/A/tasks ; ./my_tool -l
	echo $$ > /sys/fs/cgroup/cpu/B/tasks ; ./my_tool -l
	echo $$ > /sys/fs/cgroup/cpu/C/tasks ; ./my_tool 50

the results in top is around:

		A	B	C
	CPU%	550	550	100

While only './my_tool 50' was running, it require around 300%.

And this could also be reproduced by dbench, stress combination like:
	echo $$ > /sys/fs/cgroup/cpu/A/tasks ; dbench 6
	echo $$ > /sys/fs/cgroup/cpu/B/tasks ; stress -c 6
	echo $$ > /sys/fs/cgroup/cpu/C/tasks ; stress -c 6

Now it seems more like a generic problem... will keep investigating, please
let me know if there are any suggestions :)

Regards,
Michael Wang



#include <sys/time.h>
#include <unistd.h>
#include <stdio.h>
#include <pthread.h>

pthread_mutex_t my_mutex;

unsigned long long stamp(void)
{
	struct timeval tv;
	gettimeofday(&tv, NULL);

	return (unsigned long long)tv.tv_sec * 1000000 + tv.tv_usec;
}
void consume(int spin, int total)
{
	unsigned long long begin, now;
	begin = stamp();

	for (;;) {
		pthread_mutex_lock(&my_mutex);
		now = stamp();
		if ((long long)(now - begin) > spin) {
			pthread_mutex_unlock(&my_mutex);
			usleep(total - spin);
			pthread_mutex_lock(&my_mutex);
			begin += total;
		}
		pthread_mutex_unlock(&my_mutex);
	}
}

struct my_data {
	int spin;
	int total;
};

void *my_fn_sleepy(void *arg)
{
	struct my_data *data = (struct my_data *)arg;
	consume(data->spin, data->total);
	return NULL;
}

void *my_fn_loop(void *arg)
{
	while (1) {};
	return NULL;
}

int main(int argc, char **argv)
{
	int period = 100000; /* 100ms */
	int frac;
	struct my_data data;
	pthread_t last_thread;
	int thread_num = sysconf(_SC_NPROCESSORS_ONLN) / 2;
	void *(*my_fn)(void *arg) = &my_fn_sleepy;

	if (thread_num <= 0 || thread_num > 1024) {
		fprintf(stderr, "insane processor(half) size %d\n", thread_num);
		return -1;
	}

	if (argc == 2 && !strcmp(argv[1], "-l")) {
		my_fn = &my_fn_loop;
		printf("loop mode enabled\n");
		goto loop_mode;
	}

	if (argc < 2) {
		fprintf(stderr, "%s <frac> [<period>]\n"
				"  frac   -- [1-100] %% of time to burn\n"
				"  period -- [usec] period of burn/sleep cycle\n",
				argv[0]);
		return -1;
	}

	frac = atoi(argv[1]);
	if (argc > 2)
		period = atoi(argv[2]);
	if (frac > 100)
		frac = 100;
	if (frac < 1)
		frac = 1;

	data.spin = (period * frac) / 100;
	data.total = period;

loop_mode:
	pthread_mutex_init(&my_mutex, NULL);
	while (thread_num--) {
		if (pthread_create(&last_thread, NULL, my_fn, &data)) {
			fprintf(stderr, "Create thread failed\n");
			return -1;
		}
	}

	printf("Threads never stop, CTRL + C to terminate\n");

	pthread_join(last_thread, NULL);
	pthread_mutex_destroy(&my_mutex);	//won't happen
	return 0;
}

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


--------------070107070000070607010405
Content-Type: text/x-csrc;
 name="cgroup_tool.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cgroup_tool.c"

#include <sys/time.h>
#include <unistd.h>
#include <stdio.h>
#include <pthread.h>

pthread_mutex_t my_mutex;

unsigned long long stamp(void)
{
	struct timeval tv;
	gettimeofday(&tv, NULL);

	return (unsigned long long)tv.tv_sec * 1000000 + tv.tv_usec;
}
void consume(int spin, int total)
{
	unsigned long long begin, now;
	begin = stamp();

	for (;;) {
		pthread_mutex_lock(&my_mutex);
		now = stamp();
		if ((long long)(now - begin) > spin) {
			pthread_mutex_unlock(&my_mutex);
			usleep(total - spin);
			pthread_mutex_lock(&my_mutex);
			begin += total;
		}
		pthread_mutex_unlock(&my_mutex);
	}
}

struct my_data {
	int spin;
	int total;
};

void *my_fn_sleepy(void *arg)
{
	struct my_data *data = (struct my_data *)arg;
	consume(data->spin, data->total);
	return NULL;
}

void *my_fn_loop(void *arg)
{
	while (1) {};
	return NULL;
}

int main(int argc, char **argv)
{
	int period = 100000; /* 100ms */
	int frac;
	struct my_data data;
	pthread_t last_thread;
	int thread_num = sysconf(_SC_NPROCESSORS_ONLN) / 2;
	void *(*my_fn)(void *arg) = &my_fn_sleepy;

	if (thread_num <= 0 || thread_num > 1024) {
		fprintf(stderr, "insane processor(half) size %d\n", thread_num);
		return -1;
	}

	if (argc == 2 && !strcmp(argv[1], "-l")) {
		my_fn = &my_fn_loop;
		printf("loop mode enabled\n");
		goto loop_mode;
	}

	if (argc < 2) {
		fprintf(stderr, "%s <frac> [<period>]\n"
				"  frac   -- [1-100] %% of time to burn\n"
				"  period -- [usec] period of burn/sleep cycle\n",
				argv[0]);
		return -1;
	}

	frac = atoi(argv[1]);
	if (argc > 2)
		period = atoi(argv[2]);
	if (frac > 100)
		frac = 100;
	if (frac < 1)
		frac = 1;

	data.spin = (period * frac) / 100;
	data.total = period;

loop_mode:
	pthread_mutex_init(&my_mutex, NULL);
	while (thread_num--) {
		if (pthread_create(&last_thread, NULL, my_fn, &data)) {
			fprintf(stderr, "Create thread failed\n");
			return -1;
		}
	}

	printf("Threads never stop, CTRL + C to terminate\n");

	pthread_join(last_thread, NULL);
	pthread_mutex_destroy(&my_mutex);	//won't happen
	return 0;
}

--------------070107070000070607010405--

