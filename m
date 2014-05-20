Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaETNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:16:56 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:45822 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaETNQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:16:54 -0400
Date: Tue, 20 May 2014 15:16:47 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Benjamin LaHaise <bcrl@kvack.org>
cc: Anatol Pomozov <anatol.pomozov@gmail.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: hanging aio process
In-Reply-To: <alpine.LFD.2.11.1405200950480.1606@denkbrett>
Message-ID: <alpine.LFD.2.11.1405201508450.1606@denkbrett>
References: <alpine.LFD.2.11.1405191908450.1847@denkbrett> <20140519180851.GD2915@kvack.org> <alpine.LFD.2.11.1405200950480.1606@denkbrett>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052013-8372-0000-0000-000009C0E333
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Sebastian Ott wrote:
> On Mon, 19 May 2014, Benjamin LaHaise wrote:
> > It is entirely possible the bug isn't 
> > caused by the referenced commit, as the commit you're pointing to merely 
> > makes io_destroy() syscall wait for all aio outstanding to complete 
> > before returning.
> 
> I cannot reproduce this when I revert said commit (on top of 14186fe). If
> that matters - the arch is s390.

Hm, ok - maybe that commit is really just highlighting a refcounting bug.
I just compared traces for a good and a few bad cases. The good case:
# tracer: function
#
# entries-in-buffer/entries-written: 16/16   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
             fio-732   [003] ....    17.989315: kill_ioctx <-SyS_io_destroy
             fio-739   [003] ....    18.000563: kill_ioctx <-SyS_io_destroy
     ksoftirqd/3-19    [003] ..s.    18.031673: free_ioctx_users <-percpu_ref_kill_rcu
     ksoftirqd/3-19    [003] ..s.    18.031679: free_ioctx_users <-percpu_ref_kill_rcu
             fio-737   [003] ....    18.038765: kill_ioctx <-SyS_io_destroy
     ksoftirqd/3-19    [003] ..s.    18.062488: free_ioctx_reqs <-percpu_ref_kill_rcu
     ksoftirqd/3-19    [003] ..s.    18.062494: free_ioctx_reqs <-percpu_ref_kill_rcu
     kworker/3:1-57    [003] ....    18.062499: free_ioctx <-process_one_work
     kworker/3:1-57    [003] ....    18.062506: free_ioctx <-process_one_work
     ksoftirqd/3-19    [003] ..s.    18.072275: free_ioctx_users <-percpu_ref_kill_rcu
             fio-738   [003] ....    18.102419: kill_ioctx <-SyS_io_destroy
          <idle>-0     [003] .ns.    18.111668: free_ioctx_reqs <-percpu_ref_kill_rcu
     kworker/3:1-57    [003] ....    18.111675: free_ioctx <-process_one_work
     ksoftirqd/3-19    [003] ..s.    18.138035: free_ioctx_users <-percpu_ref_kill_rcu
          <idle>-0     [003] .ns.    18.191665: free_ioctx_reqs <-percpu_ref_kill_rcu
     kworker/3:1-57    [003] ....    18.191671: free_ioctx <-process_one_work

(4 fio workers, free_ioctx_reqs is called 4 times)

One of the bad cases:
# tracer: function
#
# entries-in-buffer/entries-written: 14/14   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
             fio-834   [000] ....    51.127359: kill_ioctx <-SyS_io_destroy
          <idle>-0     [000] ..s.    51.170237: free_ioctx_users <-percpu_ref_kill_rcu
             fio-828   [001] ....    51.189717: kill_ioctx <-SyS_io_destroy
             fio-833   [001] ..s.    51.220178: free_ioctx_users <-percpu_ref_kill_rcu
          <idle>-0     [000] .ns.    51.220230: free_ioctx_reqs <-percpu_ref_kill_rcu
     kworker/0:3-661   [000] ....    51.220238: free_ioctx <-process_one_work
          <idle>-0     [001] .ns.    51.260188: free_ioctx_reqs <-percpu_ref_kill_rcu
     kworker/1:2-103   [001] ....    51.260198: free_ioctx <-process_one_work
             fio-833   [002] ....    51.287602: kill_ioctx <-SyS_io_destroy
           udevd-868   [002] ..s1    51.332519: free_ioctx_users <-percpu_ref_kill_rcu
          <idle>-0     [002] .ns.    51.450180: free_ioctx_reqs <-percpu_ref_kill_rcu
     kworker/2:2-191   [002] ....    51.450191: free_ioctx <-process_one_work
             fio-835   [003] ....    51.907530: kill_ioctx <-SyS_io_destroy
     ksoftirqd/3-19    [003] ..s.    52.000232: free_ioctx_users <-percpu_ref_kill_rcu

(1 fio worker in D state, free_ioctx_reqs is called 3 times)

Regards,
Sebastian

> > 
> > > git bisect points to:
> > > 	commit e02ba72aabfade4c9cd6e3263e9b57bf890ad25c
> > > 	Author: Anatol Pomozov <anatol.pomozov@gmail.com>
> > > 	Date:   Tue Apr 15 11:31:33 2014 -0700
> > > 
> > > 	    aio: block io_destroy() until all context requests are completed
> > > 
> > > 
> > > The fio workers are on the wait_for_completion in sys_io_destroy.
> > > 
> > > Regards,
> > > Sebastian
> > > [global]
> > > blocksize=4K
> > > size=256M
> > > rw=randrw
> > > verify=md5
> > > iodepth=32
> > > ioengine=libaio
> > > direct=1
> > > end_fsync=1
> > > 
> > > [file1]
> > > filename=/dev/scma
> > > 
> > > [file2]
> > > filename=/dev/scmbw
> > > 
> > > [file3]
> > > filename=/dev/scmc
> > > 
> > > [file4]
> > > filename=/dev/scmx
> > 
> > 
> > -- 
> > "Thought is the essence of where you are now."
> > 
> > 
> 

