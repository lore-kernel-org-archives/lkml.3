Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbbAGRW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:22:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:46494 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbbAGRW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:22:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,715,1413270000"; 
   d="scan'208";a="633867807"
Message-ID: <54AD6B6A.4000701@linux.intel.com>
Date: Wed, 07 Jan 2015 09:22:50 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3.19 1/3] x86, mpx: Check user mode bitness correctly
 when decoding instructions
References: <cover.1419900414.git.luto@amacapital.net> <8207ea76edd142f4a118ad3093b28ec422d92e53.1419900414.git.luto@amacapital.net>
In-Reply-To: <8207ea76edd142f4a118ad3093b28ec422d92e53.1419900414.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 04:52 PM, Andy Lutomirski wrote:
> --- a/arch/x86/mm/mpx.c
> +++ b/arch/x86/mm/mpx.c
> @@ -217,7 +217,7 @@ static int mpx_insn_decode(struct insn *insn,
>  			   struct pt_regs *regs)
>  {
>  	unsigned char buf[MAX_INSN_SIZE];
> -	int x86_64 = !test_thread_flag(TIF_IA32);
> +	int x86_64 = user_64bit_mode(regs);
>  	int not_copied;
>  	int nr_copied;

There are (at least) 3 other uses of the instruction decoder that use
some form of a check on TIF_IA32:

> perf_event_intel_ds.c  intel_pmu_pebs_fixup_ip 785 insn_init(&insn, kaddr, size, is_64bit);
> perf_event_intel_lbr.c branch_type             532 insn_init(&insn, addr, bytes_read, is64);
> uprobes.c              uprobe_init_insn        222 insn_init(insn, auprobe->insn, sizeof(auprobe->insn), x86_64);

Basically doing this:

                is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);

So this method *must* work, at least in practice.

If userspace has MPX on and switches between 32 and 64-bit itself, the
kernel *and* the hardware will suddenly be trying to walk the bounds
tables in the wrong format.  I just don't see an application surviving
very long in that situation.

So I don't have a problem with doing this, long term, as long as we do
it for all of these locations and we do it in a consistent way.  For
MPX, we may even want to enforce that:

	!test_thread_flag(TIF_IA32) == user_64bit_mode(regs)

and freak out if that fails.

But I don't think it's 3.19 material.
