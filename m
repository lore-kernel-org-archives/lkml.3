Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161281AbaGRNVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:21:45 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17986 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030723AbaGRNSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:46 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 044/170] powerpc/perf: Ensure all EBB register state is cleared on fork()
Date: Fri, 18 Jul 2014 14:10:49 +0200
Message-Id: <58da9b2550867775c2a15def4f3b177305afde33.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3df48c981d5a9610e02e9270b1bc4274fb536710 upstream.

In commit 330a1eb "Core EBB support for 64-bit book3s" I messed up
clear_task_ebb(). It clears some but not all of the task's Event Based
Branch (EBB) registers when we duplicate a task struct.

That allows a child task to observe the EBBHR & EBBRR of its parent,
which it should not be able to do.

Fix it by clearing EBBHR & EBBRR.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/include/asm/switch_to.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 2be5618cdec6..06d63a3c1a88 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -85,6 +85,8 @@ static inline void clear_task_ebb(struct task_struct *t)
 {
 #ifdef CONFIG_PPC_BOOK3S_64
     /* EBB perf events are not inherited, so clear all EBB state. */
+    t->thread.ebbrr = 0;
+    t->thread.ebbhr = 0;
     t->thread.bescr = 0;
     t->thread.mmcr2 = 0;
     t->thread.mmcr0 = 0;
-- 
2.0.0

