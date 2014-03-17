Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824AbaCQLUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:20:06 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:20420
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932514AbaCQLUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:20:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1de2h1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h262fh1155h)
Date: Mon, 17 Mar 2014 19:19:57 +0800
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
Message-ID: <20140317111957.GD6204@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
 <1394586624.13761.132.camel@snotra.buserror.net>
 <20140312104005.GH4706@localhost.localdomain>
 <1394839107.12479.154.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1394839107.12479.154.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 06:18:27PM -0500, Scott Wood wrote:
> On Wed, 2014-03-12 at 18:40 +0800, Chenhui Zhao wrote:
> > On Tue, Mar 11, 2014 at 08:10:24PM -0500, Scott Wood wrote:
> > > On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> > > > From: Zhao Chenhui <chenhui.zhao@freescale.com>
> > > > 
> > > > T1040 supports deep sleep feature, which can switch off most parts of
> > > > the SoC when it is in deep sleep mode. This way, it becomes more
> > > > energy-efficient.
> > > > 
> > > > The DDR controller will also be powered off in deep sleep. Therefore,
> > > > the last stage (the latter part of fsl_dp_enter_low) will run without DDR
> > > > access. This piece of code and related TLBs will be prefetched.
> > > > 
> > > > Due to the different initialization code between 32-bit and 64-bit, they
> > > > have seperate resume entry and precedure.
> > > > 
> > > > The feature supports 32-bit and 64-bit kernel mode.
> > > > 
> > > > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > > > ---
> > > >  arch/powerpc/include/asm/booke_save_regs.h |    3 +
> > > >  arch/powerpc/kernel/cpu_setup_fsl_booke.S  |   17 ++
> > > >  arch/powerpc/kernel/head_fsl_booke.S       |   30 +++
> > > >  arch/powerpc/platforms/85xx/Makefile       |    2 +-
> > > >  arch/powerpc/platforms/85xx/deepsleep.c    |  201 +++++++++++++++++++
> > > >  arch/powerpc/platforms/85xx/qoriq_pm.c     |   38 ++++
> > > >  arch/powerpc/platforms/85xx/sleep.S        |  295 ++++++++++++++++++++++++++++
> > > >  arch/powerpc/sysdev/fsl_soc.h              |    7 +
> > > >  8 files changed, 592 insertions(+), 1 deletions(-)
> > > >  create mode 100644 arch/powerpc/platforms/85xx/deepsleep.c
> > > >  create mode 100644 arch/powerpc/platforms/85xx/sleep.S
> > > > 
> > > > diff --git a/arch/powerpc/include/asm/booke_save_regs.h b/arch/powerpc/include/asm/booke_save_regs.h
> > > > index 87c357a..37c1f6c 100644
> > > > --- a/arch/powerpc/include/asm/booke_save_regs.h
> > > > +++ b/arch/powerpc/include/asm/booke_save_regs.h
> > > > @@ -88,6 +88,9 @@
> > > >  #define HIBERNATION_FLAG	1
> > > >  #define DEEPSLEEP_FLAG		2
> > > >  
> > > > +#define CPLD_FLAG	1
> > > > +#define FPGA_FLAG	2
> > > 
> > > What is this?
> > 
> > We have two kind of boards, QDS and RDB.
> > They have different register map. Use the flag to indicate the current board is using which kind
> > of register map.
> 
> CPLD versus FPGA is not a meaningful difference.  We don't care what
> technology is used to implement programmable logic -- we care what
> programming interface is exposed.  Customers will have their own boards
> that will likely not imitate either of these programming interfaces, but
> what they do have will still probably be implemented in a CPLD or FPGA.
> Likewise, Freescale may have future reference boards whose CPLD/FPGA is
> not compatible.

Will use a better name.

