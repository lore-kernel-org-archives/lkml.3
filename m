Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab3LDRm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:42:26 -0500
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:37275 "EHLO
	prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932167Ab3LDRmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:42:24 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Dec 2013 12:42:24 EST
From: "Pavey, Nicholas" <npavey@akamai.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 4 Dec 2013 12:42:21 -0500
Subject: Using perf to locate source of context switches
Thread-Topic: Using perf to locate source of context switches
Thread-Index: Ac7xGDBOLiKrZfACSLa7Ra0W8r6PHA==
Message-ID: <CEC4D35C.A428%npavey@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB4HgW2h002970

This is my first post here. Apologies in advance if I don't get the
etiquette quite right.


Background
==========

We have an application which is exhibiting very large performance problems
under some loads.

We noticed extremely high context switch rates under the load in question.
Rates can be up to ~1.2e6 switches / second (as reported by sar -w) on a 4
physical core hyper-threaded Xeon 3.4GHz machine.

While we don't yet know if this is the root cause of the performance
problems, we'd very much like to understand what code path is triggering
this behavior.

Our theory is that the context switching is caused by a few very heavily
contended futuxes, but we need to develop evidence to support or disprove
this theory.

We are trying to use 'perf' to understand what's going on. We have been
using the following command to sample the call graph as the load runs :

   perf record Â­e cs Â­g â€¹ <load generator tool>
   perf report -G 

We're specifically interested in the context switching behavior, not
profiling the application to see where the time is going (we already know
where our hot spot is here).


NB: I have also used 'perf record -e cs -g -a -- sleep 2', while the
application is running as a separate process. The results appear to be
similar, except that data for all running processes is included in the
report (as you would expect).



The problem
===========

We have recompiled the production system so it's statically linked, not
optimized and has the frame pointers included in the image.

The problem is that 'perf report' is generating good symbols for the
kernel but the contended symbols we're interested in are showing up as hex
addresses. Additionally, the hex values are very low (e.g. 0x14).

We could manually resolve these hex addresses, but I checked the contents
of the ELF image and there is no data that low in the address space. This
makes us suspect that the address data may be incorrect.


Example code
============

Since the production system is large, not always well understood and
profiling it is giving unexpected results, I thought I'd check the
behavior of 'perf' with much simpler code.

I tweaked a bit of C I lifted off the web so it causes high context switch
rates. I am profiling that simple code to understand how the 'perf'
toolchain works.

In this case, I'm not seeing the suspicious hex addresses. However, I'm
also not seeing the symbols in my test code where the futex calls
originate - this is what we ultimately want to see.

To double check that this isn't just a display issue, I have looked at the
contents of the 'perf.data' file with 'perf script'. It does appear that
all the symbols are either in kernel space or the pthreads library.

The code and compilation commands are attached to the end of this email.


Perf report output
==================

# captured on: Wed Dec  4 15:55:25 2013
# hostname : XXXXX
# os release : 3.10.19-3.10.0-amd64-11777104
# perf version : 3.10.19-3.10.0-amd64-11777104
# arch : x86_64
# nrcpus online : 8
# nrcpus avail : 8
# cpudesc : Intel(R) Xeon(R) CPU E31270 @ 3.40GHz
# cpuid : GenuineIntel,6,42,7
# total memory : 16445052 kB
# cmdline : /usr/local/bin/perf record -e cs -g -- ../mutex_example
# event : name = cs, type = 1, config = 0x3, config1 = 0x0, config2 = 0x0,
excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, tracepoint = 2, uncore_cbox_0 = 6,
uncore_cbox_1 = 7, uncore_cbox_2 = 8, uncore_cbox_3 = 9, breakpoint = 5
# ========
#
# Samples: 21K of event 'cs'
# Event count (approx.): 616402
#
# Overhead        Command      Shared Object        Symbol
# ........  .............  .................  ............
#
   100.00%  mutex_example  [kernel.kallsyms]  [k] schedule
            |      
            |--98.95%-- start_thread
            |          |
            |          |--53.06%-- __lll_mutex_lock_wait
            |          |          system_call
            |          |          SyS_futex
            |          |          do_futex
            |          |          futex_wait
            |          |          |
            |          |          |--56.41%-- futex_wait_setup
            |          |          |          get_futex_key
            |          |          |          __lock_page
            |          |          |          __wait_on_bit_lock
            |          |          |          sleep_on_page
            |          |          |          io_schedule
            |          |          |          schedule
            |          |          |
            |          |           --43.59%-- futex_wait_queue_me
            |          |                     schedule
            |          |
            |          |--46.94%-- __lll_mutex_unlock_wake
            |          |          system_call
            |          |          SyS_futex
            |          |          do_futex
            |          |          futex_wake
            |          |          get_futex_key
            |          |          __lock_page
            |          |          __wait_on_bit_lock
            |          |          sleep_on_page
            |          |          io_schedule
            |          |          schedule
            |           --0.00%-- [...]
