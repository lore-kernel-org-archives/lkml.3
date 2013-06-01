Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3FAJUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:20:38 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:53522 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3FAJUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:20:30 -0400
Message-ID: <51A9BCDA.9040006@colorfullife.com>
Date: Sat, 01 Jun 2013 11:20:26 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/4] ipc/sem: seperate wait-for-zero and alter tasks into
 seperate queues
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com> <1369559335-13491-3-git-send-email-manfred@colorfullife.com> <51A39E71.70900@redhat.com>
In-Reply-To: <51A39E71.70900@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------070806070006070903030607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070806070006070903030607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rik,

On 05/27/2013 07:57 PM, Rik van Riel wrote:
> On 05/26/2013 05:08 AM, Manfred Spraul wrote:
>> Introduce seperate queues for operations that do not modify the
>> semaphore values.
>> Advantages:
>> - Simpler logic in check_restart().
>> - Faster update_queue(): Right now, all wait-for-zero operations
>>    are always tested, even if the semaphore value is not 0.
>> - wait-for-zero gets again priority, as in linux <=3.0.9
>
> Whether this complexity is wanted is not for
> me to decide, as I am not the ipc/sem.c
> maintainer. I'll leave that up to Andrew and Linus.
>
We can have only one: Either more logic or unoptimized loops.
But I don't think that the complexity increases that much, e.g. some 
parts (e.g. check_restart()) get much simpler.

But:
Mike Galbraith ran 3.10-rc3 with and without my changes on a 4-socket 
64-core system, and for me the results appears to be quite slow:
- semop-multi 256 64: around 600.000 ops/sec, both with and without my 
additional patches [difference around 1%]
     That is slower than my 1.4 GHz i3 with 3.9 - I get around 1.000.000 
ops/sec
     Is that expected?
     My only idea would be trashing from writing sma->sem_otime.

- osim [i.e.: with reschedules] is much slower: around 21 us per schedule.
     Perhaps the scheduler didn't pair the threads optimally: intra-cpu 
reschedules
     take around 2 us on my i3, inter-cpu reschedules around 16 us.

Thus I have attached my test apps.
- psem: psem tests sleeping semaphore operations.
     Pairs of two threads perform ping-pong operations, starting with 1 
semaphore and increasing up to the given max.
     Either bound to the same cpu ("intra-cpu") or bound to different 
cpus ("inter-cpu").
     Inter-cpu is hardcoded, probably always a different socket 
(distance max_cpus/2).

- semscale performs operations that never block, i.e. like your 
semop-multi.c
     It does:
     - delays in user space to figure out what is the maximum number of 
operations possible taking into account that user space will do something.
     - use interleaving, to force the threads to different cores/sockets.

Perhaps something in 3.0.10-rc3 breaks the scalability?

--
     Manfred

--------------070806070006070903030607
Content-Type: text/x-c++src;
 name="psem.cpp"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="psem.cpp"

/*
 * psem.cpp, parallel sysv sem pingpong
 *
 * Copyright (C) 1999, 2001, 2005, 2008 by Manfred Spraul.
 *	All rights reserved except the rights granted by the GPL.
 *
 * Redistribution of this file is permitted under the terms of the GNU 
 * General Public License (GPL) version 2 or later.
 * $Header$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <pthread.h>

#ifdef __sun
	 #include <sys/pset.h> /* P_PID, processor_bind() */
#endif

#undef VERBOSE

//////////////////////////////////////////////////////////////////////////////

static enum {
	WAITING,
	RUNNING,
	STOPPED,
} volatile g_state = WAITING;

unsigned long long *g_results;
int *g_svsem_ids;
int *g_svsem_nrs;
pthread_t *g_threads;

struct taskinfo {
	int svsem_id;
	int svsem_nr;
	int threadid;
	int cpubind;
	int sender;
};

void bind_cpu(int cpunr)
{
#if __sun
	int ret;
	ret = processor_bind(P_PID, getpid(), cpunr, NULL);
	if (ret == -1) {
		perror("bind_thread:processor_bind");
		printf(" Binding to cpu %d failed.\n", cpunr);
	}
#else
	int ret;
	cpu_set_t cpus;
	cpu_set_t v;
	CPU_ZERO(&cpus);
	CPU_SET(cpunr, &cpus);
	pthread_t self;

	self = pthread_self();

	ret = pthread_setaffinity_np(self, sizeof(cpus), &cpus);
	if (ret < 0) {
		printf("pthread_setaffinity_np failed for thread %p with errno %d.\n",
				(void*)self, errno);
	}

	ret = pthread_getaffinity_np(self, sizeof(v), &v);
	if (ret < 0) {
		printf("pthread_getaffinity_np() failed for thread %p with errno %d.\n",
				(void*)self, errno);
		fflush(stdout);
	}
	if (memcmp(&v, &cpus, sizeof(cpus) != 0)) {
		printf("Note: Actual affinity does not match intention: got 0x%08lx, expected 0x%08lx.\n",
			(unsigned long)v.__bits[0], (unsigned long)cpus.__bits[0]);
	}
	fflush(stdout);
#endif
}
#define DATASIZE	8

