Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab3LGXy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 18:54:58 -0500
Received: from nm5-vm6.access.bullet.mail.gq1.yahoo.com ([216.39.63.153]:48162
	"HELO nm5-vm6.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754848Ab3LGXyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 18:54:55 -0500
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Dec 2013 18:54:55 EST
X-Yahoo-Newman-Id: 751213.5595.bm@smtp111.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VfXScUwVM1mxAu6pqqf.tEhghOCfUoLni.a5a5aFdb__0aq
 _cjeseg04DORJBhGYLVJbEnQAd7RqRtXw8Cn97mwIwDCB_c4W7RovHt76Ovp
 mkXeGIk29ulaUXfWeKg2K1jTBcprkKX_vHmShCSGKUgbESeWhw5TPAs9dX7A
 F9PQTx3.5QRoY3fXhFtNiiUYhZDa7DIU4gTIy3kb43X2gwBHABFHmgbMNy0l
 FLLtkzVowxm4t6MUHC1GU0lugglfk9Ptlfrl0GoSg1X6eQZ9YBKiGhIeO7RC
 7uoE7sLZ3LzWPaONUzEpW2ZPd3WS6WHIjQLLqQL9Ul9tk2P_SK73mw9WEH81
 rsmGWQ9GZ3vHqKdmejuWLYQi0n9m8tkReeYxB3z4tDPFDGuA0JaCyn9FdTz2
 mcUwILITTwNIb_zQDhtjFLP2pRTTQOb1ODy1srJ6.38xjfc1BXazo4dAGd1e
 CZApE0aAHP9y46lpjsfdFh3HDTKUe3jYZTZMARXXP5_4CJaTgZ_uPH_pWhUP
 Qmq4KWoO05cDEvPsz1g4554Xz033p3ySgTUpLL1FfnyMuePIRZiN5PJ6ORD_
 JFKZgEzci.yI-
X-Yahoo-SMTP: Y7o5YpyswBBHhc3nmZojVAb_njS6isj_ExStQZr.uIjYoAwP
X-Rocket-Received: from carmel.steven676.net (steven@99.189.118.176 with plain [67.195.15.66])
        by smtp111.sbc.mail.gq1.yahoo.com with SMTP; 07 Dec 2013 23:49:14 +0000 UTC
Date: Sat, 7 Dec 2013 15:49:12 -0800
From: Steven Luo <steven@steven676.net>
To: ?????? ???????? <ivo.g.dimitrov.75@gmail.com>
Cc: gregkh@linuxfoundation.org, nico@ngolde.de, fabs@goesec.de,
        omar.ramirez@copitl.com, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        tony@atomide.com, felipe.contreras@gmail.com,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Use vm_iomap_memory for mmap-ing
 instead of remap_pfn_range
Message-ID: <20131207234912.GA1245@steven676.net>
References: <1386014416-4556-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386014416-4556-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch causes problems with DSP codecs on OMAP3 devices running
Android -- specifically, when the decoder is cleaning up after itself,
munmap() of the mapped area fails, leading to a memory leak which
eventually crashes the system.

As far as I can tell, the code with this patch applied reduces to
(ignoring checks and such)

remap_pfn_range(vma, vma->vm_start,
	(pdata->phys_mempool_base >> PAGE_SHIFT) + vma->vm_pgoff,
	vma->vm_end - vma->vm_start,
	vma->vm_page_prot);

whereas the original was

> -	status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> -				 vma->vm_end - vma->vm_start,
> -				 vma->vm_page_prot);

We're subtracting (pdata->phys_mempool_base >> PAGE_SHIFT) from
vma->vm_pgoff before calling vm_iomap_memory() to address the issue --
if that's satisfactory to everyone involved, I can submit the following
patch.

-Steven Luo

(please cc, not subscribed)

From: Steven Luo <steven@steven676.net>
Date: Sat, 7 Dec 2013 02:11:20 -0800
Subject: [PATCH] tidspbridge: fix last patch to map same region of physical
 memory as before

Commit 559c71fe5dc3 ("Staging: TIDSPBRIDGE: Use vm_iomap_memory for
mmap-ing instead of remap_pfn_range") had the effect of inadvertently
shifting the start of the physical memory area mapped by
pdata->phys_mempool_base.  Correct this by subtracting that shift before
calling vm_iomap_memory() and adding it back afterwards.

Reported-by: Dheeraj CVR <cvr.dheeraj@gmail.com>
Signed-off-by: Steven Luo <steven@steven676.net>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |   29 +++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 83cc3a5..d7f7d04 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -258,6 +258,9 @@ err:
 /* This function maps kernel space memory to user space memory. */
 static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 {
+	unsigned long base_pgoff;
+	int status;
+
 	struct omap_dsp_platform_data *pdata =
 	    omap_dspbridge_dev->dev.platform_data;
 	
@@ -269,9 +272,29 @@ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
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
+	if (vma->vm_pgoff < base_pgoff)
+		return -EINVAL;
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
1.7.10.4

