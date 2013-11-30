Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab3K3Umo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 15:42:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43467 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3K3Umj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 15:42:39 -0500
Date: Sat, 30 Nov 2013 21:42:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>, gregkh@linuxfoundation.org,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        pali.rohar@gmail.com, sre@ring0.de, omar.ramirez@copitl.com,
        tony@atomide.com, felipe.contreras@gmail.com, s-anna@ti.com, nm@ti.com,
        ohad@wizery.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        nico@ngolde.de
Subject: [patch] Staging: tidspbridge: make mmap root-only so it is not a
 security problem
Message-ID: <20131130204237.GA17912@amd.pavel.ucw.cz>
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
 <20131130191931.GA5286@amd.pavel.ucw.cz>
 <20131130194935.GG5443@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131130194935.GG5443@mwanda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mmap in tidspbridge is missing range-checks. For now, make this
interface root-only, so that it does not cause security problems.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>

---

On Sat 2013-11-30 22:49:35, Dan Carpenter wrote:
> On Sat, Nov 30, 2013 at 08:19:32PM +0100, Pavel Machek wrote:
> > so perhaps Nico Golde or Dan Carpenter can elaborate? I Cc-ed them
> > now.
> > 
> > Or is it some kind of super-secret issue and still under embargo for
> > 10 days?
> 
> Nope,  it's not secret.  Here is the original report from Nico and
> Fabian.  Please give them credit when you fix the bug.

Thanks!

> Felipe Contreras says we could just remove mmap() support and the driver
> would still work, but no one has submitted a patch to do that.  Really
> this driver needs an actual maintainer who will respond to security bugs
> and also start to move the driver out of staging.

There starts to be real traction around Nokia N900, so I believe it is
going to be fixed. (And with Nemo/Mer getting popularity due to Jolla,
it should get even better).

But no, I did not figure out how to run Nemo in qemu, yet...
									Pavel 

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 1aa4a3f..8533e67 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -258,7 +258,10 @@ err:
 /* This function maps kernel space memory to user space memory. */
 static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	u32 status;
+	int status;
+
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 
 	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
@@ -271,10 +274,10 @@ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
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