> 
> So use better naming, and structure the code so it's easy to plug in
> implementations for new or custom boards.
>  
> > > > diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
> > > > index 20204fe..3285752 100644
> > > > --- a/arch/powerpc/kernel/head_fsl_booke.S
> > > > +++ b/arch/powerpc/kernel/head_fsl_booke.S
> > > > @@ -162,6 +162,19 @@ _ENTRY(__early_start)
> > > >  #include "fsl_booke_entry_mapping.S"
> > > >  #undef ENTRY_MAPPING_BOOT_SETUP
> > > >  
> > > > +#if defined(CONFIG_SUSPEND) && defined(CONFIG_FSL_CORENET_RCPM)
> > > > +	/* if deep_sleep_flag != 0, jump to the deep sleep resume entry */
> > > > +	LOAD_REG_ADDR(r4, deep_sleep_flag)
> > > > +	lwz	r3, 0(r4)
> > > > +	cmpwi	r3, 0
> > > > +	beq	11f
> > > > +	/* clear deep_sleep_flag */
> > > > +	li	r3, 0
> > > > +	stw	r3, 0(r4)
> > > > +	b	fsl_deepsleep_resume
> > > > +11:
> > > > +#endif
> > > 
> > > Why do you come in via the normal kernel entry, versus specifying a
> > > direct entry point for deep sleep resume?  How does U-Boot even know
> > > what the normal entry is when resuming?
> > 
> > I wish to return to a specified point (like 64-bit mode), but the code in
> > fsl_booke_entry_mapping.S only can run in the first page. Because it
> > only setups a temp mapping of 4KB.
> 
> Why do you need the entry mapping on 32-bit but not 64-bit?

fsl_booke_entry_mapping.S is for 32-bit. 64-bit calls
initial_tlb_book3e() in exceptions-64e.S.

> > 
> > > > +#if defined(CONFIG_SUSPEND) && defined(CONFIG_FSL_CORENET_RCPM)
> > > > +_ENTRY(__entry_deep_sleep)
> > > > +/*
> > > > + * Bootloader will jump to here when resuming from deep sleep.
> > > > + * After executing the init code in fsl_booke_entry_mapping.S,
> > > > + * will jump to the real resume entry.
> > > > + */
> > > > +	li	r8, 1
> > > > +	bl	12f
> > > > +12:	mflr	r9
> > > > +	addi	r9, r9, (deep_sleep_flag - 12b)
> > > > +	stw	r8, 0(r9)
> > > > +	b __early_start
> > > > +deep_sleep_flag:
> > > > +	.long	0
> > > > +#endif
> > > 
> > > It's a bit ambiguous to say "entry_deep_sleep" when it's resuming rather
> > > than entering...
> > 
> > How about __fsl_entry_resume?
> 
> fsl_booke_deep_sleep_resume
> 
> > > > +#define FSLDELAY(count)		\
> > > > +	li	r3, (count)@l;	\
> > > > +	slwi	r3, r3, 10;	\
> > > > +	mtctr	r3;		\
> > > > +101:	nop;			\
> > > > +	bdnz	101b;
> > > 
> > > You don't need a namespace prefix on local macros in a non-header file.
> > > 
> > > Is the timebase stopped where you're calling this from?
> > 
> > No. My purpose is to avoid jump in the last stage of entering deep sleep.
> > Jump may cause problem at that time.
> 
> "bdnz" is a jump.
> 
> What problems do you think a jump will cause?

I mean a far jump which can jump to an address which has not been prefetched in
advance. I wish the code is executed in a restricted environment (predictable code
and address).

> 
> > > You also probably want to do a "sync, readback, data dependency, isync"
> > > sequence to make sure that the store has hit CCSR before you begin your
> > > delay (or is a delay required at all if you do that?).
> > 
> > Yes. It is safer with a sync sequence.
> > 
> > The DDR controller need some time to signal the external DDR modules to
> > enter self refresh mode.
> 
> Is it documented how much time it requires?
> 
> -Scott

No.

-Chenhui

