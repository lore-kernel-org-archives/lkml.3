Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab3F1VtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab3F1VtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:49:05 -0400
Message-ID: <1372456136.30572.777.camel@ul30vt.home>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 28 Jun 2013 15:48:56 -0600
In-Reply-To: <20130628192319.GV11309@8bytes.org>
References: <lhtAZ-q1-5@gated-at.bofh.it> <lhtB1-q1-53@gated-at.bofh.it>
	 <20130628181136.52d00e9c@dualc.maya.org>
	 <20130628182533.GT11309@8bytes.org> <51CDD8FD.808@01019freenet.de>
	 <20130628192319.GV11309@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 21:23 +0200, Joerg Roedel wrote:
> Alex, Andreas,
> 
> On Fri, Jun 28, 2013 at 08:42:05PM +0200, Andreas Hartmann wrote:
> > You're right, there is exactly one entry directly after loading of vfio.
> > I can see this message, too, with linux 3.4.43.
> 
> Can you please test this patch? It should reduce the noise
> significantly, but a few of those error messages are still expected.

Seems to work for me.  I generated a few errors, but each one seems
unique and is more like what I would expect if the PXE ROM left the NIC
running:

[    2.574155] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x001b address=0x00000000000946b0 flags=0x0020]                                        
[    2.574157] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x001b address=0x000000000008f8d0 flags=0x0020]                                        
[    4.992074] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x001b address=0x000000000008f880 flags=0x0000] 

I booted the system four times and twice got just three log messages,
like above, and twice got no faults.  Thanks,

Alex

> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index e3c2d74..74e1d1c 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -1431,6 +1431,7 @@ static void init_device_table_dma(void)
>  	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
>  		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
>  		set_dev_entry_bit(devid, DEV_ENTRY_TRANSLATION);
> +		set_dev_entry_bit(devid, DEV_ENTRY_ONE_FAULT);
>  	}
>  }
>  
> diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
> index 083f98c..4872b68 100644
> --- a/drivers/iommu/amd_iommu_types.h
> +++ b/drivers/iommu/amd_iommu_types.h
> @@ -173,6 +173,7 @@
>  #define DEV_ENTRY_TRANSLATION   0x01
>  #define DEV_ENTRY_IR            0x3d
>  #define DEV_ENTRY_IW            0x3e
> +#define DEV_ENTRY_ONE_FAULT	0x61
>  #define DEV_ENTRY_NO_PAGE_FAULT	0x62
>  #define DEV_ENTRY_EX            0x67
>  #define DEV_ENTRY_SYSMGT1       0x68
> 



