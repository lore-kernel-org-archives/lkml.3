Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3LQLpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:45:17 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50828 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab3LQLpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:45:16 -0500
Date: Tue, 17 Dec 2013 11:44:58 +0000
From: Will Deacon <will.deacon@arm.com>
To: "jean.pihet@linaro.org" <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] ARM64: perf: wire up perf_regs and unwind support
Message-ID: <20131217114458.GC7602@mudshark.cambridge.arm.com>
References: <1387212562-8128-1-git-send-email-y>
 <52af2f26.41590e0a.0251.ffffd953@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52af2f26.41590e0a.0251.ffffd953@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 04:49:21PM +0000, jean.pihet@linaro.org wrote:
> From: Jean Pihet <jean.pihet@linaro.org>
> 
> This patch hooks in the perf_regs and libunwind code for ARM64.
> The tools/perf/arch/arm64 is created; it contains the arch specific
> code for DWARF unwinding.
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  tools/perf/arch/arm64/Makefile            |  7 +++
>  tools/perf/arch/arm64/include/perf_regs.h | 88 +++++++++++++++++++++++++++++++
>  tools/perf/arch/arm64/util/dwarf-regs.c   | 81 ++++++++++++++++++++++++++++
>  tools/perf/arch/arm64/util/unwind.c       | 82 ++++++++++++++++++++++++++++
>  tools/perf/config/Makefile                |  8 ++-
>  5 files changed, 265 insertions(+), 1 deletion(-)
>  create mode 100644 tools/perf/arch/arm64/Makefile
>  create mode 100644 tools/perf/arch/arm64/include/perf_regs.h
>  create mode 100644 tools/perf/arch/arm64/util/dwarf-regs.c
>  create mode 100644 tools/perf/arch/arm64/util/unwind.c

[...]

> diff --git a/tools/perf/arch/arm64/include/perf_regs.h b/tools/perf/arch/arm64/include/perf_regs.h
> new file mode 100644
> index 0000000..a8a9683
> --- /dev/null
> +++ b/tools/perf/arch/arm64/include/perf_regs.h
> @@ -0,0 +1,88 @@
> +#ifndef ARCH_PERF_REGS_H
> +#define ARCH_PERF_REGS_H
> +
> +#include <stdlib.h>
> +#include "../../util/types.h"
> +#include <asm/perf_regs.h>
> +
> +#define PERF_REGS_MASK	((1ULL << PERF_REG_ARM_MAX) - 1)
> +#define PERF_REG_IP	PERF_REG_ARM_PC
> +#define PERF_REG_SP	PERF_REG_ARM_SP
> +
> +static inline const char *perf_reg_name(int id)
> +{
> +	switch (id) {
> +	case PERF_REG_ARM_X0:
> +		return "x0";
> +	case PERF_REG_ARM_X1:
> +		return "x1";

[...]

> +	case PERF_REG_ARM_X28:
> +		return "x28";
> +	case PERF_REG_ARM_FP:
> +		return "fp";

Again, I'd just treat this as x29. There's nothing special about the frame
pointer as far as the hardware/architecture is concerned. GAS won't even
accept it as a register name.

> +	case PERF_REG_ARM_SP:
> +		return "sp";
> +	case PERF_REG_ARM_LR:
> +		return "lr";
> +	case PERF_REG_ARM_PC:
> +		return "pc";
> +	default:
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +#endif /* ARCH_PERF_REGS_H */
> diff --git a/tools/perf/arch/arm64/util/dwarf-regs.c b/tools/perf/arch/arm64/util/dwarf-regs.c
> new file mode 100644
> index 0000000..23d319e
> --- /dev/null
> +++ b/tools/perf/arch/arm64/util/dwarf-regs.c
> @@ -0,0 +1,81 @@
> +/*
> + * Mapping of DWARF debug register numbers into register names.
> + *
> + * Copyright (C) 2010 Will Deacon, ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <stddef.h>
> +#include <dwarf-regs.h>
> +
> +struct pt_regs_dwarfnum {
> +	const char *name;
> +	unsigned int dwarfnum;
> +};
> +
> +#define STR(s) #s
> +#define REG_DWARFNUM_NAME(r, num) {.name = r, .dwarfnum = num}
> +#define GPR_DWARFNUM_NAME(num) \
> +	{.name = STR(%r##num), .dwarfnum = num}

Surely you want 'x' instead of 'r'?

> +#define REG_DWARFNUM_END {.name = NULL, .dwarfnum = 0}
> +
> +/*
> + * Reference:
> + * http://infocenter.arm.com/help/topic/com.arm.doc.ihi0057b/IHI0057B_aadwarf64.pdf

So, according to that document...

> + */
> +static const struct pt_regs_dwarfnum regdwarfnum_table[] = {
> +	GPR_DWARFNUM_NAME(0),
> +	GPR_DWARFNUM_NAME(1),
> +	GPR_DWARFNUM_NAME(2),
> +	GPR_DWARFNUM_NAME(3),
> +	GPR_DWARFNUM_NAME(4),
> +	GPR_DWARFNUM_NAME(5),
> +	GPR_DWARFNUM_NAME(6),
> +	GPR_DWARFNUM_NAME(7),
> +	GPR_DWARFNUM_NAME(8),
> +	GPR_DWARFNUM_NAME(9),
> +	GPR_DWARFNUM_NAME(10),
> +	GPR_DWARFNUM_NAME(11),
> +	GPR_DWARFNUM_NAME(12),
> +	GPR_DWARFNUM_NAME(13),
> +	GPR_DWARFNUM_NAME(14),
> +	GPR_DWARFNUM_NAME(15),
> +	GPR_DWARFNUM_NAME(16),
> +	GPR_DWARFNUM_NAME(17),
> +	GPR_DWARFNUM_NAME(18),
> +	GPR_DWARFNUM_NAME(19),
> +	GPR_DWARFNUM_NAME(20),
> +	GPR_DWARFNUM_NAME(21),
> +	GPR_DWARFNUM_NAME(22),
> +	GPR_DWARFNUM_NAME(23),
> +	GPR_DWARFNUM_NAME(24),
> +	GPR_DWARFNUM_NAME(25),
> +	GPR_DWARFNUM_NAME(26),
> +	GPR_DWARFNUM_NAME(27),
> +	GPR_DWARFNUM_NAME(28),
> +	REG_DWARFNUM_NAME("%fp", 29),
> +	REG_DWARFNUM_NAME("%lr", 30),
> +	REG_DWARFNUM_NAME("%sp", 31),
> +	REG_DWARFNUM_NAME("%pc", 32),

...register name 32 is `Reserved'. I don't think we should be using it here.
In fact, the PC isn't even described in that spec. Do we need to expose it
here?

Will
