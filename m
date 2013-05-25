Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3EYOWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 10:22:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab3EYOWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 10:22:53 -0400
Date: Sat, 25 May 2013 09:59:59 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Subject: Re: rcu_read_lock() used illegally while idle!
Message-ID: <20130525135959.GA1784@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
References: <20130521173100.GA2076@redhat.com>
 <20130522093624.GZ3578@linux.vnet.ibm.com>
 <1369226958.6828.175.camel@gandalf.local.home>
 <20130523164004.GJ16419@redhat.com>
 <1369403180.6828.223.camel@gandalf.local.home>
 <20130524142338.GB3106@redhat.com>
 <1369423420.6828.226.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369423420.6828.226.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 03:23:40PM -0400, Steven Rostedt wrote:
 > On Fri, 2013-05-24 at 10:23 -0400, Dave Jones wrote:
 > 
 > > .config: http://paste.fedoraproject.org/14281/94052971/raw/
 > > 
 > > trace shows the problem process was 'cc1', so I was likely building a kernel
 > > at the time.  There was also a trinity run going on in the background.
 > > 
 > > cmdline: nothing special..
 > > 
 > > BOOT_IMAGE=/vmlinuz-3.10.0-rc2+ root=UUID=bee21cd9-1852-4d1d-9e9d-2e44332b8df1 ro rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-sun16 consoleblank=0 console=ttyUSB0,115200 console=tty0 pause_on_oops=30 audit=0
 > > 
 > 
 > OK, I'm able to reproduce this. Looks like the same issue happens from
 > other ways from userspace into the kernel (the next way was tracing
 > system calls).
 > 
 > Forget the other patch. Here's a new patch that is more specific to
 > tracing and context tracking.
 > 
 > Can you try this one out, please.

Took a lot longer to hit this..

[53693.297516] ===============================
[53693.298109] [ INFO: suspicious RCU usage. ]
[53693.298562] 3.10.0-rc2+ #38 Not tainted
[53693.299017] -------------------------------
[53693.299474] include/linux/rcupdate.h:771 rcu_read_lock() used illegally while idle!
[53693.299959] 
other info that might help us debug this:

[53693.301420] 
RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 0
[53693.302918] RCU used illegally from extended quiescent state!
[53693.303462] 1 lock held by trinity-child1/18786:
[53693.303966]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8113dd48>] __perf_event_overflow+0x108/0x310
[53693.304557] 
stack backtrace:
[53693.305608] CPU: 3 PID: 18786 Comm: trinity-child1 Not tainted 3.10.0-rc2+ #38 
[53693.306790]  0000000000000000 ffff88020767bac8 ffffffff816e2f6b ffff88020767baf8
[53693.307408]  ffffffff810b5897 ffff88021de92520 0000000000000000 ffff88020767bbf8
[53693.308035]  0000000000000000 ffff88020767bb78 ffffffff8113ded4 ffffffff8113dd48
[53693.308671] Call Trace:
[53693.309301]  [<ffffffff816e2f6b>] dump_stack+0x19/0x1b
[53693.309943]  [<ffffffff810b5897>] lockdep_rcu_suspicious+0xe7/0x120
[53693.310596]  [<ffffffff8113ded4>] __perf_event_overflow+0x294/0x310
[53693.311256]  [<ffffffff8113dd48>] ? __perf_event_overflow+0x108/0x310
[53693.311923]  [<ffffffff81309289>] ? __const_udelay+0x29/0x30
[53693.312596]  [<ffffffff81076054>] ? __rcu_read_unlock+0x54/0xa0
[53693.313275]  [<ffffffff816f4000>] ? ftrace_call+0x5/0x2f
[53693.313958]  [<ffffffff8113dfa1>] perf_swevent_overflow+0x51/0xe0
[53693.314650]  [<ffffffff8113e08f>] perf_swevent_event+0x5f/0x90
[53693.315347]  [<ffffffff8113e1c9>] perf_tp_event+0x109/0x4f0
[53693.316059]  [<ffffffff8113e36f>] ? perf_tp_event+0x2af/0x4f0
[53693.316773]  [<ffffffff81074630>] ? __rcu_read_lock+0x20/0x20
[53693.317485]  [<ffffffff8112d79f>] perf_ftrace_function_call+0xbf/0xd0
[53693.318207]  [<ffffffff8110e1e1>] ? ftrace_ops_control_func+0x181/0x210
[53693.318921]  [<ffffffff81074630>] ? __rcu_read_lock+0x20/0x20
[53693.319621]  [<ffffffff81100cae>] ? rcu_eqs_enter_common+0x5e/0x470
[53693.320330]  [<ffffffff8110e1e1>] ftrace_ops_control_func+0x181/0x210
[53693.321046]  [<ffffffff816f4000>] ftrace_call+0x5/0x2f
[53693.321763]  [<ffffffff8110e229>] ? ftrace_ops_control_func+0x1c9/0x210
[53693.322490]  [<ffffffff816f4000>] ? ftrace_call+0x5/0x2f
[53693.323221]  [<ffffffff81074635>] ? debug_lockdep_rcu_enabled+0x5/0x40
[53693.323988]  [<ffffffff81074635>] ? debug_lockdep_rcu_enabled+0x5/0x40
[53693.324728]  [<ffffffff81100cae>] ? rcu_eqs_enter_common+0x5e/0x470
[53693.325489]  [<ffffffff8110112a>] rcu_eqs_enter+0x6a/0xb0
[53693.326273]  [<ffffffff81103673>] rcu_user_enter+0x13/0x20
[53693.327025]  [<ffffffff8114541a>] user_enter+0x6a/0xd0
[53693.327783]  [<ffffffff8100f6d8>] syscall_trace_leave+0x78/0x140
[53693.328551]  [<ffffffff816f46af>] int_check_syscall_exit_work+0x34/0x3d
 

