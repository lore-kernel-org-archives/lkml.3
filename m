Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227AbaGCJXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:23:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030202AbaGCJXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 122/198] powerpc/perf: Ensure all EBB register state is cleared on fork()
Date: Thu,  3 Jul 2014 10:19:25 +0100
Message-Id: <1404379241-8590-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit 3df48c981d5a9610e02e9270b1bc4274fb536710 upstream.

In commit 330a1eb "Core EBB support for 64-bit book3s" I messed up
clear_task_ebb(). It clears some but not all of the task's Event Based
Branch (EBB) registers when we duplicate a task struct.

That allows a child task to observe the EBBHR & EBBRR of its parent,
which it should not be able to do.

Fix it by clearing EBBHR & EBBRR.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/include/asm/switch_to.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 671c58f4eb44..64ff06b14630 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -82,6 +82,8 @@ static inline void clear_task_ebb(struct task_struct *t)
 {
 #ifdef CONFIG_PPC_BOOK3S_64
     /* EBB perf events are not inherited, so clear all EBB state. */
+    t->thread.ebbrr = 0;
+    t->thread.ebbhr = 0;
     t->thread.bescr = 0;
     t->thread.mmcr2 = 0;
     t->thread.mmcr0 = 0;
-- 
1.9.1

