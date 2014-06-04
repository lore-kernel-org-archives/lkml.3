Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaFDQmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:42:11 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:43817
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751362AbaFDQmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:42:10 -0400
Message-ID: <1401900111.6603.325.camel@snotra.buserror.net>
Subject: Re: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
 reporting driver
From: Scott Wood <scottwood@freescale.com>
To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 4 Jun 2014 11:41:51 -0500
In-Reply-To: <967d9a5e0f7e4d0a8f5e7ec6b8e88ff2@BLUPR03MB566.namprd03.prod.outlook.com>
References: <20140530222743.GA6918@home.buserror.net>
	 <967d9a5e0f7e4d0a8f5e7ec6b8e88ff2@BLUPR03MB566.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:197f:d7f3:edc1:8890]
X-ClientProxiedBy: BN1PR08CA001.namprd08.prod.outlook.com (10.255.197.31) To
 BL2PR03MB385.namprd03.prod.outlook.com (10.141.91.139)
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0232B30BBC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(428001)(52604005)(51704005)(24454002)(189002)(199002)(377424004)(89996001)(101416001)(81542001)(102836001)(46102001)(87976001)(21056001)(85852003)(50986999)(83322001)(81342001)(42186004)(87286001)(104166001)(76482001)(76176999)(77982001)(83072002)(62966002)(74662001)(80022001)(33646001)(50466002)(86362001)(575784001)(92726001)(23676002)(103116003)(31966008)(74502001)(77156001)(4396001)(79102001)(50226001)(20776003)(47776003)(99396002)(64706001)(92566001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB385;H:[IPv6:2601:2:5800:3f7:197f:d7f3:edc1:8890];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 03:17 -0500, Bhushan Bharat-R65777 wrote:
> > +struct ccf_err_regs {
> > +	u32 errdet;		/* 0x00 Error Detect Register */
> > +	/* 0x04 Error Enable (ccf1)/Disable (ccf2) Register */
> > +	u32 errdis;
> > +	/* 0x08 Error Interrupt Enable Register (ccf2 only) */
> > +	u32 errinten;
> > +	u32 cecar;		/* 0x0c Error Capture Attribute Register */
> > +	u32 cecadrh;		/* 0x10 Error Capture Address High */
> 
> s/cecadrh/cecaddrh/g
> This way we will be consistent with Reference manual.

It's "cecadrh" in ccf1 and "cecaddrh" in ccf2.  I suppose I should use
the latter since "errdet/errdis/errinten" are the ccf2 names.

> > +	u32 cecadrl;		/* 0x14 Error Capture Address Low */
> 
> s/cecadrl/cecaddrl/g
> 
> > +	u32 cecar2;		/* 0x18 Error Capture Attribute Register 2 */
> > +};
> > +
> > +/* LAE/CV also valid for errdis and errinten */
> > +#define ERRDET_LAE		(1 << 0)  /* Local Access Error */
> > +#define ERRDET_CV		(1 << 1)  /* Coherency Violation */
> > +#define ERRDET_CTYPE_SHIFT	26	  /* Capture Type (ccf2 only) */
> > +#define ERRDET_CTYPE_MASK	(0x3f << ERRDET_CTYPE_SHIFT)
> 
> Should not this be (0x1f << ERRDET_CTYPE_SHIFT)

Yes, thanks for catching that.

> > +#define ERRDET_CAP		(1 << 31) /* Capture Valid (ccf2 only) */
> > +
> > +#define CECAR_VAL		(1 << 0)  /* Valid (ccf1 only) */
> > +#define CECAR_UVT		(1 << 15) /* Unavailable target ID (ccf1) */
> > +#define CECAR_SRCID_SHIFT_CCF1	24
> > +#define CECAR_SRCID_MASK_CCF1	(0xff << CECAR_SRCID_SHIFT_CCF1)
> > +#define CECAR_SRCID_SHIFT_CCF2	18
> > +#define CECAR_SRCID_MASK_CCF2	(0xff << CECAR_SRCID_SHIFT_CCF2)
> > +
> > +#define CECADRH_ADDRH		0xf
> 
> On ccf2 this id 0xff.

OK.  I think we can get away with using 0xff on both.

> > +static int ccf_remove(struct platform_device *pdev) {
> > +	struct ccf_private *ccf = dev_get_drvdata(&pdev->dev);
> > +
> > +	switch (ccf->info->version) {
> > +	case CCF1:
> > +		iowrite32be(0, &ccf->err_regs->errdis);
> > +		break;
> > +
> > +	case CCF2:
> > +		iowrite32be(0, &ccf->err_regs->errinten);
> 
> Do you think it is same to disable detection bits in ccf->err_regs->errdis?

Disabling the interrupt is what we're aiming for here, but ccf1 doesn't
provide a way to do that separate from disabling detection.

-Scott


