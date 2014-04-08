Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbaDHXHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 19:07:24 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59134 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210AbaDHXHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 19:07:21 -0400
Subject: Re: [RFC PATCH 6/6] uprobes/x86: Emulate rip-relative conditional
 "near" jmp's
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140407142823.GB8881@redhat.com>
References: <20140406201524.GA32694@redhat.com>
	 <20140406201636.GA521@redhat.com>  <20140407142823.GB8881@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Apr 2014 16:07:15 -0700
Message-ID: <1396998435.5056.74.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040823-5806-0000-0000-00002493A7A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 16:28 +0200, Oleg Nesterov wrote:
> On 04/06, Oleg Nesterov wrote:
> >
> > But I'll try to cleanup this patch...
> 
> See v2 below.
> 
> -------------------------------------------------------------------------------
> Subject: [RFC PATCH v2 6/6] uprobes/x86: Emulate rip-relative conditional "near" jmp's
> 
> It seems that 16bit condi jmp is just 0x0f + short_jump_opc_plus_0x10.

Yes, but the code could use a comment to that effect.  See below.

Searching for "jump" in the AMD manual, I see that there are 3 other
instructions that are essentially conditional branches: loop,
loope/loopz, and loopne/loopnz.  They decrement ecx/rcx and then
conditionally branch.  The offset is always 8 bits.

BTW, patches 2 and 3 look fine to me.

> 
> Reported-by: Jonathan Lebon <jlebon@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/uprobes.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 3865d8b..dae02f9 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -591,6 +591,10 @@ static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
>  		auprobe->ttt.opc1 = opc1;
>  		break;
> 
> +	case 0x0f:
> +		if (insn->opcode.nbytes != 2)
> +			return -ENOSYS;
		/*
		 * Map 0f 8x (Jcc with 32-bit displacement) to 7x
		 * (Jcc with 8-bit displacement).  insn lib maps both
		 * to 32 bits.
		 */
> +		opc1 = OPCODE2(insn) - 0x10;
>  	default:
>  		if (!is_cond_jmp_opcode(opc1))
>  			return -ENOSYS;

Jim

