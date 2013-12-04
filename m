Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab3LDPrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:47:52 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:64764 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab3LDPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:47:50 -0500
MIME-Version: 1.0
In-Reply-To: <1386088753-2850-3-git-send-email-hanjun.guo@linaro.org>
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
	<1386088753-2850-3-git-send-email-hanjun.guo@linaro.org>
Date: Wed, 4 Dec 2013 09:47:49 -0600
Message-ID: <CAL_JsqKF-_GCRR1d5Hs0F6pCMfLxUYkXAAp9hY7Ywuu1C+aZ0A@mail.gmail.com>
Subject: Re: [RFC part2 PATCH 2/9] ARM64 / ACPI: Prefill cpu possible/present
 maps and map logical cpu id to APIC id
From: Rob Herring <robherring2@gmail.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Linaro Patches <patches@linaro.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 10:39 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> When boot the kernel with MADT, the cpu possible and present maps should be
> prefilled for cpu topology and acpi based cpu hot-plug.
>
> The logic cpu id maps to APIC id (GIC id) is also implemented, it is needed
> for acpi processor drivers.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/include/asm/acpi.h |   10 ++--
>  arch/arm64/kernel/setup.c     |    2 +
>  arch/arm64/kernel/smp.c       |    2 +
>  drivers/acpi/plat/arm-core.c  |  118 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 129 insertions(+), 3 deletions(-)

[snip]

> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index a0c2ca6..1428024 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -420,7 +420,9 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>                 if (err)
>                         continue;
>
> +#ifndef CONFIG_ACPI
>                 set_cpu_present(cpu, true);
> +#endif

Should this be moved to DT cpu topology related code?

>                 max_cpus--;
>         }
>  }
> diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
> index 45ff625..8527ecc 100644
> --- a/drivers/acpi/plat/arm-core.c
> +++ b/drivers/acpi/plat/arm-core.c

[snip]

> @@ -221,6 +284,61 @@ static int __init acpi_parse_madt_gic_distributor_entries(void)
>         return 0;
>  }
>
> +static int setup_possible_cpus __initdata = -1;
> +static int __init _setup_possible_cpus(char *str)
> +{
> +       get_option(&str, &setup_possible_cpus);
> +       return 0;
> +}
> +early_param("possible_cpus", _setup_possible_cpus);

This does not seem ACPI or ARM specific.

> +
> +/*
> + * cpu_possible_mask should be static, it cannot change as cpu's
> + * are onlined, or offlined. The reason is per-cpu data-structures
> + * are allocated by some modules at init time, and dont expect to
> + * do this dynamically on cpu arrival/departure.
> + * cpu_present_mask on the other hand can change dynamically.
> + * In case when cpu_hotplug is not compiled, then we resort to current
> + * behaviour, which is cpu_possible == cpu_present.
> + * - Ashok Raj
> + *
> + * Three ways to find out the number of additional hotplug CPUs:
> + * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
> + * - The user can overwrite it with possible_cpus=NUM
> + * - Otherwise don't reserve additional CPUs.
> + * We do this because additional CPUs waste a lot of memory.
> + * -AK
> + */
> +void __init prefill_possible_map(void)
> +{
> +       int i;
> +       int possible, disabled_cpus;
> +
> +       disabled_cpus = total_cpus - available_cpus;
> +
> +       if (setup_possible_cpus == -1) {
> +               if (disabled_cpus > 0)
> +                       setup_possible_cpus = disabled_cpus;
> +               else
> +                       setup_possible_cpus = 0;
> +       }
> +
> +       possible = available_cpus + setup_possible_cpus;
> +
> +       pr_info("SMP: the system is limited to %d CPUs\n", nr_cpu_ids);
> +
> +       if (possible > nr_cpu_ids)
> +               possible = nr_cpu_ids;
> +
> +       pr_info("SMP: Allowing %d CPUs, %d hotplug CPUs\n",
> +               possible, max((possible - available_cpus), 0));
> +
> +       for (i = 0; i < possible; i++)
> +               set_cpu_possible(i, true);
> +       for (; i < NR_CPUS; i++)
> +               set_cpu_possible(i, false);
> +}

This does not seem ACPI or ARM specific either.

Rob
