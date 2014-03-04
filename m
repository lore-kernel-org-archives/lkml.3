Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbaCDHup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:50:45 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:42052 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbaCDHun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:50:43 -0500
MIME-Version: 1.0
In-Reply-To: <1393840403-26639-2-git-send-email-jean.pihet@linaro.org>
References: <1393840403-26639-1-git-send-email-jean.pihet@linaro.org>
	<1393840403-26639-2-git-send-email-jean.pihet@linaro.org>
Date: Tue, 4 Mar 2014 08:50:43 +0100
Message-ID: <CAFrcx1nBhu6jkcdpOu8POOk95MtDH5vjtFy92=9MGdVgEknzLg@mail.gmail.com>
Subject: Re: [PATCH 1/3] perf tests: Introduce perf_regs_load function on ARM
From: Jean Pihet <jean.pihet@linaro.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Steve Capper <steve.capper@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new version is coming asap after a review of the code with Steve.

Thx,
Jean

On 3 March 2014 10:53, Jean Pihet <jean.pihet@linaro.org> wrote:
> Introducing perf_regs_load function, which is going
> to be used for dwarf unwind test in following patches.
>
> It takes single argument as a pointer to the regs dump
> buffer and populates it with current registers values.
>
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/arch/arm/Makefile            |  1 +
>  tools/perf/arch/arm/include/perf_regs.h |  2 ++
>  tools/perf/arch/arm/tests/regs_load.S   | 51 +++++++++++++++++++++++++++++++++
>  3 files changed, 54 insertions(+)
>  create mode 100644 tools/perf/arch/arm/tests/regs_load.S
>
> diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
> index 67e9b3d..9b8f87e 100644
> --- a/tools/perf/arch/arm/Makefile
> +++ b/tools/perf/arch/arm/Makefile
> @@ -4,4 +4,5 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
>  endif
>  ifndef NO_LIBUNWIND
>  LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
> +LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
>  endif
> diff --git a/tools/perf/arch/arm/include/perf_regs.h b/tools/perf/arch/arm/include/perf_regs.h
> index 2a1cfde..1476ae7 100644
> --- a/tools/perf/arch/arm/include/perf_regs.h
> +++ b/tools/perf/arch/arm/include/perf_regs.h
> @@ -5,6 +5,8 @@
>  #include "../../util/types.h"
>  #include <asm/perf_regs.h>
>
> +void perf_regs_load(u64 *regs);
> +
>  #define PERF_REGS_MASK ((1ULL << PERF_REG_ARM_MAX) - 1)
>  #define PERF_REG_IP    PERF_REG_ARM_PC
>  #define PERF_REG_SP    PERF_REG_ARM_SP
> diff --git a/tools/perf/arch/arm/tests/regs_load.S b/tools/perf/arch/arm/tests/regs_load.S
> new file mode 100644
> index 0000000..241c6df
> --- /dev/null
> +++ b/tools/perf/arch/arm/tests/regs_load.S
> @@ -0,0 +1,51 @@
> +#include <linux/linkage.h>
> +
> +#define R0 0x00
> +#define R1 0x08
> +#define R2 0x10
> +#define R3 0x18
> +#define R4 0x20
> +#define R5 0x28
> +#define R6 0x30
> +#define R7 0x38
> +#define R8 0x40
> +#define R9 0x48
> +#define SL 0x50
> +#define FP 0x58
> +#define IP 0x60
> +#define SP 0x68
> +#define LR 0x70
> +#define PC 0x78
> +
> +@ Implementation of void perf_regs_load(u64 *regs);
> +@
> +@ This functions fills in the 'regs' buffer from the actual registers values.
> +@ Note that the return values (i.e. caller values) of sp and lr
> +@ are retrieved and stored, in order to skip the call to this function.
> +
> +.text
> +.type perf_regs_load,%function
> +ENTRY(perf_regs_load)
> +       push {r1}
> +
> +       str r0, [r0, #R0]
> +       str r1, [r0, #R1]
> +       str r2, [r0, #R2]
> +       str r3, [r0, #R3]
> +       str r4, [r0, #R4]
> +       str r5, [r0, #R5]
> +       str r6, [r0, #R6]
> +       str r7, [r0, #R7]
> +       str r8, [r0, #R8]
> +       str r9, [r0, #R9]
> +       str sl, [r0, #SL]
> +       str fp, [r0, #FP]
> +       str ip, [r0, #IP]
> +       add r1, sp, #4          @ Retrieve and save sp at entry time
> +       str r1, [r0, #SP]
> +       str lr, [r0, #LR]
> +       str lr, [r0, #PC]       @ Save caller PC
> +
> +       pop {r1}
> +       bx lr
> +ENDPROC(perf_regs_load)
> --
> 1.7.11.7
>