void* worker_thread(void *arg)
{
	struct taskinfo *ti = (struct taskinfo*)arg;
	unsigned long long rounds;
	int ret;

	bind_cpu(ti->cpubind);
#ifdef VERBOSE
	printf("thread %d: sysvsem %8d, off %8d type %d bound to cpu %d\n",ti->threadid,
			ti->svsem_id, ti->svsem_nr,
			ti->sender, ti->cpubind);
#endif
	
	rounds = 0;
	while(g_state == WAITING) {
#ifdef __GNUC__
#if defined(__i386__) || defined (__x86_64__)
		__asm__ __volatile__("pause": : :"memory");
#else
		__asm__ __volatile__("": : :"memory");
#endif
#endif
	}

	if (ti->sender) {
		struct sembuf sop[1];

		/* 1) insert token */
		sop[0].sem_num=ti->svsem_nr+0;
		sop[0].sem_op=1;
		sop[0].sem_flg=0;
		ret = semop(ti->svsem_id,sop,1);
	
		if (ret != 0) {
			printf("Initial semop failed, ret %d, errno %d.\n", ret, errno);
			exit(1);
		}
	}
	while(g_state == RUNNING) {
		struct sembuf sop[1];

		/* 1) retrieve token */
		sop[0].sem_num=ti->svsem_nr+ti->sender;
		sop[0].sem_op=-1;
		sop[0].sem_flg=0;
		ret = semop(ti->svsem_id,sop,1);
		if (ret != 0) {
			/* EIDRM can happen */
			if (errno == EIDRM)
				break;

			/* Some OS do not report EIDRM properly */
			if (g_state != RUNNING)
				break;
			printf("main semop failed, ret %d errno %d.\n", ret, errno);
			printf(" round %lld sop: num %d op %d flg %d.\n",
					rounds,
					sop[0].sem_num, sop[0].sem_op, sop[0].sem_flg);
			fflush(stdout);
			exit(1);
		}

		/* 2) reinsert token */
		sop[0].sem_num=ti->svsem_nr+1-ti->sender;
		sop[0].sem_op=1;
		sop[0].sem_flg=0;
		ret = semop(ti->svsem_id,sop,1);
		if (ret != 0) {
			/* EIDRM can happen */
			if (errno == EIDRM)
				break;
			/* Some OS do not report EIDRM properly */
			if (g_state != RUNNING)
				break;
			printf("main semop failed, ret %d errno %d.\n", ret, errno);
			printf(" round %lld sop: num %d op %d flg %d.\n",
					rounds,
					sop[0].sem_num, sop[0].sem_op, sop[0].sem_flg);
			fflush(stdout);
			exit(1);
		}
		rounds++;
	}
	g_results[ti->threadid] = rounds;

	pthread_exit(0);
	return NULL;
}

void init_threads(int cpu, int cpus, int sems, int shared)
{
	int ret;
	struct taskinfo *ti1, *ti2;

	ti1 = (struct taskinfo*)malloc(sizeof(struct taskinfo));
	ti2 = (struct taskinfo*)malloc(sizeof(struct taskinfo));
	if (!ti1 || !ti2) {
		printf("Could not allocate task info\n");
		exit(1);
	}
	if (cpu % sems == 0) {
		int i;
		g_svsem_ids[cpu] = semget(IPC_PRIVATE,2*sems,0777|IPC_CREAT);
		if(g_svsem_ids[cpu] == -1) {
			printf("sem array create failed.\n");
			exit(1);
		}
		for (i=0;i<sems;i++) {
			g_svsem_ids[cpu+i] = g_svsem_ids[cpu];
			g_svsem_nrs[cpu+i] = 2*i;
		}
	}

	g_results[cpu] = 0;
	g_results[cpu+cpus] = 0;

	ti1->svsem_id = g_svsem_ids[cpu];
	ti1->svsem_nr = g_svsem_nrs[cpu];
	ti1->threadid = cpu;
	ti1->cpubind = cpu;
	ti1->sender = 1;
	ti2->svsem_id = g_svsem_ids[cpu];
	ti2->svsem_nr = g_svsem_nrs[cpu];
	ti2->threadid = cpu+cpus;
	if (shared) {
		ti2->cpubind = cpu;
	} else {
		ti2->cpubind = cpus+cpu;
	}
	ti2->sender = 0;

	ret = pthread_create(&g_threads[ti1->threadid], NULL, worker_thread, ti1);
	if (ret) {
		printf(" pthread_create failed with error code %d\n", ret);
		exit(1);
	}
	ret = pthread_create(&g_threads[ti2->threadid], NULL, worker_thread, ti2);
	if (ret) {
		printf(" pthread_create failed with error code %d\n", ret);
		exit(1);
	}
}

