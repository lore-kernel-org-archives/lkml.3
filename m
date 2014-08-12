Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaHLFa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:30:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbaHLFaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:30:55 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, vgoyal@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, Baoquan He <bhe@redhat.com>
Subject: [PATCH 1/2] take the segment adding out of locate_mem_hole functions
Date: Tue, 12 Aug 2014 13:29:27 +0800
Message-Id: <1407821368-2358-1-git-send-email-bhe@redhat.com>
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

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/kexec.h | 1 +
 kernel/kexec.c        | 9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

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
index 0b49a0a..586444e 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -2054,8 +2054,7 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 	} while (1);
 
 	/* If we are here, we found a suitable memory range */
-	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
-			    kbuf->memsz);
+	kbuf->mem = temp_start;
 
 	/* Success, stop navigating through remaining System RAM ranges */
 	return 1;
@@ -2089,8 +2088,7 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 	} while (1);
 
 	/* If we are here, we found a suitable memory range */
-	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
-			    kbuf->memsz);
+	kbuf->mem = temp_start;
 
 	/* Success, stop navigating through remaining System RAM ranges */
 	return 1;
@@ -2176,6 +2174,9 @@ int kexec_add_buffer(struct kimage *image, char *buffer, unsigned long bufsz,
 		return -EADDRNOTAVAIL;
 	}
 
+	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, kbuf->mem,
+			    kbuf->memsz);
+
 	/* Found a suitable memory range */
 	ksegment = &image->segment[image->nr_segments - 1];
 	*load_addr = ksegment->mem;
-- 
1.8.5.3

