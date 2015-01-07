Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbbAGHlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:41:37 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:64076 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbbAGHlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:41:35 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>
CC: <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 03/11] x86: kprobes: directly modify code if kprobe is not initialized.
Date: Wed, 7 Jan 2015 15:35:33 +0800
Message-ID: <1420616133-42855-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When registering early kprobes, SMP should has not been enabled, so
doesn't require synchronization in text_poke_bp(). Simply memcpy is
enough.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/x86/kernel/kprobes/opt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 0dd8d08..dc5fccb 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -397,8 +397,11 @@ void arch_optimize_kprobes(struct list_head *oplist)
 		insn_buf[0] = RELATIVEJUMP_OPCODE;
 		*(s32 *)(&insn_buf[1]) = rel;
 
-		text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
-			     op->optinsn.insn);
+		if (unlikely(!kprobes_initialized))
+			memcpy(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE);
+		else
+			text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
+				     op->optinsn.insn);
 
 		list_del_init(&op->list);
 	}
-- 
1.8.4

