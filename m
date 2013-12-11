Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3LKVD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:03:59 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:63580 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3LKVD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:03:56 -0500
From: Ivaylo DImitrov <ivo.g.dimitrov.75@gmail.com>
To: gregkh@linuxfoundation.org
Cc: steven@steven676.net, dan.carpenter@oracle.com, nico@ngolde.de,
        fabs@goesec.de, omar.ramirez@copitl.com, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        tony@atomide.com, felipe.contreras@gmail.com,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: [PATCH] Staging: TIDSPBRIDGE: Fix mmap to map the correct region of physical memory
Date: Wed, 11 Dec 2013 22:51:56 +0200
Message-Id: <1386795116-4204-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
In-Reply-To: <20131211083359.GU28413@mwanda>
References: <20131211083359.GU28413@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Luo <steven@steven676.net>

Commit 559c71fe5dc3 ("Staging: TIDSPBRIDGE: Use vm_iomap_memory for
mmap-ing instead of remap_pfn_range") had the effect of inadvertently
shifting the start of the physical memory area mapped by
pdata->phys_mempool_base.  Correct this by subtracting that shift before
calling vm_iomap_memory() and adding it back afterwards.

Reported-by: Dheeraj CVR <cvr.dheeraj@gmail.com>
Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c | 30 +++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 56e355b..fec5afc 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -258,6 +258,8 @@ err:
 /* This function maps kernel space memory to user space memory. */
 static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 {
+	unsigned long base_pgoff;
+	int status;
 	struct omap_dsp_platform_data *pdata =
 					omap_dspbridge_dev->dev.platform_data;
 
@@ -269,9 +271,31 @@ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 		vma->vm_start, vma->vm_end, vma->vm_page_prot,
 		vma->vm_flags);
 
-	return vm_iomap_memory(vma,
-			       pdata->phys_mempool_base,
-			       pdata->phys_mempool_size);
+	/*
+	 * vm_iomap_memory() expects vma->vm_pgoff to be expressed as an offset
+	 * from the start of the physical memory pool, but we're called with
+	 * a pfn (physical page number) stored there instead.
+	 *
+	 * To avoid duplicating lots of tricky overflow checking logic,
+	 * temporarily convert vma->vm_pgoff to the offset vm_iomap_memory()
+	 * expects, but restore the original value once the mapping has been
+	 * created.
+	 */
+	base_pgoff = pdata->phys_mempool_base >> PAGE_SHIFT;
+
+	if (vma->vm_pgoff < base_pgoff)
+		return -EINVAL;
+
+	vma->vm_pgoff -= base_pgoff;
+
+	status = vm_iomap_memory(vma,
+				 pdata->phys_mempool_base,
+				 pdata->phys_mempool_size);
+
+	/* Restore the original value of vma->vm_pgoff */
+	vma->vm_pgoff += base_pgoff;
+
+	return status;
 }
 
 static const struct file_operations bridge_fops = {
-- 
1.8.4.msysgit.0

