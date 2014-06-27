Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaF0SBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:01:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaF0SBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:01:51 -0400
Date: Fri, 27 Jun 2014 12:34:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org
Subject: [PATCH 16/15] kexec: Fix freeing up for image loader data loading
Message-ID: <20140627163423.GG13337@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During testing I noticed a crash. Which in turn showed that there are
problems with how I am freeing up image->image_loader_data.

In one case I am freeing up kimage->image_loader_data first and then
calling up arch to free up which might have been contained in that
structure. That's wrong.

I have done little cleanup and this should fix the issues around
freeing up of loader data.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kernel/kexec-bzimage64.c  |    4 ++--
 arch/x86/kernel/machine_kexec_64.c |    2 +-
 include/linux/kexec.h              |    2 +-
 kernel/kexec.c                     |   11 ++++++++---
 4 files changed, 12 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/machine_kexec_64.c	2014-06-27 09:55:41.824755401 -0400
+++ linux-2.6/arch/x86/kernel/machine_kexec_64.c	2014-06-27 11:02:02.607548946 -0400
@@ -369,7 +369,7 @@ int arch_kimage_file_post_load_cleanup(s
 	if (!image->fops || !image->fops->cleanup)
 		return 0;
 
-	return image->fops->cleanup(image);
+	return image->fops->cleanup(image->image_loader_data);
 }
 
 /*
Index: linux-2.6/include/linux/kexec.h
===================================================================
--- linux-2.6.orig/include/linux/kexec.h	2014-06-27 09:55:41.695754029 -0400
+++ linux-2.6/include/linux/kexec.h	2014-06-27 11:04:28.467151813 -0400
@@ -190,7 +190,7 @@ typedef void *(kexec_load_t)(struct kima
 			     unsigned long kernel_len, char *initrd,
 			     unsigned long initrd_len, char *cmdline,
 			     unsigned long cmdline_len);
-typedef int (kexec_cleanup_t)(struct kimage *image);
+typedef int (kexec_cleanup_t)(void *loader_data);
 
 struct kexec_file_ops {
 	kexec_probe_t *probe;
Index: linux-2.6/arch/x86/kernel/kexec-bzimage64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kexec-bzimage64.c	2014-06-27 09:55:41.872755912 -0400
+++ linux-2.6/arch/x86/kernel/kexec-bzimage64.c	2014-06-27 11:05:42.151963710 -0400
@@ -512,9 +512,9 @@ out_free_params:
 }
 
 /* This cleanup function is called after various segments have been loaded */
-int bzImage64_cleanup(struct kimage *image)
+int bzImage64_cleanup(void *loader_data)
 {
-	struct bzimage64_data *ldata = image->image_loader_data;
+	struct bzimage64_data *ldata = loader_data;
 
 	if (!ldata)
 		return 0;
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c	2014-06-27 10:04:23.409024171 -0400
+++ linux-2.6/kernel/kexec.c	2014-06-27 11:45:14.684874978 -0400
@@ -459,6 +459,14 @@ static void kimage_file_post_load_cleanu
 
 	/* See if architecture has anything to cleanup post load */
 	arch_kimage_file_post_load_cleanup(image);
+
+	/*
+	 * Above call should have called into bootloader to free up
+	 * any data stored in kimage->image_loader_data. It should
+	 * be ok now to free it up.
+	 */
+	kfree(image->image_loader_data);
+	image->image_loader_data = NULL;
 }
 
 /*
@@ -584,7 +592,6 @@ out_free_control_pages:
 	kimage_free_page_list(&image->control_pages);
 out_free_post_load_bufs:
 	kimage_file_post_load_cleanup(image);
-	kfree(image->image_loader_data);
 out_free_image:
 	kfree(image);
 	return ret;
@@ -908,8 +915,6 @@ static void kimage_free(struct kimage *i
 	/* Free the kexec control pages... */
 	kimage_free_page_list(&image->control_pages);
 
-	kfree(image->image_loader_data);
-
 	/*
 	 * Free up any temporary buffers allocated. This might hit if
 	 * error occurred much later after buffer allocation.
