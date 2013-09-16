Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab3IPRa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:30:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3IPRa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:30:56 -0400
Date: Mon, 16 Sep 2013 13:30:36 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: sds@tycho.nsa.gov, eparis@redhat.com, james.l.morris@oracle.com
Subject: lockup during selinux policy load.
Message-ID: <20130916173036.GA17950@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, sds@tycho.nsa.gov,
	eparis@redhat.com, james.l.morris@oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a slow machine (with debugging enabled), during a yum update I get
the soft lockup detector kicking in when it gets to reloading the selinux policy.
It looks like this..


BUG: soft lockup - CPU#2 stuck for 23s! [load_policy:19045]
irq event stamp: 2368864
hardirqs last  enabled at (2368863): [<ffffffff8152ab5d>] __slab_alloc.constprop.78+0x4c0/0x4d7
hardirqs last disabled at (2368864): [<ffffffff8153c82a>] apic_timer_interrupt+0x6a/0x80
softirqs last  enabled at (2368554): [<ffffffff810480b9>] __do_softirq+0x169/0x200
softirqs last disabled at (2368539): [<ffffffff8104837d>] irq_exit+0x11d/0x140
CPU: 2 PID: 19045 Comm: load_policy Not tainted 3.11.0+ #16
Hardware name:                  /D510MO, BIOS MOPNV10J.86A.0175.2010.0308.0620 03/08/2010
task: ffff88005ab38000 ti: ffff880019620000 task.ti: ffff880019620000
RIP: 0010:[<ffffffff81274273>]  [<ffffffff81274273>] strcmp+0x23/0x40
RSP: 0018:ffff880019621818  EFLAGS: 00000246
RAX: 0000000000000063 RBX: ffff880018090ca8 RCX: 0000000000006070
RDX: ffff88000781d8f0 RSI: ffff88000781d8f1 RDI: ffff880079caed21
RBP: ffff880019621818 R08: ffff88006345a290 R09: ffff880018091680
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000292
R13: 0000000180160016 R14: ffff88007b804488 R15: ffffffff81221430
FS:  00007f73e1212800(0000) GS:ffff88007e600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f73e0857aa0 CR3: 0000000076fea000 CR4: 00000000000007e0
Stack:
 ffff880019621828 ffffffff81221ddf ffff880019621850 ffffffff81221c27
 ffff8800180ac6d8 ffff880019621b88 ffffffff82759620 ffff8800196218a0
 ffffffff8122e96c 0000000181221e05 ffff880018091680 0000000000000080
Call Trace:
 [<ffffffff81221ddf>] symcmp+0xf/0x20
 [<ffffffff81221c27>] hashtab_search+0x47/0x80
 [<ffffffff8122e96c>] mls_convert_context+0xdc/0x1c0
 [<ffffffff812294e8>] convert_context+0x378/0x460
 [<ffffffff81229170>] ? security_context_to_sid_core+0x240/0x240
 [<ffffffff812221b5>] sidtab_map+0x45/0x80
 [<ffffffff8122bb9f>] security_load_policy+0x3ff/0x580
 [<ffffffff810788a8>] ? sched_clock_cpu+0xa8/0x100
 [<ffffffff810786dd>] ? sched_clock_local+0x1d/0x80
 [<ffffffff810788a8>] ? sched_clock_cpu+0xa8/0x100
 [<ffffffff8103096a>] ? __change_page_attr_set_clr+0x82a/0xa50
 [<ffffffff810786dd>] ? sched_clock_local+0x1d/0x80
 [<ffffffff810788a8>] ? sched_clock_cpu+0xa8/0x100
 [<ffffffff8103096a>] ? __change_page_attr_set_clr+0x82a/0xa50
 [<ffffffff810788a8>] ? sched_clock_cpu+0xa8/0x100
 [<ffffffff81534ddc>] ? retint_restore_args+0xe/0xe
 [<ffffffff8109c82d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
 [<ffffffff81279a2e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff810d28a8>] ? rcu_irq_exit+0x68/0xb0
 [<ffffffff81534ddc>] ? retint_restore_args+0xe/0xe
 [<ffffffff8121e947>] sel_write_load+0xa7/0x770
 [<ffffffff81139633>] ? vfs_write+0x1c3/0x200
 [<ffffffff81210e8e>] ? security_file_permission+0x1e/0xa0
 [<ffffffff8113952b>] vfs_write+0xbb/0x200
 [<ffffffff811581c7>] ? fget_light+0x397/0x4b0
 [<ffffffff81139c27>] SyS_write+0x47/0xa0
 [<ffffffff8153bde4>] tracesys+0xdd/0xe2
Code: 0f 1f 84 00 00 00 00 00 55 48 89 e5 eb 0e 66 2e 0f 1f 84 00 00 00 00 00 84 c0 74 1c 48 83 c7 01 0f b6 47 ff 48 83 c6 01 3a 46 ff <74> eb 19 c0 83 c8 01 5d c3 0f 1f 40 00 31 c0 5d c3 66 66 66 2e 


23s in the kernel is an eternity. Short of rearchitecting how policy loads are done,
perhaps we could do something like this ? (untested, and 10000 is arbitarily chosen, may need to be adjusted)

thoughts ?

	Dave

diff --git a/security/selinux/ss/hashtab.c b/security/selinux/ss/hashtab.c
index 933e735..69a0587 100644
--- a/security/selinux/ss/hashtab.c
+++ b/security/selinux/ss/hashtab.c
@@ -75,14 +75,21 @@ void *hashtab_search(struct hashtab *h, const void *key)
 {
 	u32 hvalue;
 	struct hashtab_node *cur;
+	int count;
 
 	if (!h)
 		return NULL;
 
 	hvalue = h->hash_value(h, key);
 	cur = h->htable[hvalue];
-	while (cur && h->keycmp(h, key, cur->key) > 0)
+	while (cur && h->keycmp(h, key, cur->key) > 0) {
 		cur = cur->next;
+		count++;
+		if (count == 10000) {
+			touch_softlockup_watchdog();
+			count = 0;
+		}
+	}
 
 	if (cur == NULL || (h->keycmp(h, key, cur->key) != 0))
 		return NULL;
