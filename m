Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaJIUKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:10:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaJIUKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:10:12 -0400
Date: Thu, 9 Oct 2014 16:09:55 -0400
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RCU stalls -> lockup.
Message-ID: <20141009200955.GA15094@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20141002175515.GA28665@redhat.com>
 <20141002193655.GS5015@linux.vnet.ibm.com>
 <20141005021556.GC8549@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005021556.GC8549@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 10:15:56PM -0400, Tejun Heo wrote:
 > On Thu, Oct 02, 2014 at 12:36:55PM -0700, Paul E. McKenney wrote:
 > > On Thu, Oct 02, 2014 at 01:55:15PM -0400, Dave Jones wrote:
 > > > I just hit this on my box running 3.17rc7
 > > > It was followed by a userspace lockup. (Could still ping, and sysrq
 > > > from the console, but even getty wasn't responding on the console).
 > > > 
 > > > I was trying to reproduce another bug faster, and had ramped up the
 > > > number of processes trinity to uses to 512. This didn't take long
 > > > to fall out..
 > > 
 > > This might be related to an exchange I had with Tejun (CCed), where
 > > the work queues were running all out, preventing any quiescent states
 > > from happening.  One fix under consideration is to add a quiescent state,
 > > similar to the one in softirq handling.
 > 
 > Dave, can you please test whether the following patch makes a
 > difference if the problem is reproducible?
 > 
 >   http://lkml.kernel.org/r/20141003153701.7c7da030@jlaw-desktop.mno.stratus.com

The only rcu related stuff I'm seeing now is the spew below, and unlike
the issue before the above patch, it does seem to recover at least..

	Dave

INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3): P5890 P6169 P6164
	Tasks blocked on level-0 rcu_node (CPUs 0-3): P5890 P6169 P6164
	(detected by 0, t=6502 jiffies, g=51433, c=51432, q=0)
trinity-c393    R  running task    12808  5890   5008 0x00000000
 ffff880235b6bd08 0000000000000002 00000000001d8088 ffff88019c1ac680
 00000000001d4080 0000000000000002 ffff880235b6bfd8 00000000001d4080
 ffff880011e80000 ffff88019c1ac680 ffff880235b6bfd8 0000000000000000
Call Trace:
 [<ffffffff9e189150>] ? perf_event_comm_output+0x1e0/0x1e0
 [<ffffffff9e82b4e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff9e832a50>] retint_kernel+0x20/0x30
 [<ffffffff9e19011e>] ? perf_event_mmap+0x24e/0x370
 [<ffffffff9e18af84>] ? perf_event_aux+0xe4/0x380
 [<ffffffff9e18af9f>] ? perf_event_aux+0xff/0x380
 [<ffffffff9e18aea0>] ? perf_cpu_notify+0x50/0x50
 [<ffffffff9e19011e>] perf_event_mmap+0x24e/0x370
 [<ffffffff9e1d111d>] do_brk+0x24d/0x350
 [<ffffffff9e1d13ee>] SyS_brk+0x14e/0x170
 [<ffffffff9e831ee4>] tracesys+0xdd/0xe2
trinity-c375    R  running task    14696  6169   5872 0x00000000
 ffff8801cfd17e58 0000000000000002 ffff8801a7319780 ffff8801a7319780
 00000000001d4080 0000000000000000 ffff8801cfd17fd8 00000000001d4080
 ffff88008b49af00 ffff8801a7319780 ffff8801cfd17fd8 0000000000000000
Call Trace:
 [<ffffffff9e82b4e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff9e832a50>] retint_kernel+0x20/0x30
 [<ffffffff9e09c82d>] ? __task_pid_nr_ns+0x10d/0x1b0
 [<ffffffff9e0e9c74>] ? rcu_is_watching+0x34/0x60
 [<ffffffff9e09c7b3>] ? __task_pid_nr_ns+0x93/0x1b0
 [<ffffffff9e09c82d>] ? __task_pid_nr_ns+0x10d/0x1b0
 [<ffffffff9e09c725>] ? __task_pid_nr_ns+0x5/0x1b0
 [<ffffffff9e0ad17e>] schedule_tail+0x5e/0xb0
 [<ffffffff9e831bbf>] ret_from_fork+0xf/0xb0
trinity-c377    R  running task    14632  6164   5874 0x00000000
 ffff88000c397df8 0000000000000002 0000000000000002 ffff880066d59780
 00000000001d4080 0000000000000000 ffff88000c397fd8 00000000001d4080
 ffff88008b49af00 ffff880066d59780 ffff88000c397fd8 0000000000000000
