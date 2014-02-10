Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaBJXVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:21:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbaBJXVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:21:08 -0500
Message-ID: <1392074440.15608.183.camel@ul30vt.home>
Subject: Re: [RFC PATCH v4 06/10] VFIO_PLATFORM: Read and write support for
 the device fd
From: Alex Williamson <alex.williamson@redhat.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org, jan.kiszka@siemens.com,
        kvm@vger.kernel.org, R65777@freescale.com, B07421@freescale.com,
        christoffer.dall@linaro.org, agraf@suse.de, B16395@freescale.com,
        will.deacon@arm.com
Date: Mon, 10 Feb 2014 16:20:40 -0700
In-Reply-To: <1392073951.6733.383.camel@snotra.buserror.net>
References: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1391880580-471-7-git-send-email-a.motakis@virtualopensystems.com>
	 <1392072326.15608.181.camel@ul30vt.home>
	 <1392073951.6733.383.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 17:12 -0600, Scott Wood wrote:
> On Mon, 2014-02-10 at 15:45 -0700, Alex Williamson wrote:
> > On Sat, 2014-02-08 at 18:29 +0100, Antonios Motakis wrote:
> > > VFIO returns a file descriptor which we can use to manipulate the memory
> > > regions of the device. Since some memory regions we cannot mmap due to
> > > security concerns, we also allow to read and write to this file descriptor
> > > directly.
> > > 
> > > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > > Tested-by: Alvise Rigo <a.rigo@virtualopensystems.com>
> > > ---
> > >  drivers/vfio/platform/vfio_platform.c | 128 +++++++++++++++++++++++++++++++++-
> > >  1 file changed, 125 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> > > index f7db5c0..ee96078 100644
> > > --- a/drivers/vfio/platform/vfio_platform.c
> > > +++ b/drivers/vfio/platform/vfio_platform.c
> > > @@ -55,7 +55,8 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
> > >  
> > >  		region.addr = res->start;
> > >  		region.size = resource_size(res);
> > > -		region.flags = 0;
> > > +		region.flags = VFIO_REGION_INFO_FLAG_READ
> > > +				| VFIO_REGION_INFO_FLAG_WRITE;
> > >  
> > >  		vdev->region[i] = region;
> > >  	}
> > > @@ -150,13 +151,134 @@ static long vfio_platform_ioctl(void *device_data,
> > >  static ssize_t vfio_platform_read(void *device_data, char __user *buf,
> > >  			     size_t count, loff_t *ppos)
> > >  {
> > > -	return 0;
> > > +	struct vfio_platform_device *vdev = device_data;
> > > +	unsigned int *io;
> > > +	int i;
> > > +
> > > +	for (i = 0; i < vdev->num_regions; i++) {
> > > +		struct vfio_platform_region region = vdev->region[i];
> > > +		unsigned int done = 0;
> > > +		loff_t off;
> > > +
> > > +		if ((*ppos < region.addr)
> > > +		     || (*ppos + count - 1) >= (region.addr + region.size))
> > > +			continue;
> > 
> > Perhaps there's something to be said for vfio-pci's use of fixed offsets
> > to have a direct offset to index lookup.
> > 
> > > +
> > > +		io = ioremap_nocache(region.addr, region.size);
> > 
> > This must incur some overhead per access.
> 
> There's mmap() if you want fast...  Given the limited ioremap space on
> 32-bit, I can see not wanting to map everything that the user has open
> all the time -- but in that case, wouldn't it be better to just map one
> page here rather than the whole region?
> 
> > > +
> > > +		off = *ppos - region.addr;
> > > +
> > > +		while (count) {
> > > +			size_t filled;
> > > +
> > > +			if (count >= 4 && !(off % 4)) {
> > > +				u32 val;
> > > +
> > > +				val = ioread32(io + off);
> > > +				if (copy_to_user(buf, &val, 4))
> > > +					goto err;
> > 
> > For vfio-pci we've decided that these interfaces are always little
> > endian, have you considered whether it makes sense to do something
> > similar here?  Thanks,
> 
> ioread32() is little endian -- but since read() puts its result in the
> caller's memory buffer (rather than a register return), I think it makes
> more sense to preserve byte-invariance -- similar to the conclusion of
> the recent KVM MMIO API clarification discussion.  Then the VFIO user
> would use the same type of access (byte swapped or not) to access the
> read() buffer that they would have used to access the register directly.
> 
> Forcing little endian is a better fit for PCI (which is inherently
> little endian) than for platform devices which can be either endianness.

Ok, works for me.  Thanks,

Alex



