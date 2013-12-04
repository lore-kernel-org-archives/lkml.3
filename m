Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab3LDRXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:23:08 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61305 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab3LDRXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:23:06 -0500
Message-ID: <529F64F6.6010209@linaro.org>
Date: Wed, 04 Dec 2013 19:23:02 +0200
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Long <dave.long@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
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
Subject: Re: [PATCH v3 14/15] ARM: add uprobes support
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org> <1385520814-10663-15-git-send-email-dave.long@linaro.org>
In-Reply-To: <1385520814-10663-15-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 04:53 AM, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Using Rabin Vincent's ARM uprobes patches as a base, enable uprobes
> support on ARM.
> 
> Caveats:
> 
>  - Thumb is not supported
>  - XOL abort/trap handling is not implemented
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---
>  arch/arm/Kconfig                   |   4 +
>  arch/arm/include/asm/ptrace.h      |   6 +
>  arch/arm/include/asm/thread_info.h |   5 +-
>  arch/arm/include/asm/uprobes.h     |  34 ++++++
>  arch/arm/kernel/Makefile           |   1 +
>  arch/arm/kernel/signal.c           |   4 +
>  arch/arm/kernel/uprobes-arm.c      | 223 +++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/uprobes.c          | 198 ++++++++++++++++++++++++++++++++
>  arch/arm/kernel/uprobes.h          |  27 +++++
>  9 files changed, 501 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/include/asm/uprobes.h
>  create mode 100644 arch/arm/kernel/uprobes-arm.c
>  create mode 100644 arch/arm/kernel/uprobes.c
>  create mode 100644 arch/arm/kernel/uprobes.h
> 

[snip]

> diff --git a/arch/arm/kernel/uprobes-arm.c b/arch/arm/kernel/uprobes-arm.c
> new file mode 100644
> index 0000000..0a83ad7
> --- /dev/null
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
> +	probes_opcode_t insn = *pinsn;

In a current implementation pinsn points to an ixol field of arch_uprobe
structure, which has native endianness and is written via
__opcode_to_mem_arm() macro in arch_uprobe_analyze_insn() function.
So *pinsn should be wrapped with __opcode_to_mem_arm/__mem_to_opcode_arm()
macros in this function.

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
> +	 */
> +	freereg = free = fls(free) - 1;
> +
> +	temp = *pinsn;
> +	insn = *pinsn;
> +	regs = oregs;
> +	mask = 0xf;
> +
> +	for (; regs; regs >>= 4, mask <<= 4, free <<= 4, temp >>= 4) {
> +		if ((regs & 0xf) == REG_TYPE_NONE)
> +			continue;
> +
> +		if ((temp & 0xf) != 15)
> +			continue;
> +
> +		insn &= ~mask;
> +		insn |= free & mask;
> +	}
> +
> +	*pinsn = insn;
> +	return freereg;
> +}
> +

[snip]

> +
> +enum probes_insn
> +uprobe_decode_ldmstm(probes_opcode_t insn,
> +		     struct arch_specific_insn *asi, struct decode_header *d)
> +{
> +	struct arch_uprobe *auprobe = container_of(asi, struct arch_uprobe,
> +						   asi);
> +	unsigned reglist = insn & 0xffff;
> +	int rn = (insn >> 16) & 0xf;
> +	int lbit = insn & (1 << 20);
> +	unsigned used = reglist | (1 << rn);
> +
> +	if (rn == 15)
> +		return INSN_REJECTED;
> +
> +	if (!(used & (1 << 15)))
> +		return INSN_GOOD;
> +
> +	if (used & (1 << 14))
> +		return INSN_REJECTED;
> +
> +	/* Use LR instead of PC */
> +	insn ^= 0xc000;
> +
> +	auprobe->pcreg = 14;
> +	auprobe->ixol[0] = insn;

insn contains canonical opcode, but ixol should contain
an opcode in native endianness. So it should be

auprobe->ixol[0] = __opcode_to_mem_arm(insn);

> +
> +	auprobe->prehandler = uprobe_set_pc;
> +	if (lbit)
> +		auprobe->posthandler = uprobe_write_pc;
> +	else
> +		auprobe->posthandler = uprobe_unset_pc;
> +
> +	return INSN_GOOD;
> +}
> +


-- 
Taras Kondratiuk
