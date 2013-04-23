Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab3DWV4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:56:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab3DWV4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:56:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 21/23] vm: convert HPET mmap to vm_iomap_memory() helper
Date: Tue, 23 Apr 2013 14:56:28 -0700
Message-Id: <20130423215458.464671180@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215456.307216898@linuxfoundation.org>
References: <20130423215456.307216898@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2323036dfec8ce3ce6e1c86a49a31b039f3300d1 upstream.

This is my example conversion of a few existing mmap users.  The HPET
case is simple, widely available, and easy to test (Clemens Ladisch sent
a trivial test-program for it).

Test-program-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hpet.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -374,26 +374,14 @@ static int hpet_mmap(struct file *file,
 	struct hpet_dev *devp;
 	unsigned long addr;
 
-	if (((vma->vm_end - vma->vm_start) != PAGE_SIZE) || vma->vm_pgoff)
-		return -EINVAL;
-
 	devp = file->private_data;
 	addr = devp->hd_hpets->hp_hpet_phys;
 
 	if (addr & (PAGE_SIZE - 1))
 		return -ENOSYS;
 
-	vma->vm_flags |= VM_IO;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
-	if (io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
-					PAGE_SIZE, vma->vm_page_prot)) {
-		printk(KERN_ERR "%s: io_remap_pfn_range failed\n",
-			__func__);
-		return -EAGAIN;
-	}
-
-	return 0;
+	return vm_iomap_memory(vma, addr, PAGE_SIZE);
 #else
 	return -ENOSYS;
 #endif


