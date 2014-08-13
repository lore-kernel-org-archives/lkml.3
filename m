Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaHMG75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:59:57 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:40573 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaHMG74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:59:56 -0400
Message-ID: <1407913190.5542.50.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Date: Wed, 13 Aug 2014 08:59:50 +0200
In-Reply-To: <20140812191218.GA15210@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com>
	 <20140812191218.GA15210@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-12 at 21:12 +0200, Oleg Nesterov wrote: 
> On 08/12, Rik van Riel wrote:
> >
> > Back in 2009, Spencer Candland pointed out there is a race with
> > do_sys_times, where multiple threads calling do_sys_times can
> > sometimes get decreasing results.
> >
> > https://lkml.org/lkml/2009/11/3/522
> >
> > As a result of that discussion, some of the code in do_sys_times
> > was moved under a spinlock.
> >
> > However, that does not seem to actually make the race go away on
> > larger systems. One obvious remaining race is that after one thread
> > is about to return from do_sys_times, it is preempted by another
> > thread, which also runs do_sys_times, and stores a larger value in
> > the shared variable than what the first thread got.
> >
> > This race is on the kernel/userspace boundary, and not fixable
> > with spinlocks.
> 
> Not sure I understand...
> 
> Afaics, the problem is that a single thread can observe the decreasing
> (say) sum_exec_runtime if it calls do_sys_times() twice without the lock.
> 
> This is because it can account the exiting sub-thread twice if it races
> with __exit_signal() which increments sig->sum_sched_runtime, but this
> exiting thread can still be visible to thread_group_cputime().
> 
> IOW, it is not actually about decreasing, the problem is that the lockless
> thread_group_cputime() can return the wrong result, and the next ys_times()
> can show the right value.
> 
> > Back in 2009, in changeset 2b5fe6de5 Oleg Nesterov already found
> > that it should be safe to remove the spinlock.
> 
> Yes, it is safe but only in a sense that for_each_thread() is fine lockless.
> So this change was reverted.

Funny that thread_group_cputime() should come up just now..

Could you take tasklist_lock ala posix_cpu_clock_get_task()?  If so,
would that improve things at all?

I was told that clock_gettime(CLOCK_PROCESS_CPUTIME_ID) has scalability
issues on BIG boxen, but perhaps less so than times()?

I'm sure the real clock_gettime() using proggy that gummed up a ~1200
core box for "a while" wasn't the testcase below, which will gum it up
for a long while, but looks to me like using CLOCK_PROCESS_CPUTIME_ID
from LOTS of threads is a "Don't do that, it'll hurt a LOT".

#include <sys/time.h>
#include <mpi.h>
#include <stdio.h>
#include <time.h>

int
main(int argc, char **argv){
  struct timeval tv;
  struct timespec tp;
  int rc;
  int i;

  MPI_Init(&argc, &argv);
  for(i=0;i<100000;i++){
    rc = gettimeofday(&tv, NULL);
    if(rc < 0) perror("gettimeofday");
    rc = clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &tp);
    if(rc < 0) perror("clock_gettime");
  }
  MPI_Finalize();
  return 0;
}



