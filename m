Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3LRJoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:44:19 -0500
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:13704
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751196Ab3LRJoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:44:14 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "matt.porter@linaro.org" <matt.porter@linaro.org>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        "Jingchang Lu" <jingchang.lu@freescale.com>
Subject: RE: [PATCHv7 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv7 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHO9+jJR3cCMdLvdk6na6s0NQ/M9ZpYQVYAgAALhQCAAAJlAIAADI4AgAACpoCAAALLgIABQcxA
Date: Wed, 18 Dec 2013 09:43:51 +0000
Message-ID: <2e498771546543f18329d2c2e69a6e35@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com>
 <5295539.cCkPY1PpyC@flatron> <20131217124505.GB17210@ulmo.nvidia.com>
 <1500339.E8bGm7xZUi@flatron> <20131217130435.GV4360@n2100.arm.linux.org.uk>
In-Reply-To: <20131217130435.GV4360@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(189002)(199002)(24454002)(51704005)(76786001)(85852003)(87266001)(76796001)(33646001)(83072002)(63696002)(76576001)(85306002)(53806001)(90146001)(31966008)(51856001)(54356001)(76482001)(56816005)(65816001)(80022001)(46102001)(47446002)(74662001)(83322001)(74502001)(66066001)(81816001)(77982001)(59766001)(74316001)(81686001)(74366001)(69226001)(56776001)(54316002)(79102001)(87936001)(2656002)(74876001)(74706001)(80976001)(47736001)(49866001)(81342001)(4396001)(81542001)(47976001)(50986001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, Dec 17, 2013 at 01:54:35PM +0100, Tomasz Figa wrote:
> > On Tuesday 17 of December 2013 13:45:06 Thierry Reding wrote:
> > > I fail to see how that would eliminate the problem with the types.
> > > That said I don't actually see sparse complaining about any type
> mismatches.
> > > That's probably because the various macros implicitly cast to u32.
> >
> > Well, in BE variant you would read the register using __raw_readl()
> > into a __be32 and then get an u32 from be32_to_cpu() and return it.
> > Similarly for writes
> 
> __raw_readl() returns a u32, so you'll get a warning trying to assign a
> u32 to a __be32.
> 

If all are ok about this method.
How about the following:

+static inline u32 fsl_pwm_readl(struct fsl_pwm_chip *fpc,
+                               const void __iomem *addr)
+{
+       u32 val;
+
+       val = __raw_readl(addr);
+
+       if (likely(fpc->big_endian))
+               val = be32_to_cpu((__force __be32)val);
+       else
+               val = le32_to_cpu((__force __le32)val);
+       rmb();
+
+       return val;
+}
+
+static inline void fsl_pwm_writel(struct fsl_pwm_chip *fpc,
+                               u32 val, void __iomem *addr)
+{
+       wmb();
+       if (likely(fpc->big_endian))
+               val = (__force u32)cpu_to_be32(val);
+       else
+               val = (__force u32)cpu_to_le32(val);
+
+       __raw_writel(val, addr);
+}

Best Regards,
Xiubo