//////////////////////////////////////////////////////////////////////////////

void do_psem(int queues, int timeout, int shared)
{
	unsigned long long totals;
	int i;
	int sems = queues; /* No need to test multiple arrays: that part scales linearly */

	g_state = WAITING;

	g_results = (unsigned long long*)malloc(sizeof(unsigned long long)*2*queues);
	g_svsem_ids = (int*)malloc(sizeof(int)*(queues+sems));
	g_svsem_nrs = (int*)malloc(sizeof(int)*(queues+sems));
	g_threads = (pthread_t*)malloc(sizeof(pthread_t)*2*queues);
	for (i=0;i<queues;i++) {
		init_threads(i, queues, sems, shared);
	}

	usleep(10000);
	g_state = RUNNING;
	sleep(timeout);
	g_state = STOPPED;
	usleep(10000);
	for (i=0;i<queues;i++) {
		int res;
		if (g_svsem_nrs[i] == 0) {
			res = semctl(g_svsem_ids[i],1,IPC_RMID,NULL);
			if (res < 0) {
				printf("semctl(IPC_RMID) failed for %d, errno%d.\n",
					g_svsem_ids[i], errno);
			}
		}
	}
	for (i=0;i<2*queues;i++)
		pthread_join(g_threads[i], NULL);

#ifdef VERBOSE
	printf("Result matrix:\n");
#endif
	totals = 0;
	for (i=0;i<queues;i++) {
#ifdef VERBOSE
		printf("  Thread %3d: %8lld     %3d: %8lld\n",
				i, g_results[i], i+queues, g_results[i+queues]);
#endif
		totals += g_results[i] + g_results[i+queues];
	}
	printf("Queues: %d (%s) %lld in %d secs\n", queues, shared ? "intra-cpu" : "inter-cpu",
			totals, timeout);

	free(g_results);
	free(g_svsem_ids);
	free(g_svsem_nrs);
	free(g_threads);
}

//////////////////////////////////////////////////////////////////////////////

int main(int argc, char **argv)
{
	int max_cpus;
	int timeout;
	int i;

	printf("psem [max cpus] [timeout]\n");
	if (argc != 3) {
		printf(" Invalid parameters.\n");
		return 0;
	}
	max_cpus = atoi(argv[1]);
	timeout = atoi(argv[2]);
	/* Intra-cpu */
	for (i=1;i<=max_cpus;i++) {
		usleep(10000);
		do_psem(i, timeout, 1);
	}
	/* Inter-cpu */
	for (i=1;i<=max_cpus/2;i++) {
		usleep(10000);
		do_psem(i, timeout, 0);
	}

}

--------------070806070006070903030607
Content-Type: text/x-c++src;
 name="semscale.cpp"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="semscale.cpp"

/*
 * semscale.cpp - sysv scaling test
 *
 * Copyright (C) 1999, 2001, 2005, 2008, 2010 by Manfred Spraul.
 *	All rights reserved except the rights granted by the GPL.
 *
 * Redistribution of this file is permitted under the terms of the GNU 
 * General Public License (GPL) version 2 or later.
 * $Header$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <pthread.h>

#ifdef __sun
	 #include <sys/pset.h> /* P_PID, processor_bind() */
#endif

#define VERBOSE
#undef VERBOSE

//////////////////////////////////////////////////////////////////////////////

#define DELAY_LOOPS	20

static volatile int g_numerator = 12345678;
static volatile int g_denominator = 123456;

unsigned long long do_delay(int loops)
{
	unsigned long long sum;
	int i, j;

	sum = loops;
	for (i=0;i<loops;i++) {
		for (j=0;j<DELAY_LOOPS*loops;j++) {
			sum += g_numerator/g_denominator;
		}
	}
	return sum;
}

//////////////////////////////////////////////////////////////////////////////

