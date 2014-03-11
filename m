Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaCKLOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:14:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49527 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbaCKLOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:14:05 -0400
Date: Tue, 11 Mar 2014 12:13:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sfr@canb.auug.org.au,
        hpa@zytor.com, tglx@linuxtronic.de
Subject: Re: [PATCH] perf/x86/uncore: fix compilation warning in
 snb_uncore_imc_init_box()
Message-ID: <20140311111350.GU27965@twins.programming.kicks-ass.net>
References: <20140311104433.GA16207@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311104433.GA16207@quad>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 11:44:33AM +0100, Stephane Eranian wrote:
> 
> 
> This patches fixes a compilation problem (unused variable) with the
> new SNB/IVB/HSW uncore IMC code.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index b262c61..3846a37 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -1722,15 +1722,19 @@ static struct attribute_group snb_uncore_imc_format_group = {
>  static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
>  {
>  	struct pci_dev *pdev = box->pci_dev;
> -	u32 addr_lo, addr_hi;
> +	u32 addr_lo;
>  	resource_size_t addr;
>  
>  	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET, &addr_lo);
>  	addr = addr_lo;
>  
>  #ifdef CONFIG_PHYS_ADDR_T_64BIT
> -	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET+4, &addr_hi);
> -	addr = ((resource_size_t)addr_hi << 32) | addr_lo;
> +	{ u32 addr_hi;
> +	  int where = SNB_UNCORE_PCI_IMC_BAR_OFFSET + 4;
> +
> +	  pci_read_config_dword(pdev, where, &addr_hi);
> +	  addr = ((resource_size_t)addr_hi << 32) | addr_lo;
> +	}
>  #endif

How about something like:

- u32 addr_lo, addr_hi;
+ u32 pci_dword;

	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET, &pci_dword);
	addr = pci_dword;

#ifdef ..
	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET + 4, &pci_dword);
	addr |= ((u64)pci_dword) << 32;
#endif

That avoids the need for the ugly {} thing. 
