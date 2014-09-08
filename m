Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaIJQBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:01:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43819 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIJQBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:01:05 -0400
Date: Mon, 8 Sep 2014 02:30:51 -0700
From: Olof Johansson <olof@lixom.net>
To: behanw@converseincode.com
Cc: anderson@redhat.com, catalin.marinas@arm.com, cl@linux.com,
        cov@codeaurora.org, jays.lee@samsung.com, msalter@redhat.com,
        sandeepa.prabhu@linaro.org, srivatsa.bhat@linux.vnet.ibm.com,
        steve.capper@linaro.org, sudeep.karkadanagesha@arm.com,
        takahiro.akashi@linaro.org, Vijaya.Kumar@caviumnetworks.com,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, acme@kernel.org,
        akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com,
        marc.zyngier@arm.com, Matthew.Leach@arm.com, mingo@redhat.com,
        paulus@samba.org, Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] arm64: LLVMLinux: Fix inline arm64 assembly for use with
 clang
Message-ID: <20140908093051.GA12657@localhost>
References: <1409959460-15989-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409959460-15989-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 04:24:20PM -0700, behanw@converseincode.com wrote:
> From: Mark Charlebois <charlebm@gmail.com>
> 
> Fix variable types for 64-bit inline assembly.
> 
> This patch now works with both gcc and clang.
> 
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  arch/arm64/include/asm/arch_timer.h | 26 +++++++++++++++-----------
>  arch/arm64/include/asm/uaccess.h    |  2 +-
>  arch/arm64/kernel/debug-monitors.c  |  8 ++++----
>  arch/arm64/kernel/perf_event.c      | 34 +++++++++++++++++-----------------
>  arch/arm64/mm/mmu.c                 |  2 +-
>  5 files changed, 38 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> index 9400596..c1f87e0 100644
> --- a/arch/arm64/include/asm/arch_timer.h
> +++ b/arch/arm64/include/asm/arch_timer.h
> @@ -37,19 +37,23 @@ void arch_timer_reg_write_cp15(int access, enum arch_timer_reg reg, u32 val)
>  	if (access == ARCH_TIMER_PHYS_ACCESS) {
>  		switch (reg) {
>  		case ARCH_TIMER_REG_CTRL:
> -			asm volatile("msr cntp_ctl_el0,  %0" : : "r" (val));
> +			asm volatile("msr cntp_ctl_el0,  %0"
> +				: : "r" ((u64)val));

Ick. Care to elaborate in the patch description why this is needed with
LLVM? It's really messy and very annoying having to cast register values
every time they're passed in, instead of the compiler handling it for you.

Is there a way to catch this with GCC? If not, I expect you to get broken
all the time on this by people who don't notice.



-Olof
