Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3LBUB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:01:28 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:44184 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab3LBUBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:01:24 -0500
From: Ivaylo DImitrov <ivo.g.dimitrov.75@gmail.com>
To: gregkh@linuxfoundation.org
Cc: nico@ngolde.de, fabs@goesec.de, omar.ramirez@copitl.com,
        pali.rohar@gmail.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, tony@atomide.com,
        felipe.contreras@gmail.com, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: [PATCH] Staging: TIDSPBRIDGE: Use vm_iomap_memory for mmap-ing instead of remap_pfn_range
Date: Mon,  2 Dec 2013 22:00:16 +0200
Message-Id: <1386014416-4556-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivaylo Dimitrov <freemangordon@abv.bg>

This fixes the following bug:

----  Bug Report ----

source file: drivers/staging/tidspbridge/rmgr/drv_interface.c
issue      : mapping of physical memory without address range checks

259 static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
260 {
261         u32 status;
262
263         /* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
264         vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
265
266         dev_dbg(bridge, "%s: vm filp %p start %lx end %lx page_prot %ulx "
267                 "flags %lx\n", __func__, filp,
268                 vma->vm_start, vma->vm_end, vma->vm_page_prot,
269                 vma->vm_flags);
270
271         status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
272                                  vma->vm_end - vma->vm_start,
273                                  vma->vm_page_prot);
274         if (status != 0)
275                 status = -EAGAIN;
276
277         return status;
278 }

The function provides an interface to remap physical memory to user space, but
does not provide any checks to ensure that the memory is within the region that
should be accessible.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>

Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 1aa4a3f..2d500ea 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -258,8 +258,9 @@ err:
 /* This function maps kernel space memory to user space memory. */
 static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	u32 status;
-
+	struct omap_dsp_platform_data *pdata =
+	    omap_dspbridge_dev->dev.platform_data;
+	
 	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
@@ -268,13 +269,9 @@ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 		vma->vm_start, vma->vm_end, vma->vm_page_prot,
 		vma->vm_flags);
 
-	status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-				 vma->vm_end - vma->vm_start,
-				 vma->vm_page_prot);
-	if (status != 0)
-		status = -EAGAIN;
-
-	return status;
+	return vm_iomap_memory(vma,
+			       pdata->phys_mempool_base,
+			       pdata->phys_mempool_size);
 }
 
 static const struct file_operations bridge_fops = {
-- 
1.5.6.1

