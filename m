Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaAFHjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:39:18 -0500
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:16073
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbaAFHjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:39:16 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [PATCHv8 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv8 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHPB6ipMx0gIe2NTUmSOapMVXIH7JpxR9QAgAD6zUCAALL0gIAEXqEw
Date: Mon, 6 Jan 2014 07:39:13 +0000
Message-ID: <4966a79fc25647708b90d83295ffa1d8@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388656624-26570-1-git-send-email-Li.Xiubo@freescale.com>
 <3716216.GQHQhxMFvx@wuerfel>
 <bb5e14370ddb4ce2921140d147244097@BY2PR03MB505.namprd03.prod.outlook.com>
 <201401031350.59447.arnd@arndb.de>
In-Reply-To: <201401031350.59447.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0083A7F08A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(199002)(189002)(51704005)(87936001)(56776001)(81542001)(76482001)(80976001)(2656002)(74662001)(31966008)(80022001)(65816001)(79102001)(63696002)(77982001)(59766001)(66066001)(50986001)(47976001)(4396001)(74316001)(81686001)(46102001)(51856001)(54356001)(53806001)(74706001)(87266001)(33646001)(47446002)(74502001)(81816001)(49866001)(47736001)(74876001)(81342001)(76576001)(85306002)(90146001)(85852003)(83072002)(54316002)(83322001)(56816005)(69226001)(76786001)(76796001)(74366001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB221;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> 
> Adding Greg here to make sure we have a common understanding in the future.
> 
> ioread*() was indeed introduced for devices that can be both I/O and memory
> space, and is a bit slowed than readl() on architectures that don't have
> memory mapped I/O space (i.e. x86).
> 
> However, ioread32be is the only architecture-independent big-endian
> accessor function (some architectures have in_be32, but that doesn't
> work on ARM), and as mandated by Linus a couple of years ago when
> we wanted to take some shortcuts on powerpc, ioread32 has to be
> semantically the same as readl when used on pointers returned from
> ioremap() rather than ioport_map, and ioread32be is just the
> byte-swapped version of it.
> 
> We have a couple of drivers using ioread* because of the need for
> big-endian data access, and I would continue recommending that unless
> I hear a good argument against it.
> 
> > The big-endian supports is added at v7~v8 patch series.
> 
> Yes, that version looks fine and it avoids the above problem nicely,
> but I'd still like to make sure we come to a conclusion on the problem
> of big-endian I/O accessors.
> 
> 

How about the following ?
-----
+static inline u32 ftm_readl(struct fsl_pwm_chip *fpc, unsigned long reg)
+{
+       if (fpc->big_endian)
+               return ioread32be(fpc->base + reg);
+       else
+               return ioread32(fpc->base + reg);
+}
+
+static inline void ftm_writel(struct fsl_pwm_chip *fpc, u32 val,
+                             unsigned long reg)
+{
+       if (fpc->big_endian)
+               iowrite32be(val, fpc->base + reg);
+       else
+               iowrite32(val, fpc->base + reg);
+}
------

I'll send another version soon.
Does this patch series has other problems needed to fix or revise ?

Thanks,

Best Regards,
Xiubo
