Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbaIILiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:38:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbaIILh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:37:59 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, vgoyal@redhat.com, ebiederm@xmission.com,
        tglx@linutronix.de, mingo@redhat.com, Baoquan He <bhe@redhat.com>
Subject: [Patch v2 1/3] take the segment adding out of locate_mem_hole functions
Date: Tue,  9 Sep 2014 19:36:18 +0800
Message-Id: <1410262580-1561-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In locate_mem_hole functions, a memory hole is located and added as
kexec_segment. But from the name of locate_mem_hole, it should only
take responsibility of searching a available memory hole to contain
data of a specified size.

So in this patch add a new field 'mem' into kexec_buf, then take that
kexec segment adding code out of locate_mem_hole_top_down and
locate_mem_hole_bottom_up. This make clear of the functionality of
locate_mem_hole just like it declars to do. And by this
locate_mem_hole_callback chould be used later if anyone want to locate
a memory hole for other use.

Meanwhile Vivek suggested opening code function __kexec_add_segment(),
that way we have to retreive ksegment pointer once and it is easy to
read. So just do it in this patch and remove __kexec_add_segment()
since no one use it anymore.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/kexec.h |  1 +
 kernel/kexec.c        | 29 ++++++++---------------------
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 4b2a0e1..9d957b7 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -178,6 +178,7 @@ struct kexec_buf {
 	struct kimage *image;
 	char *buffer;
 	unsigned long bufsz;
+	unsigned long mem;
 	unsigned long memsz;
 	unsigned long buf_align;
 	unsigned long buf_min;
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2bee072..63bc3cd 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -2016,22 +2016,6 @@ static int __init crash_save_vmcoreinfo_init(void)
 subsys_initcall(crash_save_vmcoreinfo_init);
 
 #ifdef CONFIG_KEXEC_FILE
-static int __kexec_add_segment(struct kimage *image, char *buf,
-			       unsigned long bufsz, unsigned long mem,
-			       unsigned long memsz)
-{
-	struct kexec_segment *ksegment;
-
-	ksegment = &image->segment[image->nr_segments];
-	ksegment->kbuf = buf;
-	ksegment->bufsz = bufsz;
-	ksegment->mem = mem;
-	ksegment->memsz = memsz;
-	image->nr_segments++;
-
-	return 0;
-}
-
 static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 				    struct kexec_buf *kbuf)
 {
@@ -2064,8 +2048,7 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 	} while (1);
 
 	/* If we are here, we found a suitable memory range */
-	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
-			    kbuf->memsz);
+	kbuf->mem = temp_start;
 
 	/* Success, stop navigating through remaining System RAM ranges */
 	return 1;
@@ -2099,8 +2082,7 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 	} while (1);
 
 	/* If we are here, we found a suitable memory range */
-	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
-			    kbuf->memsz);
+	kbuf->mem = temp_start;
 
 	/* Success, stop navigating through remaining System RAM ranges */
 	return 1;
@@ -2187,7 +2169,12 @@ int kexec_add_buffer(struct kimage *image, char *buffer, unsigned long bufsz,
 	}
 
 	/* Found a suitable memory range */
-	ksegment = &image->segment[image->nr_segments - 1];
+	ksegment = &image->segment[image->nr_segments];
+	ksegment->kbuf = kbuf->buffer;
+	ksegment->bufsz = kbuf->bufsz;
+	ksegment->mem = kbuf->mem;
+	ksegment->memsz = kbuf->memsz;
+	image->nr_segments++;
 	*load_addr = ksegment->mem;
 	return 0;
 }
-- 
1.8.5.3

