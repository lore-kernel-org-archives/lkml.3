Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbaCNWvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:51:18 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:24917
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755526AbaCNWvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:51:17 -0400
Message-ID: <1394837469.12479.134.camel@snotra.buserror.net>
Subject: Re: [PATCH 7/9] fsl: add EPU FSM configuration for deep sleep
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Fri, 14 Mar 2014 17:51:09 -0500
In-Reply-To: <20140312083410.GF4706@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-7-git-send-email-chenhui.zhao@freescale.com>
	 <1394582923.13761.81.camel@snotra.buserror.net>
	 <20140312083410.GF4706@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR04CA019.namprd04.prod.outlook.com (10.141.154.147)
 To BLUPR03MB389.namprd03.prod.outlook.com (10.141.78.11)
X-Forefront-PRVS: 0150F3F97D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(189002)(199002)(51704005)(377424004)(50466002)(77096001)(74876001)(77156001)(76786001)(87266001)(76796001)(56816005)(74706001)(74366001)(87976001)(97186001)(92566001)(90146001)(81342001)(81542001)(92726001)(50986001)(85306002)(47976001)(83072002)(85852003)(49866001)(47736001)(50226001)(89996001)(19580395003)(62966002)(80976001)(83322001)(19580405001)(95666003)(79102001)(59766001)(88136002)(74662001)(81686001)(74502001)(47446002)(23676002)(31966008)(63696002)(47776003)(20776003)(93516002)(51856001)(81816001)(46102001)(69226001)(93916002)(95416001)(86362001)(33646001)(53806001)(575784001)(42186004)(94316002)(94946001)(65816001)(80022001)(56776001)(76482001)(54316002)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB389;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:BC9FF276.A826966D.4FE7557A.4E4A22D.203E0;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 16:34 +0800, Chenhui Zhao wrote:
> On Tue, Mar 11, 2014 at 07:08:43PM -0500, Scott Wood wrote:
> > On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> > > From: Hongbo Zhang <hongbo.zhang@freescale.com>
> > > 
> > > In the last stage of deep sleep, software will trigger a Finite
> > > State Machine (FSM) to control the hardware precedure, such as
> > > board isolation, killing PLLs, removing power, and so on.
> > > 
> > > When the system is waked up by an interrupt, the FSM controls the
> > > hardware to complete the early resume precedure.
> > > 
> > > This patch configure the EPU FSM preparing for deep sleep.
> > > 
> > > Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> > > Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
> > 
> > Couldn't this be part of qoriq_pm.c?
> 
> Put the code in drivers/platform/fsl/ so that LS1 can share these code.

How can LS1 share it if it's got hardcoded T1040 values?

> > > diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
> > > index 09fde58..6539e6d 100644
> > > --- a/drivers/platform/Kconfig
> > > +++ b/drivers/platform/Kconfig
> > > @@ -6,3 +6,7 @@ source "drivers/platform/goldfish/Kconfig"
> > >  endif
> > >  
> > >  source "drivers/platform/chrome/Kconfig"
> > > +
> > > +if FSL_SOC
> > > +source "drivers/platform/fsl/Kconfig"
> > > +endif
> > 
> > Chrome doesn't need an ifdef -- why does this?
> 
> Don't wish other platform see these options, and the X86 and GOLDFISH have
> ifdefs.

The point is you can implement the dependency inside
drivers/platform/fsl/Kconfig.

> > > diff --git a/drivers/platform/fsl/Makefile b/drivers/platform/fsl/Makefile
> > > new file mode 100644
> > > index 0000000..d99ca0e
> > > --- /dev/null
> > > +++ b/drivers/platform/fsl/Makefile
> > > @@ -0,0 +1,5 @@
> > > +#
> > > +# Makefile for linux/drivers/platform/fsl
> > > +# Freescale Specific Power Management Drivers
> > > +#
> > > +obj-$(CONFIG_FSL_SLEEP_FSM)	+= sleep_fsm.o
> > 
> > Why is this here while the other stuff is in arch/powerpc/sysdev?
> > 
> > > +/* Block offsets */
> > > +#define	RCPM_BLOCK_OFFSET	0x00022000
> > > +#define	EPU_BLOCK_OFFSET	0x00000000
> > > +#define	NPC_BLOCK_OFFSET	0x00001000
> > 
> > Why don't these block offsets come from the device tree?
> 
> Have maped DCSR registers. Don't wish to remap them.

We don't wish to have hardcoded CCSR/DCSR offsets in the kernel source.
Sorry.
 
> > > +	/* Configure the EPU Counters */
> > > +	epu_write(EPCCR15, 0x92840000);
> > > +	epu_write(EPCCR14, 0x92840000);
> > > +	epu_write(EPCCR12, 0x92840000);
> > > +	epu_write(EPCCR11, 0x92840000);
> > > +	epu_write(EPCCR10, 0x92840000);
> > > +	epu_write(EPCCR9, 0x92840000);
> > > +	epu_write(EPCCR8, 0x92840000);
> > > +	epu_write(EPCCR5, 0x92840000);
> > > +	epu_write(EPCCR4, 0x92840000);
> > > +	epu_write(EPCCR2, 0x92840000);
> > > +
> > > +	/* Configure the SCUs Inputs */
> > > +	epu_write(EPSMCR15, 0x76000000);
> > > +	epu_write(EPSMCR14, 0x00000031);
> > > +	epu_write(EPSMCR13, 0x00003100);
> > > +	epu_write(EPSMCR12, 0x7F000000);
> > > +	epu_write(EPSMCR11, 0x31740000);
> > > +	epu_write(EPSMCR10, 0x65000030);
> > > +	epu_write(EPSMCR9, 0x00003000);
> > > +	epu_write(EPSMCR8, 0x64300000);
> > > +	epu_write(EPSMCR7, 0x30000000);
> > > +	epu_write(EPSMCR6, 0x7C000000);
> > > +	epu_write(EPSMCR5, 0x00002E00);
> > > +	epu_write(EPSMCR4, 0x002F0000);
> > > +	epu_write(EPSMCR3, 0x2F000000);
> > > +	epu_write(EPSMCR2, 0x6C700000);
> > 
> > Where do these magic numbers come from?  Which chips are they valid for?
> 
> They are for T1040. Can be found in the RCPM chapter of T1040RM.

Then put in a comment to that effect, including what part of the RCPM
chapter.

How do you plan to handle the addition of another SoC with different
values?

-Scott


