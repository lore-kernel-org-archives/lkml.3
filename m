Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbbAWMct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:32:49 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:44114 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753026AbbAWMcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:32:46 -0500
From: Punit Agrawal <punit.agrawal@arm.com>
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, leo.yan@linaro.org, yexl@marvell.com,
        Will.Deacon@arm.com, Catalin.Marinas@arm.com, Mark.Rutland@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] arm64: Consolidate hotplug notifier for instruction emulation
References: <1421844191-9263-1-git-send-email-suzuki.poulose@arm.com>
	<1421844191-9263-2-git-send-email-suzuki.poulose@arm.com>
	<1421844191-9263-3-git-send-email-suzuki.poulose@arm.com>
Date: Fri, 23 Jan 2015 12:31:40 +0000
In-Reply-To: <1421844191-9263-3-git-send-email-suzuki.poulose@arm.com> (Suzuki
	K. Poulose's message of "Wed, 21 Jan 2015 12:43:10 +0000")
Message-ID: <9hhoappn0er.fsf@e105922-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suzuki,

A possible simplification below.

"Suzuki K. Poulose" <suzuki.poulose@arm.com> writes:

> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
>
> As of now each insn_emulation has a cpu hotplug notifier that
> enables/disables the CPU feature bit for the functionality. This
> patch re-arranges the code, such that there is only one notifier
> that runs through the list of registered emulation hooks and runs
> their corresponding set_hw_mode.
>
> We do nothing when a CPU is dying as we will set the appropriate bits
> as it comes back online based on the state of the hooks.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Punit Agrawal <punit.agrawal@arm.com>
> ---
>  arch/arm64/include/asm/cputype.h     |    2 +
>  arch/arm64/kernel/armv8_deprecated.c |  125 +++++++++++++++++++++-------------
>  2 files changed, 79 insertions(+), 48 deletions(-)
>

[...]

> diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
> index c363671..2c991f1 100644
> --- a/arch/arm64/kernel/armv8_deprecated.c
> +++ b/arch/arm64/kernel/armv8_deprecated.c
> @@ -19,6 +19,7 @@
>  #include <asm/system_misc.h>
>  #include <asm/traps.h>
>  #include <asm/uaccess.h>
> +#include <asm/cpufeature.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include "trace-events-emulation.h"
> @@ -85,6 +86,57 @@ static void remove_emulation_hooks(struct insn_emulation_ops *ops)
>  	pr_notice("Removed %s emulation handler\n", ops->name);
>  }
>  
> +static void enable_insn_hw_mode(void *data)
> +{
> +	struct insn_emulation *insn = (struct insn_emulation *)data;
> +	if (insn && insn->ops->set_hw_mode)

You can simplify (drop?) this...

> +		insn->ops->set_hw_mode(true);
> +}
> +
> +static void disable_insn_hw_mode(void *data)
> +{
> +	struct insn_emulation *insn = (struct insn_emulation *)data;
> +	if (insn && insn->ops->set_hw_mode)

and this check since...

> +		insn->ops->set_hw_mode(false);
> +}
> +
> +/* Run set_hw_mode(mode) on all active CPUs */
> +static int run_all_cpu_set_hw_mode(struct insn_emulation *insn, bool enable)
> +{
> +	if (!insn->ops->set_hw_mode)
> +		return -EINVAL;

insn->ops->set_hw_mode is already checked here.

> +	if (enable)
> +		on_each_cpu(enable_insn_hw_mode, (void *)insn, true);
> +	else
> +		on_each_cpu(disable_insn_hw_mode, (void *)insn, true);
> +	return 0;
> +}
> +
> +/*
> + * Run set_hw_mode for all insns on a starting CPU.
> + * Returns:
> + *  0 		- If all the hooks ran successfully.
> + * -EINVAL	- At least one hook is not supported by the CPU.
> + */
> +static int run_all_insn_set_hw_mode(unsigned long cpu)
> +{
> +	int rc = 0;
> +	unsigned long flags;
> +	struct insn_emulation *insn;
> +
> +	raw_spin_lock_irqsave(&insn_emulation_lock, flags);
> +	list_for_each_entry(insn, &insn_emulation, node) {
> +		bool enable = (insn->current_mode == INSN_HW);
> +		if (insn->ops->set_hw_mode && insn->ops->set_hw_mode(enable)) {
> +			pr_warn(enable, "CPU[%ld] cannot support the emulation of %s",
> +							cpu, insn->ops->name);
> +			rc = -EINVAL;
> +		}
> +	}
> +	raw_spin_unlock_irqrestore(&insn_emulation_lock, flags);
> +	return rc;
> +}
> +
>  static int update_insn_emulation_mode(struct insn_emulation *insn,
>  				       enum insn_emulation_mode prev)
>  {

[...]

