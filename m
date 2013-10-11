Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3JKRzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:55:18 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:1536 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105Ab3JKRzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:55:14 -0400
Message-Id: <00000141a8a87077-a9a7e172-13c4-4c7c-9fc7-1f054ae0a5c7-000000@email.amazonses.com>
User-Agent: quilt/0.60-1
Date: Fri, 11 Oct 2013 17:55:13 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/6] Use raw_cpu_write for initialization of per cpu refcount.
References: <20131011175518.634285474@linux.com>
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initialization of a structure is not subject to synchronization.
The use of __this_cpu would trigger a false positive with the
additional preemption checks for __this_cpu ops.

So simply disable the check through the use of raw_cpu ops.

Trace:

[    0.668066] __this_cpu_write operation in preemptible [00000000] code: modprobe/286
[    0.668108] caller is __this_cpu_preempt_check+0x38/0x60
[    0.668111] CPU: 3 PID: 286 Comm: modprobe Tainted: GF            3.12.0-rc4+ #187
[    0.668112] Hardware name: FUJITSU CELSIUS W530 Power/D3227-A1, BIOS V4.6.5.4 R1.10.0 for D3227-A1x 09/16/2013
[    0.668113]  0000000000000003 ffff8807edda1d18 ffffffff816d5a57 ffff8807edda1fd8
[    0.668117]  ffff8807edda1d48 ffffffff8137359c ffff8807edda1ef8 ffffffffa0002178
[    0.668121]  ffffc90000067730 ffff8807edda1e48 ffff8807edda1d88 ffffffff813735f8
[    0.668124] Call Trace:
[    0.668129]  [<ffffffff816d5a57>] dump_stack+0x4e/0x82
[    0.668132]  [<ffffffff8137359c>] check_preemption_disabled+0xec/0x110
[    0.668135]  [<ffffffff813735f8>] __this_cpu_preempt_check+0x38/0x60
[    0.668139]  [<ffffffff810c24fd>] load_module+0xcfd/0x2650
[    0.668143]  [<ffffffff816dd922>] ? page_fault+0x22/0x30
[    0.668146]  [<ffffffff810c3ef6>] SyS_init_module+0xa6/0xd0
[    0.668150]  [<ffffffff816e4fd3>] tracesys+0xe1/0xe6



Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/module.c
===================================================================
--- linux.orig/kernel/module.c	2013-09-05 13:43:30.557687773 -0500
+++ linux/kernel/module.c	2013-10-07 12:33:43.732059759 -0500
@@ -643,7 +643,7 @@ static int module_unload_init(struct mod
 	INIT_LIST_HEAD(&mod->target_list);
 
 	/* Hold reference count during initialization. */
-	__this_cpu_write(mod->refptr->incs, 1);
+	raw_cpu_write(mod->refptr->incs, 1);
 	/* Backwards compatibility macros put refcount during init. */
 	mod->waiter = current;
 

