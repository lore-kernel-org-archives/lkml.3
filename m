Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaAIH6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:58:08 -0500
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:50686
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751066AbaAIH6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:58:05 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Bill Pringlemeir <bpringlemeir@nbsps.com>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv8 RFC] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv8 RFC] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHPCEvHgiIG4cfLhk+jSAVclg4YcZp7EPYZgAD9F4A=
Date: Thu, 9 Jan 2014 07:57:44 +0000
Message-ID: <ced2022399cf4ceb9833c269842b04e2@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388726661-3391-1-git-send-email-Li.Xiubo@freescale.com>
 <87lhyqa0rn.fsf@nbsps.com>
In-Reply-To: <87lhyqa0rn.fsf@nbsps.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51444003)(164054003)(51704005)(199002)(189002)(74366001)(46102001)(51856001)(2656002)(87936001)(65816001)(80022001)(66066001)(33646001)(85306002)(77982001)(59766001)(47976001)(50986001)(4396001)(47736001)(54316002)(49866001)(79102001)(53806001)(54356001)(87266001)(56776001)(63696002)(76482001)(74316001)(31966008)(74662001)(69226001)(76796001)(81342001)(81686001)(74502001)(47446002)(85852003)(80976001)(83072002)(83322001)(74706001)(74876001)(76576001)(76786001)(81542001)(81816001)(92566001)(56816005)(90146001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB474;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +static unsigned long fsl_pwm_calculate_period_cycles(struct fsl_pwm_chip
> *fpc,
> > +						     unsigned long period_ns,
> > +						     enum fsl_pwm_clk index)
> > +{
> > +	bool bg = fpc->big_endian;
> > +	int ret;
> > +
> > +	fpc->counter_clk_select = FTM_SC_CLK(bg, index);
> 
> Yes, this is the spirit of what I was suggesting.  The code is much less
> efficient/bigger on the Vybrid with this run-time detection; but this is
> more efficient/smaller than previous versions.  I think that 'bg' can be
> a compiler '#define' base on the configured SOC-systems.  Ie, if the
> kernel config only has 'Vybrid' or only 'LayerScape', then 'bg' can be a
> hard coded value.  The compiler will produce much better code in these
> cases.
> 
> Also, maybe 'distro' people may want to make a 'hand-held' (Debian) or a
> 'router' (OpenWRT) distribution and they would only pick either 'Vybrid'
> or 'LayerScape'.  However, if someone wants an 'every ARM under the
> sun', then the code still works.  So, I think that the code is better
> setup for a subsequent patch set like this (or at least just a good).
> 
> Especially, the stuff on the I/O swapping in the 'readl()' and
> 'writel()' is no longer needed; I think you can use the same function
> for both SOCs.
> 
> > +#define __FTM_SWAP32(v) ((u32)(\
> > +	(((u32)(v) & (u32)0x000000ffUL) << 24) |\
> > +	(((u32)(v) & (u32)0x0000ff00UL) <<  8) |\
> > +	(((u32)(v) & (u32)0x00ff0000UL) >>  8) |\
> > +	(((u32)(v) & (u32)0xff000000UL) >> 24)))
> > +#define FTM_SWAP32(b, v)	(b ? __FTM_SWAP32(v) : v)
> 
> I think that there are macros that you could use here.  For instance,
> '#include <linux/swab.h>' (powerpc and arm) has some assembler macros
> that are quite fast for swapping.  If the kernel config has ARCH >= 6
> for ARM, then the very fast 'rev' instruction is used.  If not, then a
> generic version is used as you have coded.  The PowerPC (another
> possible future ARCH for QorIQ/Layerscape SOC?) always has inline
> assembler macros.
> 
> So,
> 
> + #include <linux/swab.h>
> ...
> + #define FTM_SWAP32(b, v)	(b ? __swab32(v) : v)
> 
> might be better.
> 

Yes.

I have removed the big-endian support temporarily, and will send followed
patches about this.

 
Thanks,

--
Best Regards,
Xiubo

