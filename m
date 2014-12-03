Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaLCFWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:22:08 -0500
Received: from ozlabs.org ([103.22.144.67]:54419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaLCFWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:22:06 -0500
In-Reply-To: <1417507013-11948-2-git-send-email-khandual@linux.vnet.ibm.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: shuahkh@osg.samsung.com, mikey@neuling.org, james.hogan@imgtec.com,
        avagin@openvz.org, Paul.Clothier@imgtec.com, peterz@infradead.org,
        palves@redhat.com, oleg@redhat.com, davem@davemloft.net,
        dhowells@redhat.com, kirjanov@gmail.com, davej@redhat.com,
        akpm@linux-foundation.org, sukadev@linux.vnet.ibm.com,
        tglx@linutronix.de, sam.bobroff@au1.ibm.com
Subject: Re: [V6,1/9] elf: Add new powerpc specifc core note sections
Message-Id: <20141203052204.9DA8F1400DD@ozlabs.org>
Date: Wed,  3 Dec 2014 16:22:04 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-12 at 07:56:45 UTC, Anshuman Khandual wrote:
> This patch adds four new ELF core note sections for powerpc
> transactional memory and one new ELF core note section for
> powerpc general miscellaneous debug registers. These addition
> of new ELF core note sections extends the existing ELF ABI
> without affecting it in any manner.
> 
> Acked-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  include/uapi/linux/elf.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> index ea9bf25..2260fc0 100644
> --- a/include/uapi/linux/elf.h
> +++ b/include/uapi/linux/elf.h
> @@ -379,6 +379,11 @@ typedef struct elf64_shdr {
>  #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
>  #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
>  #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
> +#define NT_PPC_TM_SPR	0x103		/* PowerPC TM special registers */
> +#define NT_PPC_TM_CGPR	0x104		/* PowerpC TM checkpointed GPR */
> +#define NT_PPC_TM_CFPR	0x105		/* PowerPC TM checkpointed FPR */
> +#define NT_PPC_TM_CVMX	0x106		/* PowerPC TM checkpointed VMX */
> +#define NT_PPC_MISC	0x107		/* PowerPC miscellaneous registers */

This is a really terrible name, "MISC".

Having said that, I guess it's accurate. We have a whole bunch of regs that
have accrued over recent years that aren't accessible via ptrace.

It seems to me if we're adding a misc regset we should be adding everything we
might want to it that is currenty architected.

But currently you only include the PPR, TAR & DSCR.

Looking at Power ISA v2.07, I see the following that could be included:

  MMCR2
  MMCRA
  PMC1
  PMC2
  PMC3
  PMC4
  PMC5
  PMC6
  MMCR0
  EBBHR
  EBBRR
  BESCR
  SIAR
  SDAR
  CFAR?

Those are all new in 2.07 except for CFAR.

There might be more I missed, that was just a quick scan.

Some are only accessible when EBB is in use, maybe those could be a separate
regset.

cheers
