Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaEBXnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 19:43:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32957 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaEBXnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 19:43:14 -0400
Subject: Re: [PATCH v2] uprobes: fix scratch register selection for
 rip-relative fixups
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1399043040-28366-1-git-send-email-dvlasenk@redhat.com>
References: <1399043040-28366-1-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 May 2014 16:43:09 -0700
Message-ID: <1399074189.4821.10.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050223-7182-0000-0000-00000A7E196B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 17:04 +0200, Denys Vlasenko wrote:
> Before this patch, instructions such as div, mul,
> shifts with count in CL, cmpxchg are mishandled.

I just noticed that this sounds rather worse than it is.  It would be
more precise to say, "Before this patch, the rip-relative addressing
mode in instructions such as ... is mishandled."

...
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Jim Keniston <jkenisto@us.ibm.com>
> CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/uprobes.c | 179 +++++++++++++++++++++++++++++++++-------------
>  1 file changed, 128 insertions(+), 51 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index dbbf6cd..5b387b7 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -41,8 +41,12 @@
>  /* Instruction will modify TF, don't change it */
>  #define UPROBE_FIX_SETF		0x04
> 
> -#define UPROBE_FIX_RIP_AX	0x08
> -#define UPROBE_FIX_RIP_CX	0x10
> +#define UPROBE_FIX_RIP_SI	0x08
> +#define UPROBE_FIX_RIP_DI	0x10
> +#define UPROBE_FIX_RIP_BX	0x20
> +#define UPROBE_FIX_RIP_MASK	(UPROBE_FIX_RIP_SI \
> +				| UPROBE_FIX_RIP_DI \
> +				| UPROBE_FIX_RIP_BX)

Yes.

...
> +	/* Fetch vex.vvvv */
> +	reg2 = 0xff;
> +	if (insn->vex_prefix.nbytes == 2) {
> +		reg2 = insn->vex_prefix.bytes[1];
> +	}
> +	if (insn->vex_prefix.nbytes == 3) {
> +		reg2 = insn->vex_prefix.bytes[2];
> +	}
> +	/* TODO: add XOP, EXEV vvvv reading */
> +	/*
> +	 * vex.vvvv field is in bits 6-3, bits are inverted.
> +	 * But in 32-bit mode, high-order bit may be ignored.
> +	 * Therefore, let's consider only 3 low-order bits.
> +	 */
> +	reg2 = ((reg2 >> 3) & 0x7) ^ 0x7;
> 
> +	/* Register numbering is ax,cx,dx,bx, sp,bp,si,di, r8..r15 */
> +	/*
> +	 * Choose scratch reg. Order is important:
> +	 * must not select bx if we can use si (cmpxchg8b case!)

It'd be good to add here:
	 * For instructions without a VEX prefix, reg2 is 0 here.

Otherwise it kind of looks like you forgot to address that case, and the
reader shouldn't have to do the bit fiddling to figure it out.

> +	 */
> +	if (reg != 6 && reg2 != 6) {
> +		reg2 = 6;
> +		auprobe->def.fixups |= UPROBE_FIX_RIP_SI;
> +	} else if (reg != 7 && reg2 != 7) {
> +		reg2 = 7;
> +		auprobe->def.fixups |= UPROBE_FIX_RIP_DI;
> +		/* TODO (paranoia): force maskmovq to not use di */
> +	} else {
> +		reg2 = 3; /* BX */
> +		auprobe->def.fixups |= UPROBE_FIX_RIP_BX;
> +	}

Yes.  Looks good from here down.

Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>


