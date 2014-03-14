Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaCNXCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 19:02:10 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:46375
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754470AbaCNXCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 19:02:08 -0400
Message-ID: <1394838105.12479.144.camel@snotra.buserror.net>
Subject: Re: [PATCH 8/9] powerpc/85xx: add save/restore functions for core
 registers
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>,
        Wang Dongsheng-B40534 <B40534@freescale.com>
Date: Fri, 14 Mar 2014 18:01:45 -0500
In-Reply-To: <20140312094237.GG4706@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-8-git-send-email-chenhui.zhao@freescale.com>
	 <1394585114.13761.112.camel@snotra.buserror.net>
	 <20140312094237.GG4706@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR03CA002.namprd03.prod.outlook.com (10.141.52.150) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0150F3F97D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(377424004)(51704005)(199002)(24454002)(76796001)(76786001)(59766001)(93516002)(20776003)(74706001)(56816005)(92726001)(90146001)(83072002)(85852003)(77156001)(77096001)(47776003)(94946001)(87976001)(63696002)(94316002)(79102001)(50986001)(49866001)(95416001)(74876001)(47976001)(50226001)(92566001)(81816001)(575784001)(23676002)(93916002)(50466002)(87266001)(89996001)(83322001)(56776001)(69226001)(54316002)(46102001)(19580395003)(19580405001)(95666003)(85306002)(80976001)(42186004)(97186001)(74662001)(81342001)(51856001)(74502001)(62966002)(88136002)(47736001)(76482001)(86362001)(80022001)(65816001)(81686001)(74366001)(81542001)(47446002)(33646001)(53806001)(31966008)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:D2EEF2F6.93D4D989.24F7515B.9EF50AD3.205DC;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 17:42 +0800, Chenhui Zhao wrote:
> On Tue, Mar 11, 2014 at 07:45:14PM -0500, Scott Wood wrote:
> > On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> > > From: Wang Dongsheng <dongsheng.wang@freescale.com>
> > > 
> > > Add booke_cpu_state_save() and booke_cpu_state_restore() functions which can be
> > > used to save/restore CPU's registers in the case of deep sleep and hibernation.
> > > 
> > > Supported processors: E6500, E5500, E500MC, E500v2 and E500v1.
> > > 
> > > Signed-off-by: Wang Dongsheng <dongsheng.wang@freescale.com>
> > > Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
> > > ---
> > >  arch/powerpc/include/asm/booke_save_regs.h |   96 ++++++++
> > >  arch/powerpc/kernel/Makefile               |    1 +
> > >  arch/powerpc/kernel/booke_save_regs.S      |  361 ++++++++++++++++++++++++++++
> > >  3 files changed, 458 insertions(+), 0 deletions(-)
> > >  create mode 100644 arch/powerpc/include/asm/booke_save_regs.h
> > >  create mode 100644 arch/powerpc/kernel/booke_save_regs.S
> > > 
> > > diff --git a/arch/powerpc/include/asm/booke_save_regs.h b/arch/powerpc/include/asm/booke_save_regs.h
> > > new file mode 100644
> > > index 0000000..87c357a
> > > --- /dev/null
> > > +++ b/arch/powerpc/include/asm/booke_save_regs.h
> > > @@ -0,0 +1,96 @@
> > > +/*
> > > + *  Save/restore e500 series core registers
> > 
> > Filename says booke, comment says e500.
> > 
> > Filename and comment also fail to point out that this is specifically
> > for standby/suspend, not for hibernate which is implemented in
> > swsusp_booke.S/swsusp_asm64.S.
> 
> Sorry for inconsistency. Will changes e500 to booke.
> Hibernation and suspend can share the code.

Maybe they could, but AFAICT this patchset doesn't make that happen --
and I'm not convinced that the churn would be worthwhile.  Note that
swsusp_asm64.S is not just for booke, so most of that file would not be
going away if you did make such a change.

I also don't like the way it looks like booke_save_regs.S is a booke
version of ppc_save_regs.S, even though they serve different purposes
and ppc_save_regs.S is still relevant to booke.

> > > + * Software-Use Registers
> > > + *	SPRG1			0x260		(dw * 76), 64-bit need to save.
> > > + *	SPRG3			0x268		(dw * 77), 32-bit need to save.
> > 
> > What about "CPU and NUMA node for VDSO getcpu" on 64-bit?  Currently
> > SPRG3, but it will need to change for critical interrupt support.
> > 
> > > + * MMU Registers
> > > + *	PID0 - PID2		0x270 ~ 0x280	(dw * 78 ~ dw * 80)
> > 
> > PID1/PID2 are e500v1/v2 only -- and Linux doesn't use them outside of
> > KVM (and you're not in KVM when you're running this code).
> > 
> > Are we ever going to have a non-zero PID at this point?
> 
> I incline to the view that saving all registers regardless of used or
> unused. The good point is that it can be compliant to the future
> changes of the usage of registers.
> 
> What do you think?

I agree to a certain extent, but balance it with the complexity of
dealing with registers that don't exist on all booke chips.  If they
don't really need to be saved, why go through the hassle of conditional
code?

> > > + * Debug Registers
> > > + *	DBCR0 - DBCR2		0x288 ~ 0x298	(dw * 81 ~ dw * 83)
> > > + *	IAC1 - IAC4		0x2a0 ~ 0x2b8	(dw * 84 ~ dw * 87)
> > > + *	DAC1 - DAC2		0x2c0 ~ 0x2c8	(dw * 88 ~ dw * 89)
> > > + *
> > > + */
> > 
> > IAC3-4 are not implemented on e500.
> > 
> > Do we really need to save the debug registers?  We're not going to be in
> > a debugged process when we do suspend.  If the concern is kgdb, it
> > probably needs to be told to get out of the way during suspend for other
> > reasons.
> 
> I think in the ideal case the suspend would not break any context. We
> should try to save/restore all cpu state. Of cause, trade-off is
> unavoidable in practice.
> 
> > 
> > > +#define SR_GPR1			0x000
> > > +#define SR_GPR2			0x008
> > > +#define SR_GPR13		0x010
> > > +#define SR_FPR14		0x0a8
> > > +#define SR_CR			0x138
> > > +#define SR_LR			0x140
> > > +#define SR_MSR			0x148
> > 
> > These are very vague names to be putting in a header file.
> 
> How about BOOKE_xx_OFFSET?

