Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030452AbaGDWRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:17:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030413AbaGDWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:17:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.15 47/66] powerpc/perf: Ensure all EBB register state is cleared on fork()
Date: Fri,  4 Jul 2014 15:14:46 -0700
Message-Id: <20140704221424.948136296@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/switch_to.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -84,6 +84,8 @@ static inline void clear_task_ebb(struct
 {
 #ifdef CONFIG_PPC_BOOK3S_64
     /* EBB perf events are not inherited, so clear all EBB state. */
+    t->thread.ebbrr = 0;
+    t->thread.ebbhr = 0;
     t->thread.bescr = 0;
     t->thread.mmcr2 = 0;
     t->thread.mmcr0 = 0;


