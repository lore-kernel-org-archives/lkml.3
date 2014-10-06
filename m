Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaJFD0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 23:26:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaJFD0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 23:26:04 -0400
Date: Sun, 5 Oct 2014 20:25:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jason Noakes <jjnoakes@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kobject_init and the zeroed-out-memory requirement
Message-ID: <20141006032505.GD2722@kroah.com>
References: <CAN2+FEJY29jDF2PkGAYcG_0z=VQ4T+y7Ro56aeqrhSPYQ6ZEdw@mail.gmail.com>
 <20141005202843.GA1282@kroah.com>
 <CAN2+FEKsVyjV8v98R+V-xHseH1E2NKPquo6Z9nQc0M8d0Z620A@mail.gmail.com>
 <20141005215100.GA20426@kroah.com>
 <20141005232457.GA22525@kroah.com>
 <20141006020950.GA29722@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006020950.GA29722@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 07:09:50PM -0700, Guenter Roeck wrote:
> On Sun, Oct 05, 2014 at 04:24:57PM -0700, Greg KH wrote:
> > On Sun, Oct 05, 2014 at 06:13:05PM -0400, Jason Noakes wrote:
> > > > No driver should be working with "raw" kobjects.
> > > 
> > > I don't agree, but it's irrelevant.
> > 
> > Not at all.  I'd wager that if a driver is messing around with a "raw"
> > kobject, it is doing something seriously wrong.  Of course there are
> > exceptions, but those are very rare, and exceptions.  A driver should be
> > using the driver core, and the functions and objects provided there, and
> > provided by the bus it lives on.
> > 
> > So, have a pointer to some driver code that is calling
> > kobject_initialize()?  I'd love to see it.
> > 
> 
> Lots to choose from. In drivers/:
> 
> $ git grep kobject_init | wc
>      65     289    4880
> $ git grep kobject_init | grep -v base | wc
>      62     277    4694
> $ git grep kobject_init_and_add | grep -v base | wc
>      47     232    3698
> $ git grep kobject_add | grep -v base | wc
>      20     111    1486

Well, you hit firmware layer, and block devices, which have to deal with
kobjects directly at times.  But these files look "suspicious":
	edac/edac_device_sysfs.c
	edac/edac_pci_sysfs.c
	gpu/drm/ttm/ttm_bo.c
	gpu/drm/ttm/ttm_memory.c
	gpu/drm/ttm/ttm_page_alloc.c
	gpu/drm/ttm/ttm_page_alloc_dma.c
	infiniband/core/cm.c
	infiniband/core/sysfs.c
	infiniband/core/user_mad.c
	infiniband/hw/mlx4/sysfs.c
	infiniband/hw/qib/qib_sysfs.c
	infiniband/hw/usnic/usnic_ib_sysfs.c
	iommu/iommu.c
	parisc/pdc_stable.c
	pci/slot.c
	power/ab8500_fg.c
	power/abx500_chargalg.c
	scsi/iscsi_boot_sysfs.c
	uio/uio.c
	video/fbdev/omap2/dss/manager-sysfs.c
	video/fbdev/omap2/dss/overlay-sysfs.c

I'll look into them tomorrow...

But that's still a very small minority compared to the tens of thousands
of drivers we have, so I still say it's wrong to have a driver deal with
raw kobjects.

thanks,

greg k-h
