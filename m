Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3FLRuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:50:13 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:34303 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab3FLRuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:50:10 -0400
Message-ID: <1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?Q?=E8=B5=96=E6=B1=9F=E5=B1=B1?= <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu
Date: Wed, 12 Jun 2013 10:50:01 -0700
In-Reply-To: <1370974231.9844.212.camel@gandalf.local.home>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	 <1370911480.9844.160.camel@gandalf.local.home>
	 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
	 <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
	 <1370974231.9844.212.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 14:10 -0400, Steven Rostedt wrote:
> Perhaps short work loads have a cold cache, and the impact on cache is
> not as drastic?
> 
> It would be interesting to see what perf reports on these runs.

After running the aim7 workloads on Paul's v3 patch (same 80 core, 8
socket box - HT off) the results are quite similar to the v1. One
difference is that the five_sec workload benefited with +15% throughput
after 500 users.

Taking a further look at each workload:

* five_sec: spends a large amount of time in the newish mcs style lock
at the spin on owner for the inode->i_mutex:

  24.13%     315655            reaim  [kernel.kallsyms]            [k] mspin_lock                                         
                      |
                      --- mspin_lock
                         |          
                         |--99.76%-- __mutex_lock_killable_slowpath
                         |          mutex_lock_killable
                         |          vfs_readdir
                         |          SyS_getdents
                         |          system_call_fastpath
                         |          __getdents64

With this patch:
    23.56%     310531            reaim  [kernel.kallsyms]            [k] mspin_lock                                                   
                      |
                      --- mspin_lock
                         |          
                         |--99.78%-- __mutex_lock_killable_slowpath
                         |          mutex_lock_killable
                         |          vfs_readdir
                         |          SyS_getdents
                         |          system_call
                         |          __getdents64
 
* custom: Got a -33% throughput regression with this patch with 10-100
users and -46% with 100 users and up. It spends most kernel space time
dealing trying to take the inode->i_mutex and the ext4 ->s_orphan_lock
(note that all runs are performed on ramdisks with ext4):

   3.12%     137131            reaim  [kernel.kallsyms]            [k] mspin_lock                                         
                      |
                      --- mspin_lock
                         |          
                         |--82.98%-- __mutex_lock_killable_slowpath
                         |          mutex_lock_killable
                         |          vfs_readdir
                         |          SyS_getdents
                         |          system_call_fastpath
                         |          __getdents64
                         |          
                         |--16.97%-- __mutex_lock_slowpath
                         |          mutex_lock
                         |          |          
                         |          |--47.65%-- ext4_orphan_del
                         |          |--45.01%-- ext4_orphan_add

With this patch:
    2.14%     109982            reaim  [kernel.kallsyms]            [k] mspin_lock                                                   
                      |
                      --- mspin_lock
                         |          
                         |--68.67%-- __mutex_lock_killable_slowpath
                         |          mutex_lock_killable
                         |          vfs_readdir
                         |          SyS_getdents
                         |          system_call
                         |          __getdents64
                         |          
                         |--31.24%-- __mutex_lock_slowpath
                         |          mutex_lock
                         |          |          
                         |          |--40.36%-- ext4_orphan_del


* short: is the big winner for this patch, +69% throughput improvement
with 100-2000 users. This makes a lot of sense since the workload spends
a ridiculous amount of time trying to acquire the d_lock:

  84.86%    1569902            reaim  [kernel.kallsyms]            [k] _raw_spin_lock
                      |
                      --- _raw_spin_lock
                         |
                         |--49.96%-- dget_parent
                         |          __fsnotify_parent
                         |--49.71%-- dput
                         |          |
                         |          |--99.98%-- __fsnotify_parent

With this patch:
   70.65%     467422           reaim  [kernel.kallsyms]     [k] tkt_q_do_spin
                     |
                     --- tkt_q_do_spin
                        |
                        |--100.00%-- tkt_spin_pass
                        |          |
                        |          |--100.00%-- _raw_spin_lock
                        |          |          |
                        |          |          |--50.07%-- dget_parent
                        |          |          |          __fsnotify_parent
                        |          |          |--49.93%-- dput
                        |          |          |          __fsnotify_parent
 

* disk: This patch benefits when adding more concurrency. Got -57% with
10-100 users, -25% with 100-1000 users and +8% with over 1000 users.
Spends a good amount of time dealing with the wait_queue lock. The perf
traces are with 80 users, where we see the worst numbers:

  22.34%      20400            reaim  [kernel.kallsyms]        [k] _raw_spin_lock_irqsave                             
                      |
                      --- _raw_spin_lock_irqsave
                         |          
                         |--50.28%-- __wake_up
                         |          |          
                         |          |--99.10%-- __wake_up_bit
                         |          |          wake_up_bit
                         |          |          unlock_buffer
                         |          
                         |--33.73%-- prepare_to_wait_exclusive
                         |          __wait_on_bit_lock
                         |          out_of_line_wait_on_bit_lock
                         |          __lock_buffer
                         |          do_get_write_access
                         |          jbd2_journal_get_write_access
                         |          __ext4_journal_get_write_access
                         |--14.76%-- finish_wait
                         |          |          
                         |          |--98.93%-- __wait_on_bit_lock
                         |          |          out_of_line_wait_on_bit_lock
                         |          |          __lock_buffer
                         |          |          do_get_write_access
                         |          |          jbd2_journal_get_write_access
                         |          |          __ext4_journal_get_write_access


With this patch the the time spent in the mentioned spinlocks
considerably reduced:
     8.09%       6237            reaim  [kernel.kallsyms]   [k] __read_lock_failed                                           
                      |
                      --- __read_lock_failed
                          _raw_read_lock
                         |          
                         |--99.08%-- start_this_handle
                         |          jbd2__journal_start
                         |          __ext4_journal_start_sb

    1.48%       1032            reaim  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave                                       
                      |
                      --- _raw_spin_lock_irqsave
                         |          
                         |--50.77%-- prepare_to_wait
                         |          |          
                         |          |--72.61%-- jbd2_log_wait_commit
                         |          |          jbd2_complete_transaction
                         |--21.76%-- prepare_to_wait_exclusive
                         |          __wait_on_bit_lock
                         |          out_of_line_wait_on_bit_lock
                         |          __lock_buffer
                         |          do_get_write_access
                         |          jbd2_journal_get_write_access
                         |--11.46%-- __wake_up
                         |          |          
                         |          |--44.21%-- ftrace_define_fields_jbd2_run_stats
                         |          |          __ext4_journal_stop
                         |--10.39%-- finish_wait
                         |          |          
                         |          |--53.18%-- __wait_on_bit_lock
                         |          |          out_of_line_wait_on_bit_lock
                         |          |          __lock_buffer
                         |          |          do_get_write_access
                         |          |          jbd2_journal_get_write_access
                         |          |          __ext4_journal_get_write_access


Thanks,
Davidlohr


