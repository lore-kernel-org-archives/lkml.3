Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaIZFcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:32:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:31779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbaIZFcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:32:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,603,1406617200"; 
   d="scan'208";a="608908533"
Message-ID: <5424FA7C.6020303@intel.com>
Date: Thu, 25 Sep 2014 22:32:44 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ong Boon Leong <boon.leong.ong@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: Re: [PATCH] x86, setup: add __flush_tlb() for Intel Quark X1000
References: <1411705827-2522-1-git-send-email-boon.leong.ong@intel.com> <1411705827-2522-2-git-send-email-boon.leong.ong@intel.com>
In-Reply-To: <1411705827-2522-2-git-send-email-boon.leong.ong@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 09:30 PM, Ong Boon Leong wrote:
> Intel Quark X1000 advertises PGE (bit 13 of EDX) in CPUID.
> In reality, it does not implement PGE in current silicon.
> 
> This is an issue because __flush_tlb_all() depends on cpu_has_pge
> which has following dependency:
>  - cpu_has_pge --> boot_cpu_data --> new_cpu_data obtained from CPUID
>    in head_32.S.

Can I suggest a better description?

__flush_tlb_all() looks at the CPUID PGE bit.  If it finds it, the TLB
is flushed by clearing and then setting the PGE bit in CR4.  However,
since the Intel Quark X1000 does not _actually_ have PGE, this bit in
CR4 is ignored and the  attempt to flush the TLB does nothing.

Normally, we can fix up these kinds of CPUID mishaps in software.
However, this is earlier than that fixup code actually runs.

To work around this, we simply use an unconditional __flush_tlb() which
uses a cr3 write instead of the PGE bit twiddling in CR4.

We considered attempting to reorder the CPUID fixup code, but decided
that we were more likely to cause collateral damage if we tried this.
The cost of the extra TLB flush is minimal and is unlikely to break
anything else.

> As this is early stage of kernel boot-up and  adding
> __flush_tlb() is not going to hurt much in CPU cycles, we add it
> here and together with the explanation for future reference.
> 
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>  arch/x86/kernel/setup.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 41ead8d..90e0b85 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -880,6 +880,13 @@ void __init setup_arch(char **cmdline_p)
>  
>  	load_cr3(swapper_pg_dir);
>  	__flush_tlb_all();
> +	/*
> +	 * Quark X1000 wrongly advertises PGE, add __flush_tlb()
> +	 * below to make sure TLB is flushed correctly in the early stage
> +	 * of setup_arch() for Quark X1000.
> +	 * X86_FEATURE_PGE flag is only setup later stage at early_cpu_init();
> +	 */
> +	__flush_tlb();

I'd just say:

Quark X1000 wrongly advertises PGE.  Work around this with an
unconditional full flush using a CR3 write instead of CR4.PGE:
