Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab3K3TuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 14:50:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42710 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3K3TuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 14:50:14 -0500
Date: Sat, 30 Nov 2013 22:49:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>, gregkh@linuxfoundation.org,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        pali.rohar@gmail.com, sre@ring0.de, omar.ramirez@copitl.com,
        tony@atomide.com, felipe.contreras@gmail.com, s-anna@ti.com, nm@ti.com,
        ohad@wizery.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        nico@ngolde.de
Subject: Re: Staging: tidspbridge: disable driver
Message-ID: <20131130194935.GG5443@mwanda>
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
 <20131130191931.GA5286@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131130191931.GA5286@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 08:19:32PM +0100, Pavel Machek wrote:
> so perhaps Nico Golde or Dan Carpenter can elaborate? I Cc-ed them
> now.
> 
> Or is it some kind of super-secret issue and still under embargo for
> 10 days?
> 									Pavel

Nope,  it's not secret.  Here is the original report from Nico and
Fabian.  Please give them credit when you fix the bug.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>

Felipe Contreras says we could just remove mmap() support and the driver
would still work, but no one has submitted a patch to do that.  Really
this driver needs an actual maintainer who will respond to security bugs
and also start to move the driver out of staging.

regards,
dan carpenter

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

