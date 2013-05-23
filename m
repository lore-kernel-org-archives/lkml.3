Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669Ab3EWQkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:40:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab3EWQkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:40:18 -0400
Date: Thu, 23 May 2013 12:40:04 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Subject: Re: rcu_read_lock() used illegally while idle!
Message-ID: <20130523164004.GJ16419@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
References: <20130521173100.GA2076@redhat.com>
 <20130522093624.GZ3578@linux.vnet.ibm.com>
 <1369226958.6828.175.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369226958.6828.175.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 08:49:18AM -0400, Steven Rostedt wrote:

 > > ===============================
 > > [ INFO: suspicious RCU usage. ]
 > > 3.10.0-rc2+ #1 Not tainted
 > > -------------------------------
 > > include/linux/rcupdate.h:771 rcu_read_lock() used illegally while idle!
 > > other info that might help us debug this:
 > > RCU used illegally from idle CPU! rcu_scheduler_active = 1, debug_locks = 0
 > > RCU used illegally from extended quiescent state!
 > > 2 locks held by cc1/63645:
 > >  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff816b39fd>] __schedule+0xed/0x9b0
 > >  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8109d645>] cpuacct_charge+0x5/0x1f0
 > > 
 > > CPU: 1 PID: 63645 Comm: cc1 Not tainted 3.10.0-rc2+ #1 [loadavg: 40.57 27.55 13.39 25/277 64369]
 > > Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
 > >  0000000000000000 ffff88010f78fcf8 ffffffff816ae383 ffff88010f78fd28
 > >  ffffffff810b698d ffff88011c092548 000000000023d073 ffff88011c092500
 > >  0000000000000001 ffff88010f78fd60 ffffffff8109d7c5 ffffffff8109d645
 > > Call Trace:
 > >  [<ffffffff816ae383>] dump_stack+0x19/0x1b
 > >  [<ffffffff810b698d>] lockdep_rcu_suspicious+0xfd/0x130
 > >  [<ffffffff8109d7c5>] cpuacct_charge+0x185/0x1f0
 > >  [<ffffffff8109d645>] ? cpuacct_charge+0x5/0x1f0
 > >  [<ffffffff8108dffc>] update_curr+0xec/0x240
 > >  [<ffffffff8108f528>] put_prev_task_fair+0x228/0x480
 > >  [<ffffffff816b3a71>] __schedule+0x161/0x9b0
 > >  [<ffffffff816b4721>] preempt_schedule+0x51/0x80
 > >  [<ffffffff816b4800>] ? __cond_resched_softirq+0x60/0x60
 > >  [<ffffffff816b6824>] ? retint_careful+0x12/0x2e
 > >  [<ffffffff810ff3cc>] ftrace_ops_control_func+0x1dc/0x210
 > >  [<ffffffff816be280>] ftrace_call+0x5/0x2f
 > >  [<ffffffff816b681d>] ? retint_careful+0xb/0x2e
 > >  [<ffffffff816b4805>] ? schedule_user+0x5/0x70
 > >  [<ffffffff816b4805>] ? schedule_user+0x5/0x70
 > >  [<ffffffff816b6824>] ? retint_careful+0x12/0x2e
 > > ------------[ cut here ]------------
 > 
 > This looks to be the caused by the same issue that this patch fixes:
 > 
 > https://lkml.org/lkml/2013/5/10/537
 > 
 > The schedule_user() was traced, and the preempt_enable_no_trace() that
 > the function tracer does caused for a schedule to occur. As the
 > scheduler uses rcu, and it was called before schedule_user() could tell
 > the kernel that the context is changing from user to kernel.

That patch doesn't help unfortunatly.

	Dave

