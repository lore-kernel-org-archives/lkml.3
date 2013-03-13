Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3CMJok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:44:40 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58696 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3CMJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:44:36 -0400
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 0/8]Perf: Make the 'perf top -p $pid' can perceive the new forked threads.
Date: Wed, 13 Mar 2013 17:42:20 +0800
Message-Id: <1363167740-27735-9-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

This patch set base on the 3.8.rc7 kernel.

Here is the version 3, I optimized the performance and structure in this version.

This patch set add a function that make the 'perf top -p $pid' is able to perceive
the new threads that is forked by target processes. 'perf top{record} -p $pid' can
perceive the threads are forked before we execute perf, but it cannot perceive the
new threads are forked after we started perf. This is perf's important defect, because
the applications who will fork new threads on-the-fly are very much.
For performance reasons, the event inherit mechanism is forbidden while we use per-task
counters. Some internal data structures, such as, thread_map, evlist->mmap, evsel->fd,
evsel->id, evsel->sample_id are implemented as arrays at the initialization phase.
Their size is fixed, and they cannot be extended easily while we want to expend them
for new forked threads.

So, we have done the following work:
1) Transformed thread_map to linked list.
   Implemented the interfaces to extand and shrink a exist thread_map.
2) Transformed xyarray to linked list. Implementd the interfaces to extand and shrink
   a exist xyarray.
   The xyarray is a 2-dimensional structure.
   The x-dimension is cpus, and the x-dimension is a array still.
   The y-dimension is threads of interest, and the y-dimension are linked list.
3) Implemented evlist->mmap, evsel->fd, evsel->id and evsel->sample_id with the new xyarray.
   Implemented interfaces to expand and shrink these structures.
4) Added 2 callback functions to top->perf_tool, they are called while the PERF_RECORD_FORK
   & PERF_RECORD_EXIT events are got.
   While a PERF_RECORD_FORK event is got, all related data structures are expanded, a new
   fd and mmap are opened.
   While a PERF_RECORD_EXIT event is got, all nodes in the related data structures are
   removed.

The linked list is flexible, list_add & list_del can be used easily. Additional, performance
penalty (especially the CPU utilization) is low.

At the last of this coverletter, I attached a test program and its Makefile. After it is 
executed, we will get its pid. Then, use this command:
'perf top -p *pid*'
The perf top will perceive the functions that called by the threads forked on-the-fly.
We could use 'top' tool to monitor the overhead of 'perf'. The result shows the cpu overhead
of this patch set is less than 3%. I think this overhead can be accepted.

My test environment is as follows:
# ========
# captured on: Wed Mar 13 15:23:55 2013
# perf version : 3.8.rc7.ga39f52
# arch : x86_64
# nrcpus online : 2
# nrcpus avail : 2
# cpudesc : Intel(R) Core(TM)2 Duo CPU P8700 @ 2.53GHz
# cpuid : GenuineIntel,6,23,10
# total memory : 3034932 kB
#========

This function has been already implemented for 'perf top -p $pid' in the patch
[8/8] of this patch set. Next step, the 'perf record -p $pid' should be modified
with the same method.

Thanks for David Ahern's suggestion.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

chenggang (8):
  changed thread_map to list
  changed xyarray to list
  hanged mmap to xyarray
  changed evsel->id to xyarray
  extend mechanism for evsel->id & evsel->fd
  add some operations for mmap
  changed the method to traverse mmap list
  fork & exit event perceived

 tools/perf/Makefile                       |    3 +-
 tools/perf/builtin-record.c               |    8 +-
 tools/perf/builtin-stat.c                 |    2 +-
 tools/perf/builtin-top.c                  |  116 ++++++++++++-
 tools/perf/tests/mmap-basic.c             |    4 +-
 tools/perf/tests/open-syscall-tp-fields.c |    9 +-
 tools/perf/tests/perf-record.c            |    7 +-
 tools/perf/util/event.c                   |   12 +-
 tools/perf/util/evlist.c                  |  206 +++++++++++++++++++---
 tools/perf/util/evlist.h                  |   14 +-
 tools/perf/util/evsel.c                   |  118 +++++++++++--
 tools/perf/util/evsel.h                   |   13 +-
 tools/perf/util/header.c                  |   28 +--
 tools/perf/util/header.h                  |    3 +-
 tools/perf/util/python.c                  |    6 +-
 tools/perf/util/thread_map.c              |  265 +++++++++++++++++++++--------
 tools/perf/util/thread_map.h              |   16 +-
 tools/perf/util/xyarray.c                 |  125 +++++++++++++-
 tools/perf/util/xyarray.h                 |   68 +++++++-
 19 files changed, 866 insertions(+), 157 deletions(-)

---
Here is a program to test the patch set.

---
#include <time.h>
#include <stdio.h>
#include <pthread.h>
#include <math.h>
#include <sys/types.h>
#include <linux/unistd.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <fcntl.h>

#define CHILDREN_NUM 15000
#define UINT_MAX        (~0U)

unsigned int new_rand(unsigned int min, unsigned int max)
{
	int fd;
	unsigned int n = 0;

	fd = open("/dev/urandom", O_RDONLY);

	if (fd > 0) {
		read(fd, &n, sizeof (n));
	}
	close(fd);

	return (unsigned int)((double)n / UINT_MAX * (max - min) + min);
}

pid_t gettid(void)
{
	return syscall(SYS_gettid);
}

static inline unsigned long long rdclock(void)
{
	struct timespec ts; 

	clock_gettime(CLOCK_MONOTONIC, &ts);
	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}

int do_pi(int p){
	double mypi,h,sum,x;
	long long  n,i;

	double cost_time;
	unsigned int exec_time;
	unsigned long long start, end;

	int ret;
	pthread_t	new_thread_id;

	printf("new thread[%d]: %d tid: %d ppid: %d\n", getpid(), p, gettid(), getppid());

	exec_time = new_rand(50, 10000000);
	start = rdclock();

	while(1) {
		n = 5000;
		h = 1.0/n;
		sum=0.0;

		for (i = 1; i <= n; i+=1 ) {
			x = h * ( i - 0.5 ) ;
			sum += 4.0 / ( 1.0 + pow(x,2) ) ;
		}

		mypi = h * sum;

		end = rdclock();

		cost_time = (double)(end-start) / 1e3;
		if (cost_time > (double) exec_time) //microsecond
			break;
	}

	return 0;
}

int main()
{
	int i=0, ret=0;
	int j;	

	pthread_t id[CHILDREN_NUM];
	pthread_t id2[CHILDREN_NUM];

	printf("pid: %d\n", getpid());

	sleep(8);

	for(j=0; j<CHILDREN_NUM; j++){
		ret = pthread_create(id+j, NULL, (void*)do_pi, j);
		if (ret){
			printf("Create pthread error!\n");
			return 1;
		}
		usleep(new_rand(500, 1000)); 
	}	

	for(j=0; j<CHILDREN_NUM; j++)
		pthread_join(id[j], NULL);

	return 0;
}

---
If the filename of the last program file is "thread", follow is the Makefile for it.

---
EXEC = thread

OBJS = thread.o

HEADERS =

CC = gcc

INC = -I. -I/usr/include

CFLAGS = ${INC} -L/usr/lib/x86_64-linux-gnu -lpthread -g -ldl -lrt

all:${EXEC}
${EXEC} : ${OBJS}
	${CC} -o $@ ${OBJS}  ${CFLAGS} ${LDFLAGS}

${OBJS} : ${HEADERS}

.PHONY : clean
clean :
	rm -f ${OBJS} ${EXEC}

-- 
1.7.9.5
