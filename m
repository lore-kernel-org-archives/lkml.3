Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaIZVAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:00:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47835 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755234AbaIZVAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:00:08 -0400
X-Sasl-enc: NYVmbdhsicx8b8Eg7bdgSjjTuoqNYZBibslPZFAdIMeQ 1411765207
Date: Fri, 26 Sep 2014 17:59:55 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, davej@redhat.com,
        boon.leong.ong@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Quark: Add if/else to setup_arch for Quark TLB
 bug
Message-ID: <20140926205955.GA22407@khazad-dum.debian.net>
References: <1411754118-11665-1-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411754118-11665-1-git-send-email-pure.logic@nexus-software.ie>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Bryan O'Donoghue wrote:
> Quark X1000 incorrectly advertises PGE. In later stages of boot
> specifically in early_init_intel we setup_clear_cpu_cap for PGE.
> At this point in time cpu_has_pge() will still be true.
> 
> Use the boot_cpu_data to decide if __flush_tlb_all() or __flush_tlb()
> should be called subsequent to loading CR3

...

>  	load_cr3(swapper_pg_dir);
> -	__flush_tlb_all();
> +
> +	/*
> +	 * Flush the TLB after loading CR3
> +	 *
> +	 * Quark X1000 wrongly advertises PGE. Use boot_cpu_data to
> +	 * to make sure ithe TLB is flushed correctly in the early
> +	 * stage of setup_arch() for Quark X1000.
> +	 * X86_FEATURE_PGE flag is only setup later stage at
> +	 * early_cpu_init();
> +	 */
> +	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
> +	    boot_cpu_data.x86 == 5 && boot_cpu_data.x86_model == 9)
> +		__flush_tlb();
> +	else
> +		__flush_tlb_all();
>  #else
>  	printk(KERN_INFO "Command line: %s\n", boot_command_line);
>  #endif

I'm confused, now.

Wasn't the other patch -- which just added a comment -- the one selected as
a better fix, because there is absolutely no point in calling __flush_tlb()
on Quark X1000 *right after* you just flushed the TLB [on these processors]
by doing a load_cr3() ?

Should this one ([PATCH v2] x86: Quark: Add if/else to setup_arch for Quark
TLB bug) be ignored?  Or should the other one which just adds a comment be
ignored?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