|          
            |--0.51%-- __lll_mutex_unlock_wake
            |          |
            |          |--97.17%-- system_call
            |          |          schedule
            |          |
            |           --2.83%-- retint_careful
            |                     schedule
             --0.54%-- [...]

It may also be worth mentioning that 'perf annotate' shows the disassembly
of only the 'schedule' subroutine, with 100% of the events marked against
1 instruction, which seems strange.


Environment information


=======================

Machine: 4 core, 8 thread Intel Xeon, 3.4GHz, 16GB RAM
  
Kernel version: derivative of 3.10.0

(I'm not a member of the team that makes the changes, so I'm not familiar
with what the alterations are.)

Base distribution : Ubuntu 8.04 LTS

Compiler used: gcc (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3


What I'm asking for
===================

I'd like to ask for your advice on how to drill down into the user space,
so we can identify exactly where in our code the context switching
originates.

I was envisaging a 2 step process:

  1) Understand why I'm not seeing my test code symbols in the call graph.

If I can get the info I want for the test code, then

  2) Move on to the production code. I'll need to understand why the hex
values seem unusual.



It may well be that I'm missing something obvious or misunderstanding what
'perf' is telling me - I'm not terribly experienced with this level of
debug.


Finally, if it turns out that the 'perf' tools need enhancements, I'm
willing to chip in with the development. I'd like to expand my skills, and
performance analysis is a big part of my job.


Thanks in advance,



Nick Pavey


===========
===========
Sample code
===========
===========


#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define NUM_THREADS  4
#define TCOUNT 100000000
#define COUNT_LIMIT 100000000

int     count = 0;
pthread_mutex_t count_mutex;
pthread_cond_t count_threshold_cv;

void *inc_count(void *t)
{
  int i;
  long my_id = (long)t;

  printf("Starting inc_count(): thread %ld\n", my_id);

  for (i=0; i<TCOUNT; i++) {
    pthread_mutex_lock(&count_mutex);
    count++;

    /* 
    Check the value of count and signal waiting thread when condition is
    reached.  Note that this occurs while mutex is locked.
    */
    if (count == COUNT_LIMIT) {
      pthread_cond_signal(&count_threshold_cv);
    }

    pthread_mutex_unlock(&count_mutex);

    /* NB : I'm deliberately not sleeping here, because I want to
       increase the context switch rate.

       In a 'real' application, this is where we would do the time
       consuming work.

       sleep(1); */
    }

  pthread_exit(NULL);
}

void *watch_count(void *t)
{
  long my_id = (long)t;

  printf("Starting watch_count(): thread %ld\n", my_id);

  /*
  Lock mutex and wait for signal.  Note that the pthread_cond_wait
  routine will automatically and atomically unlock mutex while it waits.
  Also, note that if COUNT_LIMIT is reached before this routine is run by
  the waiting thread, the loop will be skipped to prevent pthread_cond_wait
  from never returning.
  */
  pthread_mutex_lock(&count_mutex);
  while (count<COUNT_LIMIT)
    {
      pthread_cond_wait(&count_threshold_cv, &count_mutex);
      count += 125;
    }

  pthread_mutex_unlock(&count_mutex);
  pthread_exit(NULL);
}

int main (int argc, char *argv[])
{
  int i;
  pthread_t threads[NUM_THREADS];
  pthread_attr_t attr;

  /* Initialize mutex and condition variable objects */
  pthread_mutex_init(&count_mutex, NULL);
  pthread_cond_init (&count_threshold_cv, NULL);

  /* For portability, explicitly create threads in a joinable state */
  pthread_attr_init(&attr);
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

  pthread_create(&threads[0], &attr, watch_count, (void *) 1);

  /* Note that the counter starts at 1, to ensure we don't overwrite
     the 'watch_count' thread pointer, which is at index 0 */
  for (i=1; i < NUM_THREADS; i++)
    {
      pthread_create(&threads[i], &attr, inc_count, (void *) i + 1);
    }

  /* Wait for all threads to complete */
  for (i = 0; i < NUM_THREADS; i++)
    {
      pthread_join(threads[i], NULL);
    }

  printf ("Main(): Waited on %d  threads. Done.\n", NUM_THREADS);

  /* Clean up and exit */
  pthread_attr_destroy(&attr);
  pthread_mutex_destroy(&count_mutex);
  pthread_cond_destroy(&count_threshold_cv);

  pthread_exit(NULL);
}




--------------------
Compilation commands
--------------------

   gcc -c mutex_example.c -ggdb -O0 -fno-omit-frame-pointer \
   -Wall -Wextra -Winit-self -Wsign-compare -ansi -pedantic \
   -o mutex_example.o

   gcc -lpthread mutex_example.o -o mutex_example








ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
