Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3DOC0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:26:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab3DOCZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:25:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Brad Spengler <spender@grsecurity.net>, linux-mtd@lists.infradead.org
Subject: [ 15/17] mtdchar: fix offset overflow detection
Date: Sun, 14 Apr 2013 19:25:25 -0700
Message-Id: <20130415022353.757501375@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415022352.616689034@linuxfoundation.org>
References: <20130415022352.616689034@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 9c603e53d380459fb62fec7cd085acb0b74ac18f upstream.

Sasha Levin has been running trinity in a KVM tools guest, and was able
to trigger the BUG_ON() at arch/x86/mm/pat.c:279 (verifying the range of
the memory type).  The call trace showed that it was mtdchar_mmap() that
created an invalid remap_pfn_range().

The problem is that mtdchar_mmap() does various really odd and subtle
things with the vma page offset etc, and uses the wrong types (and the
wrong overflow) detection for it.

For example, the page offset may well be 32-bit on a 32-bit
architecture, but after shifting it up by PAGE_SHIFT, we need to use a
potentially 64-bit resource_size_t to correctly hold the full value.

Also, we need to check that the vma length plus offset doesn't overflow
before we check that it is smaller than the length of the mtdmap region.

This fixes things up and tries to make the code a bit easier to read.

Reported-and-tested-by: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/mtdchar.c |   48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1123,6 +1123,33 @@ static unsigned long mtdchar_get_unmappe
 }
 #endif
 
+static inline unsigned long get_vm_size(struct vm_area_struct *vma)
+{
+	return vma->vm_end - vma->vm_start;
+}
+
+static inline resource_size_t get_vm_offset(struct vm_area_struct *vma)
+{
+	return (resource_size_t) vma->vm_pgoff << PAGE_SHIFT;
+}
+
+/*
+ * Set a new vm offset.
+ *
+ * Verify that the incoming offset really works as a page offset,
+ * and that the offset and size fit in a resource_size_t.
+ */
+static inline int set_vm_offset(struct vm_area_struct *vma, resource_size_t off)
+{
+	pgoff_t pgoff = off >> PAGE_SHIFT;
+	if (off != (resource_size_t) pgoff << PAGE_SHIFT)
+		return -EINVAL;
+	if (off + get_vm_size(vma) - 1 < off)
+		return -EINVAL;
+	vma->vm_pgoff = pgoff;
+	return 0;
+}
+
 /*
  * set up a mapping for shared memory segments
  */
@@ -1132,20 +1159,29 @@ static int mtdchar_mmap(struct file *fil
 	struct mtd_file_info *mfi = file->private_data;
 	struct mtd_info *mtd = mfi->mtd;
 	struct map_info *map = mtd->priv;
-	unsigned long start;
-	unsigned long off;
-	u32 len;
+	resource_size_t start, off;
+	unsigned long len, vma_len;
 
 	if (mtd->type == MTD_RAM || mtd->type == MTD_ROM) {
-		off = vma->vm_pgoff << PAGE_SHIFT;
+		off = get_vm_offset(vma);
 		start = map->phys;
 		len = PAGE_ALIGN((start & ~PAGE_MASK) + map->size);
 		start &= PAGE_MASK;
-		if ((vma->vm_end - vma->vm_start + off) > len)
+		vma_len = get_vm_size(vma);
+
+		/* Overflow in off+len? */
+		if (vma_len + off < off)
+			return -EINVAL;
+		/* Does it fit in the mapping? */
+		if (vma_len + off > len)
 			return -EINVAL;
 
 		off += start;
-		vma->vm_pgoff = off >> PAGE_SHIFT;
+		/* Did that overflow? */
+		if (off < start)
+			return -EINVAL;
+		if (set_vm_offset(vma, off) < 0)
+			return -EINVAL;
 		vma->vm_flags |= VM_IO | VM_RESERVED;
 
 #ifdef pgprot_noncached