Better, but does it need to be in a public header file at all?
 
> > > +/*
> > > + * hibernation and deepsleep save/restore different number of registers,
> > > + * use these flags to indicate.
> > > + */
> > > +#define HIBERNATION_FLAG	1
> > > +#define DEEPSLEEP_FLAG		2
> > 
> > Again, namespacing -- but why is hibernation using this at all?  What's
> > wrong with the existing hibernation support?
> 
> How about BOOKE_HIBERNATION_FLAG?
> 
> Just wish to share code between hibernation and suspend.

No need until and unless you actually implement the change for
hibernation to use this.  As is, this is dead and untestable code.
 
> > > +booke_cpu_append_save:
> > > +	mfspr	r0, SPRN_PVR
> > > +	rlwinm	r11, r0, 16, 16, 31
> > > +
> > > +	lis	r12, 0
> > > +	ori	r12, r12, PVR_VER_E6500@l
> > > +	cmpw	r11, r12
> > > +	beq	e6500_append_save
> > > +
> > > +	lis	r12, 0
> > > +	ori	r12, r12, PVR_VER_E5500@l
> > > +	cmpw	r11, r12
> > > +	beq	e5500_append_save
> > > +
> > > +	lis	r12, 0
> > > +	ori	r12, r12, PVR_VER_E500MC@l
> > > +	cmpw	r11, r12
> > > +	beq	e500mc_append_save
> > > +
> > > +	lis	r12, 0
> > > +	ori	r12, r12, PVR_VER_E500V2@l
> > > +	cmpw	r11, r12
> > > +	beq	e500v2_append_save
> > > +
> > > +	lis	r12, 0
> > > +	ori	r12, r12, PVR_VER_E500V1@l
> > > +	cmpw	r11, r12
> > > +	beq	e500v1_append_save
> > > +	b	1f
> > > +
> > > +e6500_append_save:
> > > +	do_e6500_sr_interrupt_regs(save)
> > > +	do_e6500_sr_debug_regs(save)
> > > +	b	1f
> > > +
> > > +e5500_append_save:
> > > +	do_e5500_sr_interrupt_regs(save)
> > > +	b	1f
> > > +
> > > +e500mc_append_save:
> > > +	do_e500mc_sr_interrupt_regs(save)
> > > +	b	1f
> > > +
> > > +e500v2_append_save:
> > > +e500v1_append_save:
> > > +	do_e500_sr_interrupt_regs(save)
> > > +1:
> > > +	do_sr_interrupt_regs(save)
> > > +	do_sr_debug_regs(save)
> > > +
> > > +	blr
> > 
> > What is meant by "append" here?
> 
> Means extra registers for specific e500 derivative core.

How is that related to skipping it in the hibernation case?
 
-Scott


