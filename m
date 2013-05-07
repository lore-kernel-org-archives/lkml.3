Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab3EGEfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:35:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab3EGEZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:51 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=OMtK5XQDKzQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PcfeZpVhSdUA:10 a=Z4Rwk6OoAAAA:8 a=weg8JgaIAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=jbrJJM5MRmoA:10 a=7t4jVOfIR2gA:10 a=jeBq3FmKZ4MA:10 a=fnfuqj9jWGcA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035855.513733095@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [087/126] vm: convert HPET mmap to vm_iomap_memory() helper
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0087-vm-convert-HPET-mmap-to-vm_iomap_memory-helper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 2323036dfec8ce3ce6e1c86a49a31b039f3300d1 ]

This is my example conversion of a few existing mmap users.  The HPET
case is simple, widely available, and easy to test (Clemens Ladisch sent
a trivial test-program for it).

Test-program-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/char/hpet.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index dfd7876..0ff5c2e 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -373,26 +373,14 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
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
-- 
1.7.10.4


