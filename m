Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaHOUHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 16:07:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaHOUHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 16:07:19 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: oleg@redhat.com, peterz@infradead.org, umgwanakikbuti@gmail.com,
        fweisbec@gmail.com, akpm@linux-foundation.org, srao@redhat.com,
        lwoodman@redhat.com, atheurer@redhat.com
Subject: [PATCH 0/3] lockless sys_times and posix_cpu_clock_get
Date: Fri, 15 Aug 2014 16:05:35 -0400
Message-Id: <1408133138-22048-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to the feedback from Oleg, Peter, Mike, and Frederic,
I seem to have a patch series that manages to do times()
locklessly, and apparently correctly.

Oleg points out that the monotonicity alone is not enough of a
guarantee, but that should probably be attacked separately, since
that issue is equally present with and without these patches...

The test case below, slightly changed from the one posted by Spencer
Candland in 2009, now runs in 11 seconds instead of 5 minutes.

Is it worthwhile?  There apparently are some real workloads that call
times() a lot, and I believe Sanjay and Andrew have one sitting around.

--------

/*

Based on the test case from the following bug report, but changed
to measure utime on a per thread basis. (Rik van Riel)

https://lkml.org/lkml/2009/11/3/522

From: Spencer Candland
Subject: utime/stime decreasing on thread exit

I am seeing a problem with utime/stime decreasing on thread exit in a
multi-threaded process.  I have been able to track this regression down
to the "process wide cpu clocks/timers" changes introduces in
2.6.29-rc5, specifically when I revert the following commits I know
longer see decreasing utime/stime values:

4da94d49b2ecb0a26e716a8811c3ecc542c2a65d
3fccfd67df79c6351a156eb25a7a514e5f39c4d9
7d8e23df69820e6be42bcc41d441f4860e8c76f7
4cd4c1b40d40447fb5e7ba80746c6d7ba91d7a53
32bd671d6cbeda60dc73be77fa2b9037d9a9bfa0

I poked around a little, but I am afraid I have to admit that I am not
familiar enough with how this works to resolve this or suggest a fix.

I have verified this in happening in kernels 2.6.29-rc5 - 2.6.32-rc6, I
have been testing this on x86 vanilla kernels, but have also verified it
on several x86 2.6.29+ distro kernels (fedora and ubuntu).

I first noticed this on a production environment running Apache with the
worker MPM, however while tracking this down I put together a simple
program that has been reliable in showing me utime decreasing, hopefully
it will be helpful in demonstrating the issue:
*/

#include <stdio.h>
#include <pthread.h>
#include <sys/times.h>

#define NUM_THREADS 500

struct tms start;

void *pound (void *threadid)
{
  struct tms end;
  int oldutime = 0;
  int utime;
  int c, i;
  for (i = 0; i < 10000; i++) {
	  for (c = 0; c < 10000; c++);
	  times(&end);
	  utime = ((int)end.tms_utime - (int)start.tms_utime);
	  if (oldutime > utime) {
	    printf("utime decreased, was %d, now %d!\n", oldutime, utime);
	  }
	  oldutime = utime;
  }
  pthread_exit(NULL);
}

int main()
{
  pthread_t th[NUM_THREADS];
  long i;
  times(&start);
  for (i = 0; i < NUM_THREADS; i++) {
    pthread_create (&th[i], NULL, pound, (void *)i);
  }
  pthread_exit(NULL);
  return 0;
}