#define DELAY_10MS	(10000)

static enum {
	WAITING,
	RUNNING,
	STOPPED,
} volatile g_state = WAITING;

unsigned long long *g_results;
int g_svsem_id;
int g_max_cpus;
int *g_svsem_nrs;
pthread_t *g_threads;

struct taskinfo {
	int svsem_id;
	int svsem_nr;
	int threadid;
	int cpubind;
	int interleave;
	int delay;
};

int get_cpunr(int cpunr, int interleave)
{
	int off = 0;
	int ret = 0;

#ifdef VERBOSE
	printf("get_cpunr %p: cpunr %d max_cpu %d interleave %d.\n",
		(void*)pthread_self(), cpunr, g_max_cpus, interleave);
#endif

	while (cpunr>0) {
		ret += interleave;
		if (ret >=g_max_cpus) {
			off++;
			ret = off;
		}
		cpunr--;
	}
#ifdef VERBOSE
	printf("get_cpunr %p: result %d.\n", (void*)pthread_self(), ret);
#endif
	return ret;
}

void bind_cpu(int cpunr)
{
	int ret;
#if __sun
	ret = processor_bind(P_PID, getpid(), cpunr, NULL);
	if (ret == -1) {
		perror("bind_thread:processor_bind");
		printf(" Binding to cpu %d failed.\n", cpunr);
	}
#else
	cpu_set_t cpus;
	cpu_set_t v;
	CPU_ZERO(&cpus);
	CPU_SET(cpunr, &cpus);
	pthread_t self;

	self = pthread_self();

	ret = pthread_setaffinity_np(self, sizeof(cpus), &cpus);
	if (ret < 0) {
		printf("pthread_setaffinity_np failed for thread %p with errno %d.\n",
				(void*)self, errno);
	}

	ret = pthread_getaffinity_np(self, sizeof(v), &v);
	if (ret < 0) {
		printf("pthread_getaffinity_np() failed for thread %p with errno %d.\n",
				(void*)self, errno);
		fflush(stdout);
	}
	if (memcmp(&v, &cpus, sizeof(cpus) != 0)) {
		printf("Note: Actual affinity does not match intention: got 0x%08lx, expected 0x%08lx.\n",
			(unsigned long)v.__bits[0], (unsigned long)cpus.__bits[0]);
	}
	fflush(stdout);
#endif
}

void* worker_thread(void *arg)
{
	struct taskinfo *ti = (struct taskinfo*)arg;
	unsigned long long rounds;
	int ret;
	int cpu = get_cpunr(ti->cpubind, ti->interleave);

	bind_cpu(cpu);
#ifdef VERBOSE
	printf("thread %d: sysvsem %8d, off %8d bound to cpu %d\n",ti->threadid,
			ti->svsem_id, ti->svsem_nr,cpu);
#endif
	
	rounds = 0;
	while(g_state == WAITING) {
#ifdef __GNUC__
#if defined(__i386__) || defined (__x86_64__)
		__asm__ __volatile__("pause": : :"memory");
#else
		__asm__ __volatile__("": : :"memory");
#endif
#endif
	}

	while(g_state == RUNNING) {
		struct sembuf sop[1];

		/* 1) check if the semaphore value is 0 */
		sop[0].sem_num=ti->svsem_nr;
		sop[0].sem_op=0;
		sop[0].sem_flg=0;
		ret = semop(ti->svsem_id,sop,1);
		if (ret != 0) {
			/* EIDRM can happen */
			if (errno == EIDRM)
				break;

			printf("main semop failed, ret %d errno %d.\n", ret, errno);

			/* Some OS do not report EIDRM properly */
			if (g_state != RUNNING)
				break;
			printf(" round %lld sop: num %d op %d flg %d.\n",
					rounds,
					sop[0].sem_num, sop[0].sem_op, sop[0].sem_flg);
			fflush(stdout);
			exit(1);
		}
		if (ti->delay)
			do_delay(ti->delay);
		rounds++;
	}
	g_results[ti->threadid] = rounds;

	pthread_exit(0);
	return NULL;
}

