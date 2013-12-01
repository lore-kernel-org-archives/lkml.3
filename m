Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3LAS5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 13:57:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50989 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3LAS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 13:57:11 -0500
Date: Sun, 1 Dec 2013 19:57:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Pali =?iso-8859-1?Q?Roh=E1?= <pali.rohar@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU?= <freemangordon@abv.bg>, sre@ring0.de,
        omar.ramirez@copitl.com, tony@atomide.com, felipe.contreras@gmail.com,
        s-anna@ti.com, nm@ti.com, ohad@wizery.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, nico@ngolde.de
Subject: Re: [patch] Staging: tidspbridge: make mmap root-only so it is not
 a security problem
Message-ID: <20131201185709.GC9743@amd.pavel.ucw.cz>
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
 <20131130220553.GA1901@kroah.com>
 <20131130225822.GA26031@amd.pavel.ucw.cz>
 <201312011041.40071@pali>
 <1385891913.11457.2.camel@Nokia-N900>
 <20131201121006.GA26072@amd.pavel.ucw.cz>
 <20131201122756.GH5443@mwanda>
 <529B7C8D.7060101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529B7C8D.7060101@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
> >>+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
> >>@@ -258,7 +258,17 @@ err:
> >>  /* This function maps kernel space memory to user space memory. */
> >>  static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
> >>  {
> >>-	u32 status;
> >>+	int status;
> >>+	struct omap_dsp_platform_data *pdata =
> >>+	    omap_dspbridge_dev->dev.platform_data;
> >>+	unsigned long start = vma->vm_pgoff << PAGE_SHIFT;
> >>+		
> >>+	if (start < pdata->phys_mempool_base)
> >>+		return -EINVAL;
> >>+
> >>+	if (vma->vm_end - vma->vm_start + (start - pdata->phys_mempool_base)
> >>+	    > pdata->phys_mempool_size)
> >This test is vulnerable to integer overflows if you pick a very high
> >value for start.  Consider using the vm_iomap_memory() helper function
> >instead of calling remap_pfn_range() directly.  Commit 7314e613d5ff
> >('Fix a few incorrectly checked [io_]remap_pfn_range() calls') has an
> >example of how the conversion works.
> >
> >regards,
> >dan carpenter
> >
> Dan,
> 
> If that one looks fine, I'll send a correctly formatted patch.

Looks good to me. Feel free to add

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
