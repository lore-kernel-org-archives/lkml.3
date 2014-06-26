Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaFZUfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaFZUfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:35:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 05/15] kexec: Use common function for kimage_normal_alloc() and kimage_crash_alloc()
Date: Thu, 26 Jun 2014 16:33:34 -0400
Message-Id: <1403814824-7587-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kimage_normal_alloc() and kimage_crash_alloc() are doing lot of similar
things and differ only little. So instead of having two separate functions
create a common function kimage_alloc_init() and pass it the "flags"
argument which tells whether it is normal kexec or kexec_on_panic. And
this function should be able to deal with both the cases.

This consolidation also helps later where we can use a common function
kimage_file_alloc_init() to handle normal and crash cases for new file
based kexec syscall.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/kexec.c | 105 +++++++++++++++++++--------------------------------------
 1 file changed, 34 insertions(+), 71 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 44e823e..c69ce00 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -260,12 +260,20 @@ static struct kimage *do_kimage_alloc_init(void)
 
 static void kimage_free_page_list(struct list_head *list);
 
-static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
-				unsigned long nr_segments,
-				struct kexec_segment __user *segments)
+static int kimage_alloc_init(struct kimage **rimage, unsigned long entry,
+			     unsigned long nr_segments,
+			     struct kexec_segment __user *segments,
+			     unsigned long flags)
 {
-	int result;
+	int ret;
 	struct kimage *image;
+	bool kexec_on_panic = flags & KEXEC_ON_CRASH;
+
+	if (kexec_on_panic) {
+		/* Verify we have a valid entry point */
+		if ((entry < crashk_res.start) || (entry > crashk_res.end))
+			return -EADDRNOTAVAIL;
+	}
 
 	/* Allocate and initialize a controlling structure */
 	image = do_kimage_alloc_init();
@@ -274,20 +282,26 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
 
 	image->start = entry;
 
-	result = copy_user_segment_list(image, nr_segments, segments);
-	if (result)
+	ret = copy_user_segment_list(image, nr_segments, segments);
+	if (ret)
 		goto out_free_image;
 
-	result = sanity_check_segment_list(image);
-	if (result)
+	ret = sanity_check_segment_list(image);
+	if (ret)
 		goto out_free_image;
 
+	 /* Enable the special crash kernel control page allocation policy. */
+	if (kexec_on_panic) {
+		image->control_page = crashk_res.start;
+		image->type = KEXEC_TYPE_CRASH;
+	}
+
 	/*
 	 * Find a location for the control code buffer, and add it
 	 * the vector of segments so that it's pages will also be
 	 * counted as destination pages.
 	 */
-	result = -ENOMEM;
+	ret = -ENOMEM;
 	image->control_code_page = kimage_alloc_control_pages(image,
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
@@ -295,10 +309,12 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
 		goto out_free_image;
 	}
 
-	image->swap_page = kimage_alloc_control_pages(image, 0);
-	if (!image->swap_page) {
-		pr_err("Could not allocate swap buffer\n");
-		goto out_free_control_pages;
+	if (!kexec_on_panic) {
+		image->swap_page = kimage_alloc_control_pages(image, 0);
+		if (!image->swap_page) {
+			pr_err("Could not allocate swap buffer\n");
+			goto out_free_control_pages;
+		}
 	}
 
 	*rimage = image;
@@ -307,60 +323,7 @@ out_free_control_pages:
 	kimage_free_page_list(&image->control_pages);
 out_free_image:
 	kfree(image);
-	return result;
-}
-
-static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
-				unsigned long nr_segments,
-				struct kexec_segment __user *segments)
-{
-	int result;
-	struct kimage *image;
-
-	/* Verify we have a valid entry point */
-	if ((entry < crashk_res.start) || (entry > crashk_res.end))
-		return -EADDRNOTAVAIL;
-
-	/* Allocate and initialize a controlling structure */
-	image = do_kimage_alloc_init();
-	if (!image)
-		return -ENOMEM;
-
-	image->start = entry;
-
-	/* Enable the special crash kernel control page
-	 * allocation policy.
-	 */
-	image->control_page = crashk_res.start;
-	image->type = KEXEC_TYPE_CRASH;
-
-	result = copy_user_segment_list(image, nr_segments, segments);
-	if (result)
-		goto out_free_image;
-
-	result = sanity_check_segment_list(image);
-	if (result)
-		goto out_free_image;
-
-	/*
-	 * Find a location for the control code buffer, and add
-	 * the vector of segments so that it's pages will also be
-	 * counted as destination pages.
-	 */
-	result = -ENOMEM;
-	image->control_code_page = kimage_alloc_control_pages(image,
-					   get_order(KEXEC_CONTROL_PAGE_SIZE));
-	if (!image->control_code_page) {
-		pr_err("Could not allocate control_code_buffer\n");
-		goto out_free_image;
-	}
-
-	*rimage = image;
-	return 0;
-
-out_free_image:
-	kfree(image);
-	return result;
+	return ret;
 }
 
 static int kimage_is_destination_range(struct kimage *image,
@@ -1003,16 +966,16 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 
 		/* Loading another kernel to reboot into */
 		if ((flags & KEXEC_ON_CRASH) == 0)
-			result = kimage_normal_alloc(&image, entry,
-							nr_segments, segments);
+			result = kimage_alloc_init(&image, entry, nr_segments,
+						   segments, flags);
 		/* Loading another kernel to switch to if this one crashes */
 		else if (flags & KEXEC_ON_CRASH) {
 			/* Free any current crash dump kernel before
 			 * we corrupt it.
 			 */
 			kimage_free(xchg(&kexec_crash_image, NULL));
-			result = kimage_crash_alloc(&image, entry,
-						     nr_segments, segments);
+			result = kimage_alloc_init(&image, entry, nr_segments,
+						   segments, flags);
 			crash_map_reserved_pages();
 		}
 		if (result)
-- 
1.9.0