void init_threads(int cpu, int cpus, int delay, int interleave)
{
	int ret;
	struct taskinfo *ti;

	ti = (struct taskinfo*)malloc(sizeof(struct taskinfo));
	if (!ti) {
		printf("Could not allocate task info\n");
		exit(1);
	}
	if (cpu == 0) {
		int i;
		g_svsem_id = semget(IPC_PRIVATE,cpus,0777|IPC_CREAT);
		if(g_svsem_id == -1) {
			printf("sem array create failed.\n");
			exit(1);
		}
		for (i=0;i<cpus;i++)
			g_svsem_nrs[i] = i;
	}

	g_results[cpu] = 0;

	ti->svsem_id = g_svsem_id;
	ti->svsem_nr = g_svsem_nrs[cpu];
	ti->threadid = cpu;
	ti->cpubind = cpu;
	ti->interleave = interleave;
	ti->delay = delay;

	ret = pthread_create(&g_threads[ti->threadid], NULL, worker_thread, ti);
	if (ret) {
		printf(" pthread_create failed with error code %d\n", ret);
		exit(1);
	}
}

//////////////////////////////////////////////////////////////////////////////

unsigned long long do_psem(int cpus, int timeout, int delay, int interleave)
{
	unsigned long long totals;
	int i;
	int res;

	g_state = WAITING;

	g_results = (unsigned long long*)malloc(sizeof(unsigned long long)*cpus);
	g_svsem_nrs = (int*)malloc(sizeof(int)*cpus);
	g_threads = (pthread_t*)malloc(sizeof(pthread_t)*cpus);

	for (i=0;i<cpus;i++)
		init_threads(i, cpus, delay, interleave);

	usleep(DELAY_10MS);
	g_state = RUNNING;
	sleep(timeout);
	g_state = STOPPED;
	usleep(DELAY_10MS);

	res = semctl(g_svsem_id,1,IPC_RMID,NULL);
	if (res < 0) {
		printf("semctl(IPC_RMID) failed for %d, errno%d.\n",
			g_svsem_id, errno);
	}

	for (i=0;i<cpus;i++)
		pthread_join(g_threads[i], NULL);

#ifdef VERBOSE
	printf("Result matrix:\n");
#endif
	totals = 0;
	for (i=0;i<cpus;i++) {
#ifdef VERBOSE
		printf("  Thread %3d: %8lld\n",
				i, g_results[i]);
#endif
		totals += g_results[i];
	}
	printf("Cpus %d, interleave %d delay %d: %lld in %d secs\n",
			cpus, interleave, delay,
			totals, timeout);

	free(g_results);
	free(g_svsem_nrs);
	free(g_threads);

	return totals;
}

//////////////////////////////////////////////////////////////////////////////

int main(int argc, char **argv)
{
	int timeout;
	unsigned long long totals, max_totals;
	int max_interleave;
	int fastest;
	int i, j, k;

	printf("semscale [timeout] <max interleave> <max cpus>\n");

	if (argc < 2) {
		printf(" Invalid parameters.\n");
		return 0;
	}
	timeout = atoi(argv[1]);

	if (argc > 2) {
		max_interleave = atoi(argv[2]);
	} else {
		max_interleave = 16;
	}

	if (argc > 3) {
		g_max_cpus = atoi(argv[3]);
	} else {
		cpu_set_t cpus;
		int ret;

		ret = pthread_getaffinity_np(pthread_self(), sizeof(cpus), &cpus);
		if (ret < 0) {
			printf("pthread_getaffinity_np() failed with errno %d.\n", errno);
			fflush(stdout);
			g_max_cpus = 4;
		} else {
			g_max_cpus = 0;
			while (CPU_ISSET(g_max_cpus, &cpus))
				g_max_cpus++;
		}
		if (g_max_cpus == 0) {
			printf("Autodetection of the number of cpus failed.\n");
			return 1;
		}
		printf("Autodetected number of cpus: %d.\n", g_max_cpus);
	}
	if (g_max_cpus >= 2) {
		while (max_interleave >= g_max_cpus) {
			max_interleave = max_interleave/2;
		}
	} else {
		max_interleave = 1;
	}
	printf("Adjusted max interleave: %d.\n", max_interleave);

	for (k=1;k<=max_interleave;k*=2) {
		for (j=0;;) {
			max_totals = 0;
			fastest = 0;
			for (i=1;;) {
				totals = do_psem(i, timeout, j, k);
				if (totals > max_totals) {
					max_totals = totals;
					fastest = i;
				} else {
					if (totals < 0.5*max_totals && i > 1.5*fastest)
						break;
				}
				if (i== g_max_cpus)
					break;
				i += i * 0.2 + 1;
				if (i > g_max_cpus)
					i = g_max_cpus;
			}
			printf("Interleave %d, delay %d: Max total: %lld with %d cpus\n",
					k, j, max_totals, fastest);
			if (fastest == g_max_cpus)
				break;
			j += j * 0.2 + 1;
		}
	}
}

--------------070806070006070903030607--
