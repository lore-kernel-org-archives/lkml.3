Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3LTSfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:35:11 -0500
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:59989 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201Ab3LTSfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:35:09 -0500
X-Greylist: delayed 16702 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Dec 2013 13:35:09 EST
Message-ID: <1387564464.3404.106.camel@linaro1.home>
Subject: Re: [PATCH v4 15/16] ARM: add uprobes support
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Dec 2013 18:34:24 +0000
In-Reply-To: <1387166930-13182-16-git-send-email-dave.long@linaro.org>
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
	 <1387166930-13182-16-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Using Rabin Vincent's ARM uprobes patches as a base, enable uprobes
> support on ARM.
> 
> Caveats:
> 
>  - Thumb is not supported
>  - XOL abort/trap handling is not implemented

I shall repeat my comment from version one of the patch...

What are the consequences of this, e.g. is it possible for a probe to
get stuck in an infinite loop of faulting? I hope there are no integrity
issues for the kernel itself.

Would be good if someone familiar with uprobes working could answer
that.

I've a few other comments...

[...]

> +++ b/arch/arm/kernel/uprobes-arm.c
> @@ -0,0 +1,223 @@
> +#include <linux/kernel.h>
> +#include <linux/wait.h>
> +#include <linux/uprobes.h>
> +#include <linux/module.h>
> +
> +#include "probes.h"
> +#include "probes-arm.h"
> +#include "uprobes.h"
> +
> +static int uprobes_substitute_pc(unsigned long *pinsn, u32 oregs)
> +{
> +	probes_opcode_t insn = __mem_to_opcode_arm(*pinsn);
> +	probes_opcode_t temp;
> +	probes_opcode_t mask;
> +	int freereg;
> +	u32 free = 0xffff;
> +	u32 regs;
> +
> +	for (regs = oregs; regs; regs >>= 4, insn >>= 4) {
> +		if ((regs & 0xf) == REG_TYPE_NONE)
> +			continue;
> +
> +		free &= ~(1 << (insn & 0xf));
> +	}
> +
> +	/* No PC, no problem */
> +	if (free & (1 << 15))
> +		return 15;
> +
> +	if (!free)
> +		return -1;
> +
> +	/*
> +	 * fls instead of ffs ensures that for "ldrd r0, r1, [pc]" we would
> +	 * pick LR instead of R1.

Do we know why this is desirable, i.e. preferring the higher numbered
registers? If there isn't a preference, then no need for comment really.

Also, the comment as is is wrong, should be "...pick LR instead of R2"
because R1 wouldn't be chosen as the instruction already uses it.

> +	 */
> +	freereg = free = fls(free) - 1;
> +
> +

[...]


> +const union decode_item uprobes_probes_actions[] = {
> +	[PROBES_EMULATE_NONE] {.handler = probes_simulate_nop},

There is a missing '=' in the line above. Interesting that GCC doesn't
complain (I tried compiling this patch and it didn't).

> +	[PROBES_SIMULATE_NOP] = {.handler = probes_simulate_nop},
> +	[PROBES_PRELOAD_IMM] = {.handler = probes_simulate_nop},
> +	[PROBES_PRELOAD_REG] = {.handler = probes_simulate_nop},
> +	[PROBES_BRANCH_IMM] = {.handler = simulate_blx1},
> +	[PROBES_MRS] = {.handler = simulate_mrs},
> +	[PROBES_BRANCH_REG] = {.handler = simulate_blx2bx},
> +	[PROBES_CLZ] = {.handler = probes_simulate_nop},
> +	[PROBES_SATURATING_ARITHMETIC] = {.handler = probes_simulate_nop},
> +	[PROBES_MUL1] = {.handler = probes_simulate_nop},
> +	[PROBES_MUL2] = {.handler = probes_simulate_nop},
> +	[PROBES_SWP] = {.handler = probes_simulate_nop},
> +	[PROBES_LDRSTRD] = {.decoder = decode_pc_ro},
> +	[PROBES_LOAD_EXTRA] = {.decoder = decode_pc_ro},
> +	[PROBES_LOAD] = {.decoder = decode_ldr},
> +	[PROBES_STORE_EXTRA] = {.decoder = decode_pc_ro},
> +	[PROBES_STORE] = {.decoder = decode_pc_ro},
> +	[PROBES_MOV_IP_SP] = {.handler = simulate_mov_ipsp},
> +	[PROBES_DATA_PROCESSING_REG] = {
> +		.decoder = decode_rd12rn16rm0rs8_rwflags},
> +	[PROBES_DATA_PROCESSING_IMM] = {
> +		.decoder = decode_rd12rn16rm0rs8_rwflags},
> +	[PROBES_MOV_HALFWORD] = {.handler = probes_simulate_nop},
> +	[PROBES_SEV] = {.handler = probes_simulate_nop},
> +	[PROBES_WFE] = {.handler = probes_simulate_nop},
> +	[PROBES_SATURATE] = {.handler = probes_simulate_nop},
> +	[PROBES_REV] = {.handler = probes_simulate_nop},
> +	[PROBES_MMI] = {.handler = probes_simulate_nop},
> +	[PROBES_PACK] = {.handler = probes_simulate_nop},
> +	[PROBES_EXTEND] = {.handler = probes_simulate_nop},
> +	[PROBES_EXTEND_ADD] = {.handler = probes_simulate_nop},
> +	[PROBES_MUL_ADD_LONG] = {.handler = probes_simulate_nop},
> +	[PROBES_MUL_ADD] = {.handler = probes_simulate_nop},
> +	[PROBES_BITFIELD] = {.handler = probes_simulate_nop},
> +	[PROBES_BRANCH] = {.handler = simulate_bbl},
> +	[PROBES_LDMSTM] = {.decoder = uprobe_decode_ldmstm}
> +};
> diff --git a/arch/arm/kernel/uprobes.c b/arch/arm/kernel/uprobes.c
> new file mode 100644
> index 0000000..ae18549
> --- /dev/null
> +++ b/arch/arm/kernel/uprobes.c

[...]

> +bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	void *addr;

'addr' is not used so this line can be deleted

> +	probes_opcode_t opcode;
> +
> +	if (!auprobe->simulate)
> +		return false;
> +
> +	addr = (void *) regs->ARM_pc;

and so can this line ^^^

> +	opcode = __mem_to_opcode_arm(*(unsigned int *) auprobe->insn);
> +
> +	auprobe->asi.insn_singlestep(opcode, &auprobe->asi, regs);
> +
> +	return true;
> +}
> +

[rest of patch snipped]

-- 
Tixy

