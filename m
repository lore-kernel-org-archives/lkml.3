Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3KQP7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 10:59:35 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54391 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3KQP7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 10:59:25 -0500
MIME-Version: 1.0
In-Reply-To: <1384678169-28228-1-git-send-email-acourbot@nvidia.com>
References: <1384678169-28228-1-git-send-email-acourbot@nvidia.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Sun, 17 Nov 2013 15:59:04 +0000
X-Google-Sender-Auth: aUgvThBbfNWuwjdqaYpz5IUuzHA
Message-ID: <CAHkRjk5LBOFx3ir49RgEsaFwvp5UCpTjYFWto+URXebAsOP0RA@mail.gmail.com>
Subject: Re: [PATCH] ARM: move firmware_ops to drivers/firmware
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 November 2013 08:49, Alexandre Courbot <acourbot@nvidia.com> wrote:
> The ARM tree includes a firmware_ops interface that is designed to
> implement support for simple, TrustZone-based firmwares but could
> also cover other use-cases. It has been suggested that this
> interface might be useful to other architectures (e.g. arm64) and
> that it should be moved out of arch/arm.

NAK. I'm for code sharing with arm via common locations but this API
goes against the ARMv8 firmware standardisation efforts like PSCI,
encouraging each platform to define there own non-standard interface.

> --- /dev/null
> +++ b/include/linux/platform_firmware.h
> @@ -0,0 +1,69 @@
> +/*
> + * Copyright (C) 2012 Samsung Electronics.
> + * Kyungmin Park <kyungmin.park@samsung.com>
> + * Tomasz Figa <t.figa@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef _PLATFORM_FIRMWARE_H
> +#define _PLATFORM_FIRMWARE_H
> +
> +#include <linux/bug.h>
> +
> +/*
> + * struct platform_firmware_ops
> + *
> + * A structure to specify available firmware operations.
> + *
> + * A filled up structure can be registered with
> + * register_platform_firmware_ops().
> + */
> +struct platform_firmware_ops {
> +       /*
> +        * Enters CPU idle mode
> +        */
> +       int (*do_idle)(void);

Covered by PSCI already.

> +       /*
> +        * Sets boot address of specified physical CPU
> +        */
> +       int (*set_cpu_boot_addr)(int cpu, unsigned long boot_addr);

Covered either by PSCI or spin-table release method (PSCI if firmware
call is required).

> +       /*
> +        * Boots specified physical CPU
> +        */
> +       int (*cpu_boot)(int cpu);

PSCI.

> +       /*
> +        * Initializes L2 cache
> +        */
> +       int (*l2x0_init)(void);

No L2x0 (L210, L220, PL310) cache on ARMv8. And here I strongly
recommend the hardware people to make proper external caches which can
be flushed by standard CPU instructions, not MMIO. Any such caches
must be enabled by firmware before Linux starts.

The above firmware API is 32-bit ARM only. Form 64-bit ARM, you have
the choice of PSCI so far but as I said in a long thread to Nico, I'm
open to other standard interfaces if there are good reasons PSCI
cannot be used. Note the _standard_ part, I don't want every SoC with
their own firmware API for standard things like secondary CPU
booting/hotplug/idle.

-- 
Catalin
