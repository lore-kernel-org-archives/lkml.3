Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab3IPVCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:02:47 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:36882
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab3IPVCp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:02:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dIc89bh936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1379365336.2536.166.camel@snotra.buserror.net>
Subject: Re: [PATCH v2] powerpc 8xx: Fixing issue with CONFIG_PIN_TLB
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 16 Sep 2013 16:02:16 -0500
In-Reply-To: <52329CDF.9020103@c-s.fr>
References: <201309121825.r8CIPrkI005690@localhost.localdomain>
	 <1379011469.2536.45.camel@snotra.buserror.net> <52329CDF.9020103@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-13 at 07:04 +0200, leroy christophe wrote:
> Le 12/09/2013 20:44, Scott Wood a écrit :
> > On Thu, 2013-09-12 at 20:25 +0200, Christophe Leroy wrote:
> >> This is a reorganisation of the setup of the TLB at kernel startup, in order
> >> to handle the CONFIG_PIN_TLB case in accordance with chapter 8.10.3 of MPC866
> >> and MPC885 reference manuals.
> >>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >>
> >> diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S linux-3.11/arch/powerpc/kernel/head_8xx.S
> >> --- linux-3.11.org/arch/powerpc/kernel/head_8xx.S	2013-09-02 22:46:10.000000000 +0200
> >> +++ linux-3.11/arch/powerpc/kernel/head_8xx.S	2013-09-09 11:28:54.000000000 +0200
> >> @@ -785,27 +785,24 @@
> >>    * these mappings is mapped by page tables.
> >>    */
> >>   initial_mmu:
> >> -	tlbia			/* Invalidate all TLB entries */
> >> -/* Always pin the first 8 MB ITLB to prevent ITLB
> >> -   misses while mucking around with SRR0/SRR1 in asm
> >> -*/
> >> -	lis	r8, MI_RSV4I@h
> >> -	ori	r8, r8, 0x1c00
> >> -
> >> +	lis	r8, MI_RESETVAL@h
> >>   	mtspr	SPRN_MI_CTR, r8	/* Set instruction MMU control */
> >>   
> >> -#ifdef CONFIG_PIN_TLB
> >> -	lis	r10, (MD_RSV4I | MD_RESETVAL)@h
> >> -	ori	r10, r10, 0x1c00
> >> -	mr	r8, r10
> >> -#else
> >>   	lis	r10, MD_RESETVAL@h
> >> -#endif
> >>   #ifndef CONFIG_8xx_COPYBACK
> >>   	oris	r10, r10, MD_WTDEF@h
> >>   #endif
> >>   	mtspr	SPRN_MD_CTR, r10	/* Set data TLB control */
> >>   
> >> +	tlbia			/* Invalidate all TLB entries */
> > Is this change to make sure we invalidate everything even if the
> > bootloader set RSV4I?
> Most probably. It is step 2 of the process defined in MPC866 and MPC885 
> Reference Manuals:
> 
> §8.10.3 Loading Locked TLB Entries:
> The process of loading a single reserved entry in the TLB is as follows:

To minimize code churn we should just fix actual problems, rather than
shuffle things around to conform to a suggested sequence.  After all,
we're not just trying to load a single entry.

> >> +	ori	r8, r8, 0x1c00
> >> +	mtspr	SPRN_MI_CTR, r8	/* Set instruction MMU control */
> >> +#ifdef CONFIG_PIN_TLB
> >> +	ori	r10, r10, 0x1c00
> >> +	mtspr	SPRN_MD_CTR, r10	/* Set data TLB control */
> >> +#endif
> > Still 0x1c00?
> Yes, I kept the same entries in order to limit modifications:
> * 28 = First 8Mbytes page
> * 29 = IMMR
> * 30 = Second 8Mbytes page
> * 31 = Third 8Mbytes page

If you actually want to program them in increasing order then it looks
like you're still missing a write to CTR between the last two 8M entries
-- thus you'll overwrite the IMMR with the last 8M entry.  That was the
same problem that v1 fixed -- did that change get lost accidentally?

The hardware wants to decrement; why fight it?

> >>   	/* Now map the lower 8 Meg into the TLBs.  For this quick hack,
> >>   	 * we can load the instruction and data TLB registers with the
> >>   	 * same values.
> >> @@ -825,6 +822,12 @@
> >>   	mtspr	SPRN_MI_AP, r8
> >>   	mtspr	SPRN_MD_AP, r8
> >>   
> >> +	/* Always pin the first 8 MB ITLB to prevent ITLB
> >> +	 * misses while mucking around with SRR0/SRR1 in asm
> >> +	 */
> >> +	lis	r8, (MI_RSV4I | MI_RESETVAL)@h
> >> +	mtspr	SPRN_MI_CTR, r8	/* Set instruction MMU control */
> > Entry 0 is not pinnable.
> Here we are not trying to pin entry 0.

Sorry, misread the patch.

> We are at step 8, we are setting 
> MI_RSV4I. At the same time, we set MD_CTR to 0 which is off the pinned 
> range, to be sure that we won't overwrite one of the pinned entries.
>
> The main difference compared to the previous implementation is that 
> before, we were setting the RSV4I bit before loading the TLB entries. 
> Now, as defined in the Reference Manuals, we are doing it at the end.

Have you seen any evidence that it matters?

-Scott