Call Trace:
 [<ffffffff9e82b4e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff9e832a50>] retint_kernel+0x20/0x30
 [<ffffffff9e0d496d>] ? lock_acquire+0x9d/0x1b0
 [<ffffffff9e09c725>] ? __task_pid_nr_ns+0x5/0x1b0
 [<ffffffff9e09c763>] __task_pid_nr_ns+0x43/0x1b0
 [<ffffffff9e09c725>] ? __task_pid_nr_ns+0x5/0x1b0
 [<ffffffff9e0ad17e>] schedule_tail+0x5e/0xb0
 [<ffffffff9e831bbf>] ret_from_fork+0xf/0xb0
trinity-c393    R  running task    12808  5890   5008 0x00000000
 ffff880235b6bd08 0000000000000002 00000000001d8088 ffff88019c1ac680
 00000000001d4080 0000000000000002 ffff880235b6bfd8 00000000001d4080
 ffff880011e80000 ffff88019c1ac680 ffff880235b6bfd8 0000000000000000
Call Trace:
 [<ffffffff9e189150>] ? perf_event_comm_output+0x1e0/0x1e0
 [<ffffffff9e82b4e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff9e832a50>] retint_kernel+0x20/0x30
 [<ffffffff9e19011e>] ? perf_event_mmap+0x24e/0x370
 [<ffffffff9e18af84>] ? perf_event_aux+0xe4/0x380
 [<ffffffff9e18af9f>] ? perf_event_aux+0xff/0x380
 [<ffffffff9e18aea0>] ? perf_cpu_notify+0x50/0x50
 [<ffffffff9e19011e>] perf_event_mmap+0x24e/0x370
 [<ffffffff9e1d111d>] do_brk+0x24d/0x350
 [<ffffffff9e1d13ee>] SyS_brk+0x14e/0x170
 [<ffffffff9e831ee4>] tracesys+0xdd/0xe2
trinity-c375    R  running task    14696  6169   5872 0x00000000
 ffff8801cfd17e58 0000000000000002 ffff8801a7319780 ffff8801a7319780
 00000000001d4080 0000000000000000 ffff8801cfd17fd8 00000000001d4080
 ffff88008b49af00 ffff8801a7319780 ffff8801cfd17fd8 0000000000000000
Call Trace:
 [<ffffffff9e82b4e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff9e832a50>] retint_kernel+0x20/0x30
 [<ffffffff9e09c82d>] ? __task_pid_nr_ns+0x10d/0x1b0
 [<ffffffff9e0e9c74>] ? rcu_is_watching+0x34/0x60
 [<ffffffff9e09c7b3>] ? __task_pid_nr_ns+0x93/0x1b0
 [<ffffffff9e09c82d>] ? __task_pid_nr_ns+0x10d/0x1b0
 [<ffffffff9e09c725>] ? __task_pid_nr_ns+0x5/0x1b0
 [<ffffffff9e0ad17e>] schedule_tail+0x5e/0xb0
 [<ffffffff9e831bbf>] ret_from_fork+0xf/0xb0
trinity-c377    R  running task    14632  6164   5874 0x00000000
 ffff88000c397df8 0000000000000002 0000000000000002 ffff880066d59780
 00000000001d4080 0000000000000000 ffff88000c397fd8 00000000001d4080
 ffff88008b49af00 ffff880066d59780 ffff88000c397fd8 0000000000000000
Call Trace:
 [<ffffffff9e82b4e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff9e832a50>] retint_kernel+0x20/0x30
 [<ffffffff9e0d496d>] ? lock_acquire+0x9d/0x1b0
 [<ffffffff9e09c725>] ? __task_pid_nr_ns+0x5/0x1b0
 [<ffffffff9e09c763>] __task_pid_nr_ns+0x43/0x1b0
 [<ffffffff9e09c725>] ? __task_pid_nr_ns+0x5/0x1b0
 [<ffffffff9e0ad17e>] schedule_tail+0x5e/0xb0
 [<ffffffff9e831bbf>] ret_from_fork+0xf/0xb0
INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	(detected by 0, t=26007 jiffies, g=51433, c=51432, q=0)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	(detected by 0, t=45512 jiffies, g=51433, c=51432, q=0)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	Tasks blocked on level-0 rcu_node (CPUs 0-3):
	(detected by 0, t=65017 jiffies, g=51433, c=51432, q=0)
INFO: Stall ended before state dump start

