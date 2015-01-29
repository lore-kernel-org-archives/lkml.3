Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbbA2MaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:30:06 -0500
Received: from oxalide-out.extra.cea.fr ([132.168.224.8]:50947 "EHLO
	oxalide-out.extra.cea.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbbA2MaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:30:03 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 07:30:03 EST
From: =?iso-8859-1?Q?GAUGUEY_R=E9my_228890?= <remy.gauguey@cea.fr>
To: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC: "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>
Subject: [PATCH v3 4/6] vfio: type1: replace domain wide protection flags
 with supported capabilities
Thread-Topic: [PATCH v3 4/6] vfio: type1: replace domain wide protection
 flags with supported capabilities
Thread-Index: AdA7u2Yu2hnLYbfHS7Oj2ElKaaRyHg==
Date: Thu, 29 Jan 2015 12:24:14 +0000
Message-ID: <022C7612790E20489F80A6F0D54B849F3B2C11AD@EXDAG0-B1.intra.cea.fr>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [132.166.88.104]
x-tm-as-product-ver: SMEX-10.2.0.1135-7.500.1017-20752.007
x-tm-as-result: No--33.737700-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonios, 

On Thu, 27 Nov 2014 18:22:53 Antonios Motakis wrote:
>VFIO_IOMMU_TYPE1 keeps track for each domain it knows a list of protection
>flags it always applies to all mappings in the domain. This is used for
>domains that support IOMMU_CAP_CACHE_COHERENCY.
>
>Refactor this slightly, by keeping track instead that a given domain
>supports the capability, and applying the IOMMU_CACHE protection flag when
>doing the actual DMA mappings.
>
>This will allow us to reuse the behavior for IOMMU_CAP_NOEXEC, which we
>also want to keep track of, but without applying it to all domains that
>support it unless the user explicitly requests it.
>
>Signed-off-by: Antonios Motakis <a.motakis@xxxxxxxxxxxxxxxxxxxxxx>
>---
> drivers/vfio/vfio_iommu_type1.c | 25 +++++++++++++++++--------
> 1 file changed, 17 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>index 4a9d666..c54dab8 100644
>--- a/drivers/vfio/vfio_iommu_type1.c
>+++ b/drivers/vfio/vfio_iommu_type1.c
> 			if (ret)
> 				return ret;
> 
>@@ -731,7 +740,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> 	}
> 
> 	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
>-		domain->prot |= IOMMU_CACHE;
>+		domain->caps |= IOMMU_CAP_CACHE_COHERENCY;

IMHO this is not good since IOMMU_CAP_CACHE_COHERENCY is not a bitfield but an enum 
See include/linux/iommu.h 
enum iommu_cap {
	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU can enforce cache coherent DMA
					   transactions */
	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
};
One possible fix would to redefine the enum with values with bitfiled values
enum iommu_cap {
	IOMMU_CAP_CACHE_COHERENCY = 1, /* IOMMU can enforce cache coherent DMA
					   transactions */
	IOMMU_CAP_INTR_REMAP = 2,	/* IOMMU supports interrupt isolation */
	IOMMU_CAP_NOEXEC = 4,		/* IOMMU_NOEXEC flag */
};

Regards
Rémy

>_______________________________________________
>kvmarm mailing list
>kvmarm@xxxxxxxxxxxxxxxxxxxxx
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

