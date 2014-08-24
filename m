Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaHXDkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 23:40:13 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:47287 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaHXDkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 23:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140824032339.GK2663@linux.vnet.ibm.com>
References: <CAJhHMCC6XUo0erp6mPyjiz5614DQq_+gfVaLR5s9YZkP=jPVCw@mail.gmail.com>
 <20140823165121.GJ2663@linux.vnet.ibm.com> <CAJhHMCCntYQy624Kwb5bs7MAKKYrSRbG0SezxgbQfHwYA2C40w@mail.gmail.com>
 <20140824032339.GK2663@linux.vnet.ibm.com>
From: Pranith Kumar <pranith@gatech.edu>
Date: Sat, 23 Aug 2014 23:39:39 -0400
X-Google-Sender-Auth: Z4Wfg_hGvCUgonCnXcY-FeoyEsw
Message-ID: <CAJhHMCC8C5bekoDvQs=7vcRichkmFrHK7TshuoAHFE0-7d+mtA@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Amit Shah <amit.shah@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Silas Boyd-Wickizer <sbw@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 11:23 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Sat, Aug 23, 2014 at 08:26:10PM -0400, Pranith Kumar wrote:
>> On Sat, Aug 23, 2014 at 12:51 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>>
>> > It might well!  Another possibility is that the early_initcall function
>> > doing the synchronize_rcu() is happening before the early_initcall
>> > creating the RCU grace-period kthreads.
>> >
>> > Seems like we need to close both holes.  Let's see how your patch works
>> > for Amit, and I am testing a patch for the possible early_initcall
>> > ordering issue.
>>
>> I checked the init call which is calling synchronize_rcu():
>> subsys_initcall(pm_sysrq_init); this is being called after
>> early_initcall.
>>
>> The order of initcalls is early, core, postcore, arch, subsys, fs,
>> device, late. So I guess that is ok.
>>
>> I wonder why it was not showing up in 12.04. I have a dual boot. Will
>> test it out and see if I can find something.
>
> Me, I am wondering about 7,000 callbacks being registered during early
> boot time.  ;-)
>


This is the backtrace for most of the callbacks:

[    4.612103] ------------[ cut here ]------------
[    4.613340] WARNING: CPU: 0 PID: 0 at kernel/rcu/tree_plugin.h:2115
__call_rcu_nocb_enqueue+0x58/0x283()
[    4.615975] Modules linked in:
[    4.616000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W     3.16.0+ #76
[    4.616000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Bochs 01/01/2011
[    4.616000]  0000000000000000 ffffffff81803c20 ffffffff813c5213
0000000000000000
[    4.616000]  ffffffff81803c58 ffffffff810388aa ffffffff8108aac8
ffff88001f9cce40
[    4.616000]  ffff88001f5b6c08 0000000000000000 0000000000000286
ffffffff81803c68
[    4.616000] Call Trace:
[    4.616000]  [<ffffffff813c5213>] dump_stack+0x4e/0x7a
[    4.616000]  [<ffffffff810388aa>] warn_slowpath_common+0x7f/0x98
[    4.616000]  [<ffffffff8108aac8>] ? __call_rcu_nocb_enqueue+0x58/0x283
[    4.616000]  [<ffffffff81038976>] warn_slowpath_null+0x1a/0x1c
[    4.616000]  [<ffffffff8108aac8>] __call_rcu_nocb_enqueue+0x58/0x283
[    4.616000]  [<ffffffff81129f3a>] ? unreferenced_object+0x4f/0x4f
[    4.616000]  [<ffffffff8108d913>] __call_rcu+0xcd/0x32b
[    4.616000]  [<ffffffff8108de66>] call_rcu+0x1b/0x1d
[    4.616000]  [<ffffffff8112a301>] put_object+0x41/0x44
[    4.616000]  [<ffffffff8112a70a>] delete_object_full+0x29/0x2c
[    4.616000]  [<ffffffff813c2166>] kmemleak_free+0x25/0x43
[    4.616000]  [<ffffffff81120cca>] slab_free_hook+0x1d/0x63
[    4.616000]  [<ffffffff811228c6>] kmem_cache_free+0x52/0x154
[    4.616000]  [<ffffffff8124aa01>] ? acpi_os_release_object+0xe/0x12
[    4.616000]  [<ffffffff8124aa01>] acpi_os_release_object+0xe/0x12
[    4.616000]  [<ffffffff8126c567>] acpi_ps_free_op+0x25/0x27
[    4.616000]  [<ffffffff8126b81f>] acpi_ps_create_op+0x135/0x209
[    4.616000]  [<ffffffff8126b1f2>] acpi_ps_parse_loop+0x1d3/0x575
[    4.616000]  [<ffffffff8126bff2>] acpi_ps_parse_aml+0xa0/0x277
[    4.616000]  [<ffffffff81267d7f>] acpi_ns_one_complete_parse+0xfc/0x11b
[    4.616000]  [<ffffffff81267dd1>] acpi_ns_parse_table+0x33/0x38
[    4.616000]  [<ffffffff81267755>] acpi_ns_load_table+0x4c/0x8b
[    4.616000]  [<ffffffff81ad6797>] acpi_load_tables+0x9d/0x15d
[    4.616000]  [<ffffffff81ad5b44>] acpi_early_init+0x73/0xfe
[    4.616000]  [<ffffffff81aa5e8e>] start_kernel+0x3a9/0x40a
[    4.616000]  [<ffffffff81aa5120>] ? early_idt_handlers+0x120/0x120
[    4.616000]  [<ffffffff81aa54ba>] x86_64_start_reservations+0x2a/0x2c
[    4.616000]  [<ffffffff81aa55f8>] x86_64_start_kernel+0x13c/0x149
[    4.616000] ---[ end trace 8dbfee90ca96696c ]---


-- 
Pranith
