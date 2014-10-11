Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaJKGWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 02:22:18 -0400
Received: from mail-bl2on0109.outbound.protection.outlook.com ([65.55.169.109]:40035
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751145AbaJKGWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 02:22:17 -0400
From: "qiang.zhao@freescale.com" <qiang.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiaobo Xie <X.Xie@freescale.com>
Subject: RE: [PATCH 2/3] qe: run qe_init and qe_ic_init
Thread-Topic: [PATCH 2/3] qe: run qe_init and qe_ic_init
Thread-Index: AQHP5FZQka7ODfbDu0GEZDmgtxMM6ZwpmFIAgADVorA=
Date: Sat, 11 Oct 2014 06:22:12 +0000
Message-ID: <eb56ebcaf05b41818cfa5e1b199b8d03@BLUPR03MB341.namprd03.prod.outlook.com>
References: <1412923725-9611-1-git-send-email-B45475@freescale.com>
 <1412962492.13320.587.camel@snotra.buserror.net>
In-Reply-To: <1412962492.13320.587.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0753;UriScan:;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(377424004)(51704005)(13464003)(189002)(199003)(24454002)(120916001)(74316001)(99396003)(19580395003)(2656002)(21056001)(4396001)(19580405001)(66066001)(64706001)(85852003)(122556002)(87936001)(86362001)(105586002)(106116001)(97736003)(108616004)(106356001)(101416001)(80022003)(575784001)(46102003)(110136001)(92566001)(76482002)(50986999)(85306004)(107046002)(54356999)(20776003)(76176999)(76576001)(99286002)(95666004)(33646002)(31966008)(40100003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0753;H:BLUPR03MB341.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0642;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9B6MMhZ009347

On Sat, 2014-10-11 at 01:35AM, Wood Scott wrote:
> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Saturday, October 11, 2014 1:35 AM
> To: Zhao Qiang-B45475
> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Wood
> Scott-B07421; Xie Xiaobo-R63061
> Subject: Re: [PATCH 2/3] qe: run qe_init and qe_ic_init
> 
> On Fri, 2014-10-10 at 14:48 +0800, Zhao Qiang wrote:
> > qe and qe_ic need to be initialized before the qe app drivers, using
> > subsys_initcall to run qe_init and qe_ic_init
> >
> > Signed-off-by: Zhao Qiang <B45475@freescale.com>
> > ---
> >  drivers/soc/qe/qe.c    | 15 +++++++++++++++
> >  drivers/soc/qe/qe_ic.c | 15 +++++++++++++++
> >  2 files changed, 30 insertions(+)
> >
> > diff --git a/drivers/soc/qe/qe.c b/drivers/soc/qe/qe.c index
> > 2aaa5b2..bfea0f8 100644
> > --- a/drivers/soc/qe/qe.c
> > +++ b/drivers/soc/qe/qe.c
> > @@ -683,6 +683,21 @@ unsigned int qe_get_num_of_snums(void)  }
> > EXPORT_SYMBOL(qe_get_num_of_snums);
> >
> > +static int __init qe_init(void)
> > +{
> > +	struct device_node *np;
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "fsl,qe");
> > +	if (!np) {
> > +		pr_err("%s: Could not find Quicc Engine node\n", __func__);
> > +		return -ENODEV;
> > +	}
> > +	qe_reset();
> > +	of_node_put(np);
> > +	return 0;
> > +}
> > +subsys_initcall(qe_init);
> 
> It is not an error to enable QE support on hardware that doesn't have QE.
> Please remove the pr_err().
OK, will be modified on V2.
> 
> > +
> >  #if defined(CONFIG_SUSPEND) && defined(CONFIG_PPC_85xx)  static int
> > qe_resume(struct platform_device *ofdev)  { diff --git
> > a/drivers/soc/qe/qe_ic.c b/drivers/soc/qe/qe_ic.c index
> > cc1b8d5..11fe98c 100644
> > --- a/drivers/soc/qe/qe_ic.c
> > +++ b/drivers/soc/qe/qe_ic.c
> > @@ -34,6 +34,7 @@
> >  #include <linux/fsl/qe_ic.h>
> >
> >  #include "qe_ic.h"
> > +#include "../../irqchip/irqchip.h"
> 
> What do you need from here, and can it be moved to include/linux/...?
> 
> The only thing I see defined in irqchip.h is IRQCHIP_DECLARE, and you
> don't use that in this patch...
OK, will be modified on V2.
> 
> -Scott
> 
> >  static DEFINE_RAW_SPINLOCK(qe_ic_lock);
> >
> > @@ -501,4 +502,18 @@ static int __init init_qe_ic_sysfs(void)
> >  	return 0;
> >  }
> >
> > +static int __init qeic_of_init(void)
> > +{
> > +	struct device_node *np;
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "fsl,qe-ic");
> > +	if (np) {
> > +		qe_ic_init(np, 0, qe_ic_cascade_low_mpic,
> > +			   qe_ic_cascade_high_mpic);
> > +		of_node_put(np);
> > +	}
> > +	return 0;
> > +}
> > +subsys_initcall(qeic_of_init);
> > +
> >  subsys_initcall(init_qe_ic_sysfs);
> 


Best Regards
Zhao Qiang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
