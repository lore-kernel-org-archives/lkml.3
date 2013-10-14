Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab3JNPj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:39:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48194 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab3JNPj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:39:58 -0400
Date: Mon, 14 Oct 2013 16:39:21 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v2 2/4] arm64: restore FPSIMD to default state for
 kernel and signal contexts
Message-ID: <20131014153921.GK10491@mudshark.cambridge.arm.com>
References: <1381674029-430-1-git-send-email-liuj97@gmail.com>
 <1381674029-430-2-git-send-email-liuj97@gmail.com>
 <20131014151638.GI10491@mudshark.cambridge.arm.com>
 <525C0DF8.8040306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525C0DF8.8040306@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 04:30:00PM +0100, Jiang Liu wrote:
> On 10/14/2013 11:16 PM, Will Deacon wrote:
> > On Sun, Oct 13, 2013 at 03:20:18PM +0100, Jiang Liu wrote:
> >> From: Jiang Liu <jiang.liu@huawei.com>
> >>
> >> Restore FPSIMD control and status registers to default values
> >> when creating new FPSIMD contexts for kernel context and reset
> >> FPSIMD status register when creating FPSIMD context for signal
> >> handling, otherwise the stale value in FPSIMD control and status
> >> registers may affect the new kernal or signal handling contexts.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >> Cc: Jiang Liu <liuj97@gmail.com>
> >> ---
> >>  arch/arm64/include/asm/fpsimd.h | 16 ++++++++++++++++
> >>  arch/arm64/kernel/fpsimd.c      | 11 +++++++++--
> >>  arch/arm64/kernel/signal.c      |  1 +
> >>  arch/arm64/kernel/signal32.c    |  1 +
> >>  4 files changed, 27 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> >> index c43b4ac..b2dc30f 100644
> >> --- a/arch/arm64/include/asm/fpsimd.h
> >> +++ b/arch/arm64/include/asm/fpsimd.h
> >> @@ -50,8 +50,24 @@ struct fpsimd_state {
> >>  #define VFP_STATE_SIZE		((32 * 8) + 4)
> >>  #endif
> >>  
> >> +#define	AARCH64_FPCR_DEFAULT_VAL	0
> >> +
> >>  struct task_struct;
> >>  
> >> +static inline void fpsimd_init_hw_state(void)
> >> +{
> >> +	int val = AARCH64_FPCR_DEFAULT_VAL;
> >> +
> >> +	asm ("msr fpcr, %x0\n"
> >> +	     "msr fpsr, xzr\n"
> >> +             : : "r"(val));
> >> +}
> >> +
> >> +static inline void fpsimd_clear_fpsr(void)
> >> +{
> >> +	asm ("msr fpsr, xzr\n");
> >> +}
> > 
> > You have pretty weak asm constraints here...
> Hi Will,
> 	We will add an explicit "volatile" here. But according to GCC docs, it
> should have the same effect:
> An asm instruction without any output operands is treated identically to
> a volatile asm instruction.

I don't think volatile is enough to prevent re-ordering across a function
call; it just prevents the block from being optimised away entirely and/or
reordered with respect to other volatile statements.

A "memory" clobber should do the trick in this case.

Will
