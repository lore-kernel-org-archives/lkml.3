Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaG2LQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:16:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55579 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085AbaG2LQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:16:51 -0400
Date: Tue, 29 Jul 2014 12:15:57 +0100
From: Will Deacon <will.deacon@arm.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Cyril Chemparathy <cyril@ti.com>
Subject: Re: [PATCH 1/2] ARM: LPAE: load upper bits of early TTBR0/TTBR1
Message-ID: <20140729111557.GF9245@arm.com>
References: <20140722153623.25088.37742.stgit@buzz>
 <20140728181224.GN15536@arm.com>
 <CALYGNiNrK1d32ecz4rw0sgn0GyN-M6hTBuTLGQV53Z4Br-bpYQ@mail.gmail.com>
 <20140728184741.GT15536@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728184741.GT15536@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 07:47:41PM +0100, Will Deacon wrote:
> On Mon, Jul 28, 2014 at 07:40:58PM +0100, Konstantin Khlebnikov wrote:
> > On Mon, Jul 28, 2014 at 10:12 PM, Will Deacon <will.deacon@arm.com> wrote:
> > > On Tue, Jul 22, 2014 at 04:36:23PM +0100, Konstantin Khlebnikov wrote:
> > >> This patch fixes booting when idmap pgd lays above 4gb. Commit
> > >> 4756dcbfd37 mostly had fixed this, but it'd failed to load upper bits.
> > >>
> > >> Also this fixes adding TTBR1_OFFSET to TTRR1: if lower part overflows
> > >> carry flag must be added to the upper part.
> > >>
> > >> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> > >> Cc: Cyril Chemparathy <cyril@ti.com>
> > >> Cc: Vitaly Andrianov <vitalya@ti.com>
> > >> ---
> > >>  arch/arm/mm/proc-v7-3level.S |    7 +++----
> > >>  1 file changed, 3 insertions(+), 4 deletions(-)
> > >>
> > >> diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
> > >> index 22e3ad6..f0481dd 100644
> > >> --- a/arch/arm/mm/proc-v7-3level.S
> > >> +++ b/arch/arm/mm/proc-v7-3level.S
> > >> @@ -140,12 +140,11 @@ ENDPROC(cpu_v7_set_pte_ext)
> > >>       mov     \tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
> > >>       mov     \ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT             @ lower bits
> > >>       addls   \ttbr1, \ttbr1, #TTBR1_OFFSET
> > >> -     mcrr    p15, 1, \ttbr1, \zero, c2                       @ load TTBR1
> > >> +     adcls   \tmp, \tmp, #0
> > >> +     mcrr    p15, 1, \ttbr1, \tmp, c2                        @ load TTBR1
> > >>       mov     \tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
> > >>       mov     \ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT             @ lower bits
> > >> -     mcrr    p15, 0, \ttbr0, \zero, c2                       @ load TTBR0
> > >> -     mcrr    p15, 1, \ttbr1, \zero, c2                       @ load TTBR1
> > >> -     mcrr    p15, 0, \ttbr0, \zero, c2                       @ load TTBR0
> > >> +     mcrr    p15, 0, \ttbr0, \tmp, c2                        @ load TTBR0
> > >
> > > I must admit, the code you are removing here looks really strange. Was there
> > > a badly resolved conflict somewhere along the way? It would be nice to see
> > > if your fix (which seems ok to me) was actually present in the mailing list
> > > posting of the patch that ended in the above mess.
> > 
> > Nope, no merge conflicts, source in original patch
> > https://lkml.org/lkml/2012/9/11/346
> > 
> > That mess completely harmless, this code is used only once on boot.
> > I don't have that email, so replying isn't trivial for me.
> 
> How bizarre. Also, Cyril doesn't work for TI anymore (his email is
> bouncing), so it's tricky to know what he meant here.
> 
> Your patch looks better than what we currently have though. Have you managed
> to test it on a keystone platform (I don't have one)?

Given that:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
