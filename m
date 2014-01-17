Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaAQUVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:21:41 -0500
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:13891
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752805AbaAQUVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:21:38 -0500
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH] Remove bus dependency for iommu_domain_alloc.
Thread-Topic: [RFC][PATCH] Remove bus dependency for iommu_domain_alloc.
Thread-Index: AQHPE7zKZypyIvcqCESSXSKJFW1XG5qJWIIAgAAB79A=
Date: Fri, 17 Jan 2014 20:21:16 +0000
Message-ID: <546cedebe8cb4a6d818d9a6c3ef941bf@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1389987042-27352-1-git-send-email-Varun.Sethi@freescale.com>
 <1389989354.8705.89.camel@bling.home>
In-Reply-To: <1389989354.8705.89.camel@bling.home>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(779001)(679001)(689001)(377424004)(13464003)(51704005)(24454002)(199002)(189002)(164054003)(377454003)(31966008)(83072002)(87936001)(85306002)(47446002)(81686001)(81342001)(87266001)(76576001)(74662001)(74876001)(85852003)(81542001)(4396001)(93516002)(86362001)(74706001)(74502001)(74366001)(80022001)(90146001)(56816005)(69226001)(2656002)(66066001)(65816001)(47976001)(63696002)(19580395003)(19580405001)(80976001)(50986001)(76796001)(83322001)(47736001)(51856001)(46102001)(79102001)(53806001)(54356001)(49866001)(54316002)(77982001)(56776001)(59766001)(76482001)(76786001)(81816001)(93136001)(92566001)(74316001)(33646001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB468.namprd03.prod.outlook.com;CLIP:192.88.169.1;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0HKLkTH027511



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Saturday, January 18, 2014 1:39 AM
> To: Sethi Varun-B16395
> Cc: joro@8bytes.org; iommu@lists.linux-foundation.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC][PATCH] Remove bus dependency for iommu_domain_alloc.
> 
> On Sat, 2014-01-18 at 01:00 +0530, Varun Sethi wrote:
> > This patch attempts to remove iommu_domain_alloc function's dependency
> on the bus type.
> > This dependency is quiet restrictive in case of vfio, where it's
> > possible to bind multiple iommu groups (from different bus types) to
> the same iommu domain.
> >
> > This patch is based on the assumption, that there is a single iommu
> > for all bus types on the system.
> >
> > We maintain a list of bus types (for which iommu ops are registered).
> > In the iommu_domain_alloc function we ensure that all bus types
> correspond to the same set of iommu operations.
> 
> Seems like this just kicks the problem down the road a little ways as I
> expect the assumption isn't going to last long.  I think there's another
> way to do this and we can do it entirely from within vfio_iommu_type1.
> We have a problem on x86 that the IOMMU driver can be backed by multiple
> IOMMU hardware devices.  These separate devices are architecturally
> allowed to have different properties.  The property causing us trouble is
> cache coherency.  Some hardware devices allow us to use IOMMU_CACHE as a
> mapping attribute, others do not.  Therefore we cannot use a single IOMMU
> domain to optimally handle all devices in a heterogeneous environment.
> 
> I think the solution to this is to have vfio_iommu_type1 transparently
> support multiple IOMMU domains.  In the implementation of that, it seems
> to make sense to move the iommu_domain_alloc() to the point where we
> attach a group to the domain.  That means we can scan the devices in the
[Sethi Varun-B16395] Multiple iommu groups can also share the same domain (as a part
Of the same VFIO container). I am not sure how can we handle the case of iommu groups from
Different bus types in vfio.

-Varun

> domain to determine the bus.  I suppose there is still an assumption that
> all the devices in a group are on the same bus, but since the group is
> determined by the IOMMU and we already assume only a single IOMMU per
> bus, I think we're ok.  I spent some time working on a patch to do this,
> but it isn't quite finished.  I'll try to bandage the rough edges and
> send it out as an RFC so you can see what I'm talking about.  Thanks,
> 
> Alex
> 
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> >  arch/arm/mm/dma-mapping.c             |    2 +-
> >  drivers/gpu/drm/msm/msm_gpu.c         |    2 +-
> >  drivers/iommu/amd_iommu_v2.c          |    2 +-
> >  drivers/iommu/iommu.c                 |   32
> +++++++++++++++++++++++++++++---
> >  drivers/media/platform/omap3isp/isp.c |    2 +-
> >  drivers/remoteproc/remoteproc_core.c  |    2 +-
> >  drivers/vfio/vfio_iommu_type1.c       |    2 +-
> >  include/linux/device.h                |    2 ++
> >  include/linux/iommu.h                 |    4 ++--
> >  virt/kvm/iommu.c                      |    2 +-
> >  10 files changed, 40 insertions(+), 12 deletions(-)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
