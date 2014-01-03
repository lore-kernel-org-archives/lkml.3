Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaACJTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:19:33 -0500
Received: from mail-bn1lp0149.outbound.protection.outlook.com ([207.46.163.149]:20001
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaACJT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:19:26 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv8 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv8 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHPB6ipMx0gIe2NTUmSOapMVXIH7JpxR9QAgAD6zUA=
Date: Fri, 3 Jan 2014 09:19:22 +0000
Message-ID: <bb5e14370ddb4ce2921140d147244097@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388656624-26570-1-git-send-email-Li.Xiubo@freescale.com>
 <1388656624-26570-2-git-send-email-Li.Xiubo@freescale.com>
 <3716216.GQHQhxMFvx@wuerfel>
In-Reply-To: <3716216.GQHQhxMFvx@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(199002)(189002)(24454002)(51704005)(65816001)(56816005)(33646001)(74316001)(31966008)(46102001)(51856001)(66066001)(83072002)(74706001)(2656002)(90146001)(69226001)(47446002)(80022001)(53806001)(54356001)(74662001)(74502001)(76482001)(63696002)(81542001)(87936001)(76786001)(87266001)(76576001)(81686001)(81816001)(74876001)(77982001)(83322001)(56776001)(74366001)(81342001)(80976001)(85306002)(4396001)(76796001)(54316002)(50986001)(79102001)(85852003)(47976001)(59766001)(49866001)(47736001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB221;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,


> Subject: Re: [PATCHv8 1/4] pwm: Add Freescale FTM PWM driver support
> 
> On Thursday 02 January 2014 17:57:01 Xiubo Li wrote:
> > +static inline u32 ftm_readl(bool big_endian, const void __iomem *addr)
> > +{
> > +       u32 val;
> > +
> > +       val = __raw_readl(addr);
> > +
> > +       if (likely(big_endian))
> > +               val = be32_to_cpu((__force __be32)val);
> > +       else
> > +               val = le32_to_cpu((__force __le32)val);
> > +       rmb();
> > +
> > +       return val;
> > +}
> > +
> > +static inline void ftm_writel(bool big_endian, u32 val, void __iomem *addr)
> > +{
> > +       wmb();
> > +       if (likely(big_endian))
> > +               val = (__force u32)cpu_to_be32(val);
> > +       else
> > +               val = (__force u32)cpu_to_le32(val);
> > +
> > +       __raw_writel(val, addr);
> 
> These functions definitely need some comments regarding why this is necessary.
> I assume that after 8 rounds of review (that I did not read) this has been
> discussed already, so please explain above the functions why you don't just
> use ioread32be/ioread32 and iowrite32be/iowrite32 here.
>

As Thierry has commonts in some days before:
----
A few years ago GregKH commented in response to a patch that ioread*()
weren't supposed to be used for memory-mapped only devices. The original
purpose apparently was to allow drivers to work with both I/O and
memory-mapped devices.
----
I'm not very sure.

The big-endian supports is added at v7~v8 patch series.


> Also all callers seem to be of the style
> 
>        val = ftm_readl(fpc->big_endian, fpc->base + FTM_SC);
> 
> so I wonder why you don't just pass the fpc pointer to the function
> and make it
> 
> static inline void ftm_readl(struct fsl_pwm_chip *fpc, unsigned long reg, u32
> val)
> {
> 	if (fpc->big_endian)
> 		iowrite32be(val, fpc->base + reg);
> 	else
> 		iowrite32(val, fpc->base + reg);
> }
> 

Yes, it was.

I thought this will make the ftm_readl/ftm_writel look more brief like other drivers.

 
Thanks very much.

--
Best Regards,
Xiubo

