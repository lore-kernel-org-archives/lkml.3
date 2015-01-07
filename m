Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbbAGHlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:41:44 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:46133 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbAGHll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:41:41 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>
CC: <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 01/11] ARM: kprobes: directly modify code if kprobe is not initialized.
Date: Wed, 7 Jan 2015 15:35:24 +0800
Message-ID: <1420616124-42765-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54ACE2FB.007C,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 12074d3bc4a8d788e5193a746129849d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kprobe is optimized before kprobe is initialized, there should
be only one core, the probed instruction is not armed with breakpoint,
so simply patch text is okay.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/probes/kprobes/opt-arm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/probes/kprobes/opt-arm.c b/arch/arm/probes/kprobes/opt-arm.c
index 15b37c0..a021474 100644
--- a/arch/arm/probes/kprobes/opt-arm.c
+++ b/arch/arm/probes/kprobes/opt-arm.c
@@ -325,8 +325,17 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 		 * Similar to __arch_disarm_kprobe, operations which
 		 * removing breakpoints must be wrapped by stop_machine
 		 * to avoid racing.
+		 *
+		 * If this function is called before kprobes initialized,
+		 * the kprobe should be an early kprobe, the instruction
+		 * is not armed with breakpoint. There should be only
+		 * one core now, so directly __patch_text is enough.
 		 */
-		kprobes_remove_breakpoint(op->kp.addr, insn);
+		if (unlikely(!kprobes_initialized)) {
+			BUG_ON(!(op->kp.flags & KPROBE_FLAG_EARLY));
+			__patch_text(op->kp.addr, insn);
+		} else
+			kprobes_remove_breakpoint(op->kp.addr, insn);
 
 		list_del_init(&op->list);
 	}
-- 
1.8.4

