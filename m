Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaGMAmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 20:42:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaGMAmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 20:42:35 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        qiuxishi@huawei.com, paul.gortmaker@windriver.com
Cc: Baoquan He <bhe@redhat.com>
Subject: [PATCH] not adding modules range to kcore if it's equal to vmcore range
Date: Sun, 13 Jul 2014 08:42:24 +0800
Message-Id: <1405212144-2725-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some ARCHs modules range is eauql to vmalloc range. E.g on i686

This will cause 2 duplicate program segments in /proc/kcore, makes
user confused. In this patch a judgment added to check if modules
range is equal to vmalloc range. If yes, just skip adding the modules
range.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 fs/proc/kcore.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 39e6ef3..bf5127c 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -610,8 +610,10 @@ static void __init proc_kcore_text_init(void)
 struct kcore_list kcore_modules;
 static void __init add_modules_range(void)
 {
-	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
-			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
+	if (MODULES_VADDR != VMALLOC_START) {
+		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
+				MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
+	}
 }
 #else
 static void __init add_modules_range(void)
-- 
1.9.3

