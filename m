Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3EJOUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57022 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212Ab3EJOUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.140658113@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [084/118] vm: convert HPET mmap to vm_iomap_memory() helper
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2323036dfec8ce3ce6e1c86a49a31b039f3300d1 upstream.

This is my example conversion of a few existing mmap users.  The HPET
case is simple, widely available, and easy to test (Clemens Ladisch sent
a trivial test-program for it).

Test-program-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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

