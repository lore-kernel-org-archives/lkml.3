Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3LAMKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:10:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36136 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3LAMKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:10:08 -0500
Date: Sun, 1 Dec 2013 13:10:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<ivo.g.dimitrov.75@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1?= <pali.rohar@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU?= <freemangordon@abv.bg>, sre@ring0.de,
        omar.ramirez@copitl.com, tony@atomide.com, felipe.contreras@gmail.com,
        s-anna@ti.com, nm@ti.com, ohad@wizery.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, nico@ngolde.de
Subject: Re: [patch] Staging: tidspbridge: make mmap root-only so it is not
 a security problem
Message-ID: <20131201121006.GA26072@amd.pavel.ucw.cz>
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
 <20131130220553.GA1901@kroah.com>
 <20131130225822.GA26031@amd.pavel.ucw.cz>
 <201312011041.40071@pali>
 <1385891913.11457.2.camel@Nokia-N900>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385891913.11457.2.camel@Nokia-N900>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I can (and will) test whatever patches is needed. Also will try to get rid of uuid helpers and send a patch today.
> 

So ... here's patch that you can start from, and that may even work...

Thanks,
									Pavel

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 1aa4a3f..a8e86cf 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -258,7 +258,17 @@ err:
 /* This function maps kernel space memory to user space memory. */
 static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	u32 status;
+	int status;
+	struct omap_dsp_platform_data *pdata =
+	    omap_dspbridge_dev->dev.platform_data;
+	unsigned long start = vma->vm_pgoff << PAGE_SHIFT;
+		
+	if (start < pdata->phys_mempool_base)
+		return -EINVAL;
+
+	if (vma->vm_end - vma->vm_start + (start - pdata->phys_mempool_base) 
+	    > pdata->phys_mempool_size)
+		return -EINVAL;
 
 	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
@@ -271,10 +281,10 @@ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 	status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 				 vma->vm_end - vma->vm_start,
 				 vma->vm_page_prot);
-	if (status != 0)
-		status = -EAGAIN;
+	if (status)
+		return -EAGAIN;
 
-	return status;
+	return 0;
 }
 
 static const struct file_operations bridge_fops = {


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
