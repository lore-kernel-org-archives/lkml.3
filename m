Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaABVzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:55:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33187 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaABVxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:53:44 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>
Subject: [RFC PATCHv3 11/11] fs/proc/kcore.c: Use for_each_potential_vmalloc_area
Date: Thu,  2 Jan 2014 13:53:29 -0800
Message-Id: <1388699609-18214-12-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_INTERMIX_VMALLOC, we can no longer assume all vmalloc
is contained between VMALLOC_START and VMALLOC_END. For code that
relies on operating on the vmalloc space, use
for_each_potential_vmalloc_area to track each area separately.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 fs/proc/kcore.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 5ed0e52..9be81a8 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -585,8 +585,6 @@ static struct notifier_block kcore_callback_nb __meminitdata = {
 	.priority = 0,
 };
 
-static struct kcore_list kcore_vmalloc;
-
 #ifdef CONFIG_ARCH_PROC_KCORE_TEXT
 static struct kcore_list kcore_text;
 /*
@@ -621,6 +619,11 @@ static void __init add_modules_range(void)
 
 static int __init proc_kcore_init(void)
 {
+	struct kcore_list *kcore_vmalloc;
+	unsigned long vstart;
+	unsigned long vend;
+	int i;
+
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL,
 				      &proc_kcore_operations);
 	if (!proc_root_kcore) {
@@ -629,9 +632,16 @@ static int __init proc_kcore_init(void)
 	}
 	/* Store text area if it's special */
 	proc_kcore_text_init();
-	/* Store vmalloc area */
-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
+	for_each_potential_vmalloc_area(&vstart, &vend, &i) {
+		kcore_vmalloc = kzalloc(sizeof(*kcore_vmalloc), GFP_KERNEL);
+		if (!kcore_vmalloc)
+			return 0;
+
+		/* Store vmalloc area */
+		kclist_add(kcore_vmalloc, (void *)vstart,
+				vend - vstart, KCORE_VMALLOC);
+	}
+
 	add_modules_range();
 	/* Store direct-map area from physical memory map */
 	kcore_update_ram();
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

