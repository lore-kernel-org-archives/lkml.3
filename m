Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaLOISc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:18:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaLOISb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:18:31 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, vgoyal@redhat.com,
        kexec@lists.infradead.org, Baoquan He <bhe@redhat.com>
Subject: [PATCH] kexec: remove never used member destination  in kimage
Date: Mon, 15 Dec 2014 16:16:27 +0800
Message-Id: <1418631387-1768-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct kimage has a member destination which is used to store the
real destination address of each page when load segment from user
space buffer to kernel. But we never retrieve the value stored in
kimage->destination, so this member variable in kimage and its
assignment operation are redundent code.

I guess for_each_kimage_entry just does the work that kimage->destination
is expected to do.

So in this patch just make a cleanup to remove it.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/kexec.h | 2 --
 kernel/kexec.c        | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 9d957b7..10da8e2 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -122,8 +122,6 @@ struct kimage {
 	kimage_entry_t *entry;
 	kimage_entry_t *last_entry;
 
-	unsigned long destination;
-
 	unsigned long start;
 	struct page *control_code_page;
 	struct page *swap_page;
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 9a8a01a..7a897ac 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -856,8 +856,6 @@ static int kimage_set_destination(struct kimage *image,
 
 	destination &= PAGE_MASK;
 	result = kimage_add_entry(image, destination | IND_DESTINATION);
-	if (result == 0)
-		image->destination = destination;
 
 	return result;
 }
@@ -869,8 +867,6 @@ static int kimage_add_page(struct kimage *image, unsigned long page)
 
 	page &= PAGE_MASK;
 	result = kimage_add_entry(image, page | IND_SOURCE);
-	if (result == 0)
-		image->destination += PAGE_SIZE;
 
 	return result;
 }
-- 
1.8.5.3

