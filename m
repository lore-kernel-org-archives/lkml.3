Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbaIEKCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:02:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40468 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756269AbaIEKCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:02:30 -0400
Date: Fri, 5 Sep 2014 11:00:02 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] arm64: kgdb: fix single stepping
Message-ID: <20140905100002.GJ13515@arm.com>
References: <1409910463-30936-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409910463-30936-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 10:47:43AM +0100, AKASHI Takahiro wrote:
> I tried to verify kgdb in vanilla kernel on fast model, but it seems that
> the single stepping with kgdb doesn't work correctly since its first
> appearance at v3.15.
> 
> On v3.15, 'stepi' command after breaking the kernel at some breakpoint
> steps forward to the next instruction, but the succeeding 'stepi' never
> goes beyond that.
> On v3.16, 'stepi' moves forward to the second instruction just after call of
> do_debug_execption() in el1_dbg, and never goes beyond that. This variance
> of behavior seems to come in with the following patch in v3.16:
> 
>     commit 2a2830703a23 ("arm64: debug: avoid accessing mdscr_el1 on fault
>     paths where possible")

I don't think you should worry about this change -- from what you're saying,
the code has never worked.

> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index 5901480..a345973 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -87,6 +87,13 @@
>  9990:
>  	.endm
>  
> +	.macro  enable_dbg_if_not_stepping, tmp
> +	mrs     \tmp, mdscr_el1
> +	tbnz    \tmp, #0, 9990f
> +	enable_dbg
> +9990:
> +	.endm

We really don't want to bring this back, as it makes KVM guests extremely
slow (the mdscr access traps to the hypervisor).

It sounds more to me like kgdb is expecting step to remain active, but
that's not the case unless you explicit rewind the state machine (like we do
for ptrace). Can you try issuing the call to set_regs_spsr_ss in
single_step_handler, even when the step hook claims to have handled the
exception?

Will
