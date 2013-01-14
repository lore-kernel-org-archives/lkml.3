Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab3ANVg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:36:27 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:53441 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab3ANVgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:36:25 -0500
From: Cong Ding <dinggnu@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, Cong Ding <dinggnu@gmail.com>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sparc: kernel/sbus.c: fix memory leakage
Date: Mon, 14 Jan 2013 22:36:08 +0100
Message-Id: <1358199372-11976-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable iommu and strbuf are not freed if it goes to error.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/sparc/kernel/sbus.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/sbus.c b/arch/sparc/kernel/sbus.c
index 1271b3a..0b66e53 100644
--- a/arch/sparc/kernel/sbus.c
+++ b/arch/sparc/kernel/sbus.c
@@ -555,10 +555,10 @@ static void __init sbus_iommu_init(struct platform_device *op)
 
 	iommu = kzalloc(sizeof(*iommu), GFP_ATOMIC);
 	if (!iommu)
-		goto fatal_memory_error;
+		goto fatal_iommu_memory_error;
 	strbuf = kzalloc(sizeof(*strbuf), GFP_ATOMIC);
 	if (!strbuf)
-		goto fatal_memory_error;
+		goto fatal_strbuf_memory_error;
 
 	op->dev.archdata.iommu = iommu;
 	op->dev.archdata.stc = strbuf;
@@ -656,6 +656,10 @@ static void __init sbus_iommu_init(struct platform_device *op)
 	return;
 
 fatal_memory_error:
+	kfree(strbuf);
+fatal_strbuf_memory_error:
+	kfree(iommu);
+fatal_iommu_memory_error:
 	prom_printf("sbus_iommu_init: Fatal memory allocation error.\n");
 }
 
-- 
1.7.9.5

