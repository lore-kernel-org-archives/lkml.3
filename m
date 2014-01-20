Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaATSbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:31:06 -0500
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:17300
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750993AbaATSbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:31:04 -0500
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
Thread-Topic: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
Thread-Index: AQHPE8PT6BnndueXIU+jZO3SkYX87JqNrb0QgAAiEACAAA83UA==
Date: Mon, 20 Jan 2014 18:30:42 +0000
Message-ID: <f4597c60b5a04e8e8baa225a279abd0d@BL2PR03MB468.namprd03.prod.outlook.com>
References: <20140117203126.11429.25235.stgit@gimli.home>
	 <4bc6dcb96df44b0e94152d9729958d60@BL2PR03MB468.namprd03.prod.outlook.com>
 <1390234886.8705.142.camel@bling.home>
In-Reply-To: <1390234886.8705.142.camel@bling.home>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(13464003)(51704005)(377424004)(199002)(377454003)(189002)(24454002)(164054003)(54316002)(49866001)(93136001)(77982001)(19580405001)(50986001)(92566001)(80976001)(51856001)(47736001)(46102001)(79102001)(54356001)(63696002)(53806001)(76796001)(83322001)(56776001)(74316001)(81816001)(33646001)(76482001)(59766001)(47976001)(76786001)(87266001)(76576001)(74876001)(74662001)(31966008)(87936001)(83072002)(81342001)(81686001)(47446002)(85306002)(56816005)(69226001)(19580395003)(90146001)(65816001)(66066001)(2656002)(74706001)(85852003)(4396001)(81542001)(86362001)(93516002)(74366001)(80022001)(74502001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB468.namprd03.prod.outlook.com;CLIP:192.88.169.1;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0KIVCEF005536



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Monday, January 20, 2014 9:51 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
> 
> On Mon, 2014-01-20 at 14:45 +0000, Varun Sethi wrote:
> >
> > > -----Original Message-----
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Saturday, January 18, 2014 2:06 AM
> > > To: Sethi Varun-B16395
> > > Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> > > Subject: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
> > >
> > > RFC: This is not complete but I want to share with Varun the
> > > dirrection I'm thinking about.  In particular, I'm really not sure
> > > if we want to introduce a "v2" interface version with slightly
> > > different unmap semantics.  QEMU doesn't care about the difference,
> > > but other users might.  Be warned, I'm not even sure if this code
> works at the moment.
> > > Thanks,
> > >
> > > Alex
> > >
> > >
> > > We currently have a problem that we cannot support advanced features
> > > of an IOMMU domain (ex. IOMMU_CACHE), because we have no guarantee
> > > that those features will be supported by all of the hardware units
> > > involved with the domain over its lifetime.  For instance, the Intel
> > > VT-d architecture does not require that all DRHDs support snoop
> > > control.  If we create a domain based on a device behind a DRHD that
> > > does support snoop control and enable SNP support via the
> > > IOMMU_CACHE mapping option, we cannot then add a device behind a
> > > DRHD which does not support snoop control or we'll get reserved bit
> > > faults from the SNP bit in the pagetables.  To add to the
> > > complexity, we can't know the properties of a domain until a device
> is attached.
> > [Sethi Varun-B16395] Effectively, it's the same iommu and iommu_ops
> > are common across all bus types. The hardware feature differences are
> > abstracted by the driver.
> 
> That's a simplifying assumption that is not made anywhere else in the
> code.  The IOMMU API allows entirely independent IOMMU drivers to
> register per bus_type.  There is no guarantee that all devices are backed
> by the same IOMMU hardware unit or make use of the same iommu_ops.
> 
[Sethi Varun-B16395] ok

> > > We could pass this problem off to userspace and require that a
> > > separate vfio container be used, but we don't know how to handle
> > > page accounting in that case.  How do we know that a page pinned in
> > > one container is the same page as a different container and avoid
> > > double billing the user for the page.
> > >
> > > The solution is therefore to support multiple IOMMU domains per
> > > container.  In the majority of cases, only one domain will be
> > > required since hardware is typically consistent within a system.
> > > However, this provides us the ability to validate compatibility of
> > > domains and support mixed environments where page table flags can be
> > > different between domains.
> > >
> > > To do this, our DMA tracking needs to change.  We currently try to
> > > coalesce user mappings into as few tracking entries as possible.
> > > The problem then becomes that we lose granularity of user mappings.
> > > We've never guaranteed that a user is able to unmap at a finer
> > > granularity than the original mapping, but we must honor the
> > > granularity of the original mapping.  This coalescing code is
> > > therefore removed, allowing only unmaps covering complete maps.  The
> > > change in accounting is fairly small here, a typical QEMU VM will
> > > start out with roughly a dozen entries, so it's arguable if this
> coalescing was ever needed.
> > >
> > > We also move IOMMU domain creation to the point where a group is
> > > attached to the container.  An interesting side-effect of this is
> > > that we now have access to the device at the time of domain creation
> > > and can probe the devices within the group to determine the bus_type.
> > > This finally makes vfio_iommu_type1 completely device/bus agnostic.
> > > In fact, each IOMMU domain can host devices on different buses
> > > managed by different physical IOMMUs, and present a single DMA
> > > mapping interface to the user.  When a new domain is created,
> > > mappings are replayed to bring the IOMMU pagetables up to the state
> > > of the current container.  And of course, DMA mapping and unmapping
> > > automatically traverse all of the configured IOMMU domains.
> > >
> > [Sethi Varun-B16395] This code still checks to see that devices being
> > attached to the domain are connected to the same bus type. If we
> > intend to merge devices from different bus types but attached to
> > compatible domains in to a single domain, why can't we avoid the bus
> > check? Why can't we remove the bus dependency from domain allocation?
> 
> So if I were to test iommu_ops instead of bus_type (ie. assume that if a
> if an IOMMU driver manages iommu_ops across bus_types that it can accept
> the devices), would that satisfy your concern?
[Sethi Varun-B16395] I think so. Checking for iommu_ops should allow iommu groups from different bus_types, to share a domain.

> 
> It may be possible to remove the bus_type dependency from domain
> allocation, but the IOMMU API currently makes the assumption that there's
> one IOMMU driver per bus_type.
[Sethi Varun-B16395] Is that a valid assumption?

> Your fix to remove the bus_type
> dependency from iommu_domain_alloc() adds an assumption that there is
> only one IOMMU driver for all bus_types.  That may work on your platform,
> but I don't think it's a valid assumption in the general case.
[Sethi Varun-B16395] ok

> If you'd like to propose alternative ways to remove the bus_type
> dependency, please do.  Thanks,
>
[Sethi Varun-B16395] My main concern, was to allow devices from different bus types, to share the iommu domain. I am fine if this can be handled from within vfio.

-Varun
 


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
