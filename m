Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbaIDInr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:43:47 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:31401
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754294AbaIDIno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:43:44 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource read
 API.
Thread-Topic: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource
 read API.
Thread-Index: AQHPwPGfS8nkeT6FCkuUDVIJ9Bh425vvRJOAgAD90OCAAHITAIAAANvg
Date: Thu, 4 Sep 2014 08:43:28 +0000
Message-ID: <69c4ca3ee1324a3894a6d5dc0bde38ed@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
 <1409031951-39021-3-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.10.1409031236450.3333@nanos>
 <c5f60fc57cdf4cd3a01b8d3a87a4f3de@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <alpine.DEB.2.10.1409041032200.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409041032200.3333@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(189002)(199003)(164054003)(77982001)(106356001)(106116001)(66066001)(105586002)(4396001)(92566001)(20776003)(90102001)(46102001)(107046002)(64706001)(95666004)(76482001)(85852003)(74662001)(31966008)(79102001)(110136001)(74502001)(83322001)(101416001)(85306004)(83072002)(93886004)(99286002)(77096002)(2656002)(108616004)(99396002)(54356999)(74316001)(80022001)(33646002)(81542001)(76176999)(21056001)(81342001)(76576001)(87936001)(86362001)(50986999)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB181;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Since the FTM will be in BE mode on LS1 platform, but will be in LE mode
> > On LS2 platform.
> >
> > And ftm_clocksource_read_up() will adapt to this different.
> 
> You are missing the point. Why do you want a conditional in a hot
> path? You know at init time whether the thing is BE or LE, so you can
> have separate functions for BE/LE or whatever and register that with
> clocksource_mmio_init(). i.e.
> 
>      if (be)
>      	clocksource_mmio_init(....., cs_read_be);
>      else if (le)
>      	clocksource_mmio_init(....., cs_read_le);
>      else if (magic)
>      	clocksource_mmio_init(....., cs_read_magic);
> 

There already has the following access interfaces:

static inline u32 ftm_readl(void __iomem *addr)
{
        if (priv->big_endian)
                return ioread32be(addr);
        else
                return ioread32(addr);
}

static inline void ftm_writel(u32 val, void __iomem *addr)
{
        if (priv->big_endian)
                iowrite32be(val, addr);
        else
                iowrite32(val, addr);
}

So I added the following code:

static cycle_t ftm_clocksource_read_up(struct clocksource *c)
{
        return ftm_readl(priv->clksrc_base + FTM_CNT) & 0xffff;
}

clocksource_mmio_init(.....,ftm_clocksource_read_up);

Is this okay ?

Thanks,

BRs
Xiubo


