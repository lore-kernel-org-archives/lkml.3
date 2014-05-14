Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaENDLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:11:04 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:51234 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaENDLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:11:01 -0400
Message-ID: <1400037057.5157.16.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14.3-rt5
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Wed, 14 May 2014 05:10:57 +0200
In-Reply-To: <20140513154002.GD15049@linutronix.de>
References: <20140509181214.GK29014@linutronix.de>
	 <1399695303.5146.21.camel@marge.simpson.net>
	 <20140513154002.GD15049@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 17:40 +0200, Sebastian Andrzej Siewior wrote: 
> * Mike Galbraith | 2014-05-10 06:15:03 [+0200]:
> 
> >On Fri, 2014-05-09 at 20:12 +0200, Sebastian Andrzej Siewior wrote:
> >
> >> Known issues:
> >> 
> >>       - bcache is disabled.
> >> 
> >>       - lazy preempt on x86_64 leads to a crash with some load.
> >
> >That is only with NO_HZ_FUL enabled here.  Box blows the stack during
> >task exit, eyeballing hasn't spotted the why.
> 
> Even if I disable NO_HZ_FULL it explodes as soon as hackbench starts.

Well good, that makes a hell of a lot more sense.  The below is with
NO_HZ_FULL enabled, and hackbench exploding on exit.  Every kaboom I've
see has been a dead task exploding on scrambled thread_info.

Accessing per-anti-cpu data doesn't work well from our universe ;-)

crash> bt  6657
PID: 6657   TASK: ffff8801f947ac00  CPU: 1   COMMAND: "hackbench"
 #0 [ffff88022fc86e00] crash_nmi_callback at ffffffff8102b8f4
 #1 [ffff88022fc86e10] nmi_handle at ffffffff8164865a
 #2 [ffff88022fc86ea0] default_do_nmi at ffffffff81648883
 #3 [ffff88022fc86ed0] do_nmi at ffffffff81648b50
 #4 [ffff88022fc86ef0] end_repeat_nmi at ffffffff81647b71
    [exception RIP: oops_begin+162]
    RIP: ffffffff816483e2  RSP: ffff8800b220d9d8  RFLAGS: 00000097
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000097
    RDX: ffff8800b220d9d8  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff816483e2   R8: ffffffff816483e2   R9: 0000000000000018
    R10: ffff8800b220d9d8  R11: 0000000000000097  R12: ffffffffffffffff
    R13: ffff88022700bf00  R14: 0000000000000100  R15: 0000000000000001
    ORIG_RAX: 0000000000000001  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #5 [ffff8800b220d9d8] oops_begin at ffffffff816483e2
 #6 [ffff8800b220d9f0] no_context at ffffffff8162ef25
 #7 [ffff8800b220da40] __bad_area_nosemaphore at ffffffff8162f19d
 #8 [ffff8800b220daa0] bad_area_nosemaphore at ffffffff8162f1ca
 #9 [ffff8800b220dab0] __do_page_fault at ffffffff8164a68e
#10 [ffff8800b220dbd0] do_page_fault at ffffffff8164ab9e
#11 [ffff8800b220dc00] page_fault at ffffffff81647808
    [exception RIP: cpuacct_charge+148]
    RIP: ffffffff810a1874  RSP: ffff8800b220dcb8  RFLAGS: 00010046
    RAX: 0000000000000040  RBX: 000000000000dd08  RCX: 0000000000000003
    RDX: 0000000000000006  RSI: 0000000000000006  RDI: ffff88022700bf00
    RBP: ffff8800b220dcf8   R8: 00000000000006c0   R9: 000000000000000b
    R10: 0000000000000000  R11: 0000000000013f40  R12: ffffffff81c3b180
    R13: ffff8801f947ac00  R14: ffffffffb220ddd8  R15: 0000000000001d64
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
#12 [ffff8800b220dd00] update_curr at ffffffff81092451
#13 [ffff8800b220dd60] dequeue_entity at ffffffff810928f3
#14 [ffff8800b220ddc0] dequeue_task_fair at ffffffff81092d4d
#15 [ffff8800b220de10] dequeue_task at ffffffff8108442e
#16 [ffff8800b220de40] deactivate_task at ffffffff81084f9e
#17 [ffff8800b220de50] __schedule at ffffffff816440d4
#18 [ffff8800b220ded0] schedule at ffffffff81644899
#19 [ffff8800b220def0] do_exit at ffffffff810530d0
#20 [ffff8800b220df40] do_group_exit at ffffffff8105334c
#21 [ffff8800b220df70] sys_exit_group at ffffffff810533e2
#22 [ffff8800b220df80] tracesys at ffffffff8164f109 (via system_call)
    RIP: 00007fcc1a078ca8  RSP: 00007fff62546c48  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: ffffffff8164f109  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 000000000000003c  RDI: 0000000000000000
    RBP: 00007fcc1a355840   R8: 00000000000000e7   R9: ffffffffffffffa8
    R10: 00007fcc1a969700  R11: 0000000000000246  R12: ffffffff810533e2
    R13: ffff8800b220df78  R14: 0000000001ad9c88  R15: 0000000000000001
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b

crash> struct thread_info 0xffff8800b220c000
struct thread_info {
  task = 0xffffffff, 
  exec_domain = 0xffffffff811bae66 <__d_free+70>, 
  flags = 2, 
  status = 0, 
  cpu = 2988498392, 
  saved_preempt_count = -30720, 
  preempt_lazy_count = -112742225, 
  addr_limit = {
    seg = 524802
  }, 
  restart_block = {
    fn = 0xffff88022fc91358, 
    {
      futex = {
        uaddr = 0x80202, 
        val = 3, 
        flags = 0, 
        bitset = 2988490752, 
        time = 18446744071585425101, 
        uaddr2 = 0xffff88022fc91358
      }, 
      nanosleep = {
        clockid = 524802, 
        rmtp = 0x3, 
        compat_rmtp = 0xffff8800b220c000, 
        expires = 18446744071585425101
      }, 
      poll = {
        ufds = 0x80202, 
        nfds = 3, 
        has_timeout = 0, 
        tv_sec = 18446612135302709248, 
        tv_nsec = 18446744071585425101
      }
    }
  }, 
  sysenter_return = 0xffffffff, 
  sig_on_uaccess_error = 0, 
  uaccess_err = 0
}


