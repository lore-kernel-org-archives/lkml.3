Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbaCQKuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:50:40 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:55682
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932362AbaCQKui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:50:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehz98dI936eI1dbaI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1de2h1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h262fh1155h)
Date: Mon, 17 Mar 2014 18:50:32 +0800
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>,
        Wang Dongsheng-B40534 <B40534@freescale.com>
Subject: Re: [PATCH 8/9] powerpc/85xx: add save/restore functions for core
 registers
Message-ID: <20140317105032.GC6204@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
 <1394168285-32275-8-git-send-email-chenhui.zhao@freescale.com>
 <1394585114.13761.112.camel@snotra.buserror.net>
 <20140312094237.GG4706@localhost.localdomain>
 <1394838105.12479.144.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1394838105.12479.144.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 06:01:45PM -0500, Scott Wood wrote:
> On Wed, 2014-03-12 at 17:42 +0800, Chenhui Zhao wrote:
> > On Tue, Mar 11, 2014 at 07:45:14PM -0500, Scott Wood wrote:
> > > On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> > > > From: Wang Dongsheng <dongsheng.wang@freescale.com>
> > > > 
> > > > Add booke_cpu_state_save() and booke_cpu_state_restore() functions which can be
> > > > used to save/restore CPU's registers in the case of deep sleep and hibernation.
> > > > 
> > > > Supported processors: E6500, E5500, E500MC, E500v2 and E500v1.
> > > > 
> > > > Signed-off-by: Wang Dongsheng <dongsheng.wang@freescale.com>
> > > > Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
> > > > ---
> > > >  arch/powerpc/include/asm/booke_save_regs.h |   96 ++++++++
> > > >  arch/powerpc/kernel/Makefile               |    1 +
> > > >  arch/powerpc/kernel/booke_save_regs.S      |  361 ++++++++++++++++++++++++++++
> > > >  3 files changed, 458 insertions(+), 0 deletions(-)
> > > >  create mode 100644 arch/powerpc/include/asm/booke_save_regs.h
> > > >  create mode 100644 arch/powerpc/kernel/booke_save_regs.S
> > > > 
> > > > diff --git a/arch/powerpc/include/asm/booke_save_regs.h b/arch/powerpc/include/asm/booke_save_regs.h
> > > > new file mode 100644
> > > > index 0000000..87c357a
> > > > --- /dev/null
> > > > +++ b/arch/powerpc/include/asm/booke_save_regs.h
> > > > @@ -0,0 +1,96 @@
> > > > +/*
> > > > + *  Save/restore e500 series core registers
> > > 
> > > Filename says booke, comment says e500.
> > > 
> > > Filename and comment also fail to point out that this is specifically
> > > for standby/suspend, not for hibernate which is implemented in
> > > swsusp_booke.S/swsusp_asm64.S.
> > 
> > Sorry for inconsistency. Will changes e500 to booke.
> > Hibernation and suspend can share the code.
> 
> Maybe they could, but AFAICT this patchset doesn't make that happen --
> and I'm not convinced that the churn would be worthwhile.  Note that
> swsusp_asm64.S is not just for booke, so most of that file would not be
> going away if you did make such a change.

OK. Let's put Hibernation aside, and change the code just for suspend.

> 
> I also don't like the way it looks like booke_save_regs.S is a booke
> version of ppc_save_regs.S, even though they serve different purposes
> and ppc_save_regs.S is still relevant to booke.
> 
> > > > + * Software-Use Registers
> > > > + *	SPRG1			0x260		(dw * 76), 64-bit need to save.
> > > > + *	SPRG3			0x268		(dw * 77), 32-bit need to save.
> > > 
> > > What about "CPU and NUMA node for VDSO getcpu" on 64-bit?  Currently
> > > SPRG3, but it will need to change for critical interrupt support.
> > > 
> > > > + * MMU Registers
> > > > + *	PID0 - PID2		0x270 ~ 0x280	(dw * 78 ~ dw * 80)
> > > 
> > > PID1/PID2 are e500v1/v2 only -- and Linux doesn't use them outside of
> > > KVM (and you're not in KVM when you're running this code).
> > > 
> > > Are we ever going to have a non-zero PID at this point?
> > 
> > I incline to the view that saving all registers regardless of used or
> > unused. The good point is that it can be compliant to the future
> > changes of the usage of registers.
> > 
> > What do you think?
> 
> I agree to a certain extent, but balance it with the complexity of
> dealing with registers that don't exist on all booke chips.  If they
> don't really need to be saved, why go through the hassle of conditional
> code?

I agree. For these registers, I'll check if they are really needed.

-Chenhui

