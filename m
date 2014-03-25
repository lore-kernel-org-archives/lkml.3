Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaCYS4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbaCYS4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:56:50 -0400
Message-ID: <1395773793.632.152.camel@ul30vt.home>
Subject: Re: [RFC PATCH v4 06/10] VFIO_PLATFORM: Read and write support for
 the device fd
From: Alex Williamson <alex.williamson@redhat.com>
To: Eric Auger <eric.auger@linaro.org>
Cc: a.motakis@virtualopensystems.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, tech@virtualopensystems.com,
        a.rigo@virtualopensystems.com, B08248@freescale.com,
        kim.phillips@linaro.org, jan.kiszka@siemens.com, kvm@vger.kernel.org,
        R65777@freescale.com, B07421@freescale.com,
        christoffer.dall@linaro.org, agraf@suse.de, B16395@freescale.com,
        will.deacon@arm.com
Date: Tue, 25 Mar 2014 12:56:33 -0600
In-Reply-To: <5331B22C.6090100@linaro.org>
References: <20140325110619.52107df5d6d0cf0476b33cd4@linaro.org>
	 <5331B22C.6090100@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 17:43 +0100, Eric Auger wrote:
> > Date: Sat,  8 Feb 2014 18:29:36 +0100
> > VFIO returns a file descriptor which we can use to manipulate the memory
> > regions of the device. Since some memory regions we cannot mmap due to
> > security concerns, we also allow to read and write to this file descriptor
> > directly.
> > 
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > Tested-by: Alvise Rigo <a.rigo@virtualopensystems.com>
> > ---
> >  drivers/vfio/platform/vfio_platform.c | 128 +++++++++++++++++++++++++++++++++-
> >  1 file changed, 125 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> > index f7db5c0..ee96078 100644
> > --- a/drivers/vfio/platform/vfio_platform.c
> > +++ b/drivers/vfio/platform/vfio_platform.c
> > @@ -55,7 +55,8 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
> >  
> >  		region.addr = res->start;
> >  		region.size = resource_size(res);
> > -		region.flags = 0;
> > +		region.flags = VFIO_REGION_INFO_FLAG_READ
> > +				| VFIO_REGION_INFO_FLAG_WRITE;
> >  
> >  		vdev->region[i] = region;
> >  	}
> > @@ -150,13 +151,134 @@ static long vfio_platform_ioctl(void *device_data,
> >  static ssize_t vfio_platform_read(void *device_data, char __user *buf,
> >  			     size_t count, loff_t *ppos)
> >  {
> > -	return 0;
> > +	struct vfio_platform_device *vdev = device_data;
> > +	unsigned int *io;
> > +	int i;
> > +
> > +	for (i = 0; i < vdev->num_regions; i++) {
> > +		struct vfio_platform_region region = vdev->region[i];
> > +		unsigned int done = 0;
> > +		loff_t off;
> > +
> > +		if ((*ppos < region.addr)
> > +		     || (*ppos + count - 1) >= (region.addr + region.size))
> > +			continue;
> > +
> > +		io = ioremap_nocache(region.addr, region.size);
> > +
> > +		off = *ppos - region.addr;
> > +
> > +		while (count) {
> > +			size_t filled;
> > +
> > +			if (count >= 4 && !(off % 4)) {
> > +				u32 val;
> > +
> > +				val = ioread32(io + off);
> 
> Hi Antonios,
> 
> I suspect there is an issue with the read address. Indeed io being an
> unsigned int* the read address is io + off x sizeof (unsigned int) ie.
> io+ offx4  whereas we expect to read io + off. declaring io as a void*
> corrects the issue (or void __iomem *io). Same issue on write.

Yep, the same code for vfio/pci uses void __iomem *io.  Thanks,

Alex

