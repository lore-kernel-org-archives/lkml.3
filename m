Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaA0S64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:58:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbaA0S6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:58:44 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 09/11] kexec: Provide a function to add a segment at fixed address
Date: Mon, 27 Jan 2014 13:57:49 -0500
Message-Id: <1390849071-21989-10-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kexec_add_buffer() can find a suitable range of memory for user buffer and
add it to list of segments. But ELF loader will require that a buffer can
be loaded at the address it has been compiled for (ET_EXEC type executables).
So we need a helper function which can see if requested memory is valid and
available and add a segment accordiingly. This patch provides that helper
function. It will be used by elf loader in later patch.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/kexec.h |  3 +++
 kernel/kexec.c        | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d391ed7..2fb052c 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -208,6 +208,9 @@ extern asmlinkage long sys_kexec_load(unsigned long entry,
 					struct kexec_segment __user *segments,
 					unsigned long flags);
 extern int kernel_kexec(void);
+extern int kexec_add_segment(struct kimage *image, char *buffer,
+			unsigned long bufsz, unsigned long memsz,
+			unsigned long base);
 extern int kexec_add_buffer(struct kimage *image, char *buffer,
 			unsigned long bufsz, unsigned long memsz,
 			unsigned long buf_align, unsigned long buf_min,
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 20169a4..9e4718b 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -2002,6 +2002,71 @@ static int __kexec_add_segment(struct kimage *image, char *buf,
 	return 0;
 }
 
+static int validate_ram_range_callback(u64 start, u64 end, void *arg)
+{
+	struct kexec_segment *ksegment = arg;
+	u64 mstart = ksegment->mem;
+	u64 mend = ksegment->mem + ksegment->memsz - 1;
+
+	/* Found a valid range. Stop going through more ranges */
+	if (mstart >= start && mend <= end)
+		return 1;
+
+	/* Range did not match. Go to next one */
+	return 0;
+}
+
+/* Add a kexec segment at fixed address provided by caller */
+int kexec_add_segment(struct kimage *image, char *buffer, unsigned long bufsz,
+			unsigned long memsz, unsigned long base)
+{
+	struct kexec_segment ksegment;
+	int ret;
+
+	/* Currently adding segment this way is allowed only in file mode */
+	if (!image->file_mode)
+		return -EINVAL;
+
+	if (image->nr_segments >= KEXEC_SEGMENT_MAX)
+		return -EINVAL;
+
+	/*
+	 * Make sure we are not trying to add segment after allocating
+	 * control pages. All segments need to be placed first before
+	 * any control pages are allocated. As control page allocation
+	 * logic goes through list of segments to make sure there are
+	 * no destination overlaps.
+	 */
+	WARN_ONCE(!list_empty(&image->control_pages), "Adding kexec segment"
+			" after allocating control pages\n");
+
+	if (bufsz > memsz)
+		return -EINVAL;
+	if (memsz == 0)
+		return -EINVAL;
+
+	/* Align memsz to next page boundary */
+	memsz = ALIGN(memsz, PAGE_SIZE);
+
+	/* Make sure base is atleast page size aligned */
+	if (base & (PAGE_SIZE - 1))
+		return -EINVAL;
+
+	memset(&ksegment, 0, sizeof(struct kexec_segment));
+	ksegment.mem = base;
+	ksegment.memsz = memsz;
+
+	/* Validate memory range */
+	ret = walk_system_ram_res(base, base + memsz - 1, &ksegment,
+				validate_ram_range_callback);
+
+	/* If a valid range is found, 1 is returned */
+	if (ret != 1)
+		return -EINVAL;
+
+	return __kexec_add_segment(image, buffer, bufsz, base, memsz);
+}
+
 static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 					struct kexec_buf *kbuf)
 {
-- 
1.8.4.2

