Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaGDMuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:50:32 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:58166
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751804AbaGDMub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:50:31 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [PATCH 2/3] iommu/fsl: Fix the device domain attach condition.
Thread-Topic: [PATCH 2/3] iommu/fsl: Fix the device domain attach condition.
Thread-Index: AQHPj/FcSATGvxFAdUS7z9ALjFjLD5uPzMeAgAAf3LA=
Date: Fri, 4 Jul 2014 12:50:28 +0000
Message-ID: <23ace98ce7e145b0909a1f5f5d1fd2dd@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
 <1403618237-26248-3-git-send-email-Varun.Sethi@freescale.com>
 <20140704105430.GE13434@8bytes.org>
In-Reply-To: <20140704105430.GE13434@8bytes.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02622CEF0A
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(189002)(52314003)(199002)(51704005)(24454002)(13464003)(85852003)(92566001)(76576001)(21056001)(64706001)(80022001)(76176999)(66066001)(83322001)(2656002)(46102001)(19580405001)(99396002)(79102001)(85306003)(50986999)(20776003)(86362001)(101416001)(87936001)(106356001)(105586002)(95666004)(33646001)(81542001)(106116001)(4396001)(31966008)(81342001)(74316001)(74502001)(76482001)(83072002)(19580395003)(74662001)(99286002)(54356999)(110136001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB465;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Friday, July 04, 2014 4:25 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> linuxppc-dev@lists.ozlabs.org; alex.williamson@redhat.com
> Subject: Re: [PATCH 2/3] iommu/fsl: Fix the device domain attach
> condition.
> 
> Hmm,
> 
> On Tue, Jun 24, 2014 at 07:27:16PM +0530, Varun Sethi wrote:
> > -	old_domain_info = find_domain(dev);
> > +	old_domain_info = dev->archdata.iommu_domain;
> >  	if (old_domain_info && old_domain_info->domain != dma_domain) {
> >  		spin_unlock_irqrestore(&device_domain_lock, flags);
> >  		detach_device(dev, old_domain_info->domain);
> 
> Wouldn't this set dev->archdata.iommu_domain to NULL anyway, so that ...
> 
Not for the case where device has multiple LIODNs.

> > @@ -399,7 +394,7 @@ static void attach_device(struct fsl_dma_domain
> *dma_domain, int liodn, struct d
> >  	 * the info for the first LIODN as all
> >  	 * LIODNs share the same domain
> >  	 */
> > -	if (!old_domain_info)
> > +	if (!dev->archdata.iommu_domain)
> >  		dev->archdata.iommu_domain = info;
> 
> We already know that it _must_ be NULL here?
> 

That won't be true for devices having multiple LIODNs

> >  	spin_unlock_irqrestore(&device_domain_lock, flags);
> 
> This would shrink down the patch to:
> 
> diff --git a/drivers/iommu/fsl_pamu_domain.c
> b/drivers/iommu/fsl_pamu_domain.c index 93072ba..d21b554 100644
> --- a/drivers/iommu/fsl_pamu_domain.c
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -399,8 +399,7 @@ static void attach_device(struct fsl_dma_domain
> *dma_domain, int liodn, struct d
>  	 * the info for the first LIODN as all
>  	 * LIODNs share the same domain
>  	 */
> -	if (!old_domain_info)
> -		dev->archdata.iommu_domain = info;
> +	dev->archdata.iommu_domain = info;

For devices having multiple LIODNs, we don't want to overwrite the info.

-Varun

