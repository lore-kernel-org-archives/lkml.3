Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbaAUQqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:46:46 -0500
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:27964
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754466AbaAUQqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:46:44 -0500
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
Thread-Topic: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
Thread-Index: AQHPE8PTIncnrSWF6UCKArN35cmjQpqOykAQgABpmwCAADNxYA==
Date: Tue, 21 Jan 2014 16:46:22 +0000
Message-ID: <6435bb49d4714b24baaf707e76559a55@BN1PR03MB266.namprd03.prod.outlook.com>
References: <20140117203126.11429.25235.stgit@gimli.home>
	 <4b9118cb4cc744bdb2e9c25fa32d6950@BL2PR03MB259.namprd03.prod.outlook.com>
 <1390311348.8705.265.camel@bling.home>
In-Reply-To: <1390311348.8705.265.camel@bling.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0098BA6C6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(377424004)(189002)(199002)(13464003)(24454002)(377454003)(164054003)(51704005)(83322001)(86362001)(19580405001)(33646001)(50986001)(51856001)(66066001)(74876001)(74706001)(47976001)(4396001)(47736001)(49866001)(85852003)(83072002)(65816001)(46102001)(54356001)(80022001)(19580395003)(53806001)(81686001)(74316001)(92566001)(93136001)(93516002)(90146001)(74366001)(80976001)(2656002)(76482001)(56816005)(87936001)(74662001)(74502001)(85306002)(47446002)(81342001)(77096001)(81542001)(81816001)(79102001)(63696002)(87266001)(31966008)(76576001)(54316002)(77982001)(59766001)(56776001)(76796001)(76786001)(69226001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB473;H:BN1PR03MB266.namprd03.prod.outlook.com;CLIP:192.88.169.1;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0LGkn89011306



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Tuesday, January 21, 2014 7:06 PM
> To: Bhushan Bharat-R65777
> Cc: Sethi Varun-B16395; iommu@lists.linux-foundation.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
> 
> On Tue, 2014-01-21 at 07:27 +0000, Bharat.Bhushan@freescale.com wrote:
> > > +	domain->domain = iommu_domain_alloc(domain->bus);
> > > +	if (!domain->domain) {
> > > +		ret = -EIO;
> > > +		goto out_free;
> > > +	}
> > > +
> > > +	ret = iommu_attach_group(domain->domain, iommu_group);
> > > +	if (ret)
> > > +		goto out_domain;
> > > +
> > > +	INIT_LIST_HEAD(&domain->group_list);
> > > +	list_add(&group->next, &domain->group_list);
> > > +
> > > +	if (!allow_unsafe_interrupts &&
> > > +	    !iommu_domain_has_cap(domain->domain, IOMMU_CAP_INTR_REMAP)) {
> > > +		pr_warn("%s: No interrupt remapping support.  Use the module
> > > +param
> > > \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this
> > > platform\n",
> > > +		       __func__);
> > > +		ret = -EPERM;
> > > +		goto out_detach;
> > > +	}
> > > +
> > > +	if (iommu_domain_has_cap(domain->domain, IOMMU_CAP_CACHE_COHERENCY))
> > > +		domain->prot |= IOMMU_CACHE;
> > > +
> > > +	/* Try to match an existing compatible domain. */
> > > +	list_for_each_entry(d, &iommu->domain_list, next) {
> > > +		if (d->bus == domain->bus && d->prot == domain->prot) {
> >
> > Are not we talking about allowing a domain to support different bus type if
> domain/iommu-group properties matches.
> 
> This is where I was suggesting to Varun that we could test iommu_ops instead of
> bus_type.
> 
> > > +			iommu_detach_group(domain->domain, iommu_group);
> > > +			if (!iommu_attach_group(d->domain, iommu_group)) {
> > > +				list_add(&group->next, &d->group_list);
> > > +				iommu_domain_free(domain->domain);
> > > +				kfree(domain);
> > > +				mutex_unlock(&iommu->lock);
> > > +				return 0;
> > > +			}
> > > +
> > > +			ret = iommu_attach_group(domain->domain, iommu_group);
> > > +			if (ret)
> > > +				goto out_domain;
> > > +		}
> > > +	}
> > > +
> > > +	/* replay mappings on new domains */
> > > +	ret = vfio_iommu_replay(iommu, domain);
> >
> > IIUC; We created a new domain because an already existing domain does
> > not have same attribute; say domain->prot; But in vfio_iommu_replay() we pick
> up any domain, first domain, and create mapping accordingly.
> > Should not we use attributes of this domain otherwise we may get "reserved bit
> faults"?
> 
> We use an existing domain to get the iova to physical mappings, should those not
> be consistent regardless of the domain we pick?  We're not using any of the low
> level attributes that could cause something like a reserved bit fault.  Thanks,

You are right, we use dma->addr etc from any domain and but uses "prot" from the domain passed to replay function().
So effectively the only difference (from dma mapping perspective) between domains in a container is "prot"

Thanks
-Bharat
> 
> Alex
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
