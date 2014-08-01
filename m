Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaHAILL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:11:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40192 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbaHAILD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:11:03 -0400
Date: Fri, 1 Aug 2014 09:10:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] ARM: don't enter kgdb when userspace executes a kgdb
 break instruction.
Message-ID: <20140801081038.GA15733@arm.com>
References: <20140801030520.GA27665@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801030520.GA27665@mew>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:05:20AM +0100, Omar Sandoval wrote:
> The kgdb breakpoint hooks (kgdb_brk_fn and kgdb_compiled_brk_fn) should only be
> entered when a kgdb break instruction is executed from the kernel. Otherwise,
> if kgdb is enabled, a userspace program can cause the kernel to drop into the
> debugger by executing either KGDB_BREAKINST or KGDB_COMPILED_BREAK.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
> On a kernel running with kgdb enabled, this program reproduces the problem:
> .globl _start
> _start:
> 	udf	#65006	@ KGDB_BREAKINST
> 
> The same problem has been fixed in ARM64.
> 
>  arch/arm/kernel/kgdb.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
> index 778c2f7..a74b53c 100644
> --- a/arch/arm/kernel/kgdb.c
> +++ b/arch/arm/kernel/kgdb.c
> @@ -160,12 +160,16 @@ static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int instr)
>  static struct undef_hook kgdb_brkpt_hook = {
>  	.instr_mask		= 0xffffffff,
>  	.instr_val		= KGDB_BREAKINST,
> +	.cpsr_mask		= MODE_MASK,
> +	.cpsr_val		= SVC_MODE,
>  	.fn			= kgdb_brk_fn
>  };
>  
>  static struct undef_hook kgdb_compiled_brkpt_hook = {
>  	.instr_mask		= 0xffffffff,
>  	.instr_val		= KGDB_COMPILED_BREAK,
> +	.cpsr_mask		= MODE_MASK,
> +	.cpsr_val		= SVC_MODE,
>  	.fn			= kgdb_compiled_brk_fn
>  };

Acked-by: Will Deacon <will.deacon@arm.com>

Please put this into rmk's patch system.

Cheers,

Will
