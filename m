Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3DYIsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:48:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60279 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929Ab3DYIsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:48:01 -0400
Date: Thu, 25 Apr 2013 09:47:11 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH v8 1/2] arm: introduce psci_smp_ops
Message-ID: <20130425084711.GA12848@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.02.1304241935010.4180@kaball.uk.xensource.com>
 <1366828819-10745-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366828819-10745-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On Wed, Apr 24, 2013 at 07:40:18PM +0100, Stefano Stabellini wrote:
> Rename virt_smp_ops to psci_smp_ops and move them to arch/arm/kernel/psci_smp.c.
> Remove mach-virt/platsmp.c, now unused.
> Compile psci_smp if CONFIG_ARM_PSCI and CONFIG_SMP.
> 
> Add a cpu_die smp_op based on psci_ops.cpu_off.
> 
> Initialize PSCI before setting smp_ops in setup_arch.
> Use psci_smp_ops if the platform doesn't provide its own smp_ops.
> 
> If PSCI is available on the platform, prefer psci_smp_ops over the
> platform smp_ops.
> 
> Changes in v8:
> - merge "prefer psci_smp_ops over mdesc->smp" into this patch.
> 
> Changes in v6:
> - fixed return values for psci_smp_available and psci_init ifndef
> CONFIG_ARM_PSCI.
> 
> Changes in v5:
> - document psci_operations;
> - psci_init returns NULL.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/include/asm/psci.h  |   29 ++++++++++++++++++
>  arch/arm/kernel/Makefile     |    5 ++-
>  arch/arm/kernel/psci.c       |    7 ++--
>  arch/arm/kernel/psci_smp.c   |   67 ++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/setup.c      |    7 ++++-
>  arch/arm/mach-virt/Makefile  |    1 -
>  arch/arm/mach-virt/platsmp.c |   58 ------------------------------------
>  arch/arm/mach-virt/virt.c    |    3 --
>  8 files changed, 109 insertions(+), 68 deletions(-)
>  create mode 100644 arch/arm/kernel/psci_smp.c
>  delete mode 100644 arch/arm/mach-virt/platsmp.c
> 
> diff --git a/arch/arm/include/asm/psci.h b/arch/arm/include/asm/psci.h
> index ce0dbe7..fa44417 100644
> --- a/arch/arm/include/asm/psci.h
> +++ b/arch/arm/include/asm/psci.h
> @@ -23,6 +23,26 @@ struct psci_power_state {
>  	u8	affinity_level;
>  };
>  
> +/*
> + * cpu_suspend   Suspend the execution on a CPU
> + * @state        we don't currently describe affinity levels, so just pass 0.
> + * @entry_point  the first instruction to be executed on return
> + * returns 0  success, < 0 on failure
> + *
> + * cpu_off       Power down a CPU
> + * @state        we don't currently describe affinity levels, so just pass 0.
> + * no return on successful call
> + *
> + * cpu_on        Power up a CPU
> + * @cpuid        cpuid of target CPU, as from MPIDR
> + * @entry_point  the first instruction to be executed on return
> + * returns 0  success, < 0 on failure
> + *
> + * migrate       Migrate the context to a different CPU
> + * @cpuid        cpuid of target CPU, as from MPIDR
> + * returns 0  success, < 0 on failure
> + *
> + */

Can you move these comments into psci-smp.c please? They're really specific
to the implementation there, and if we put them in a header we're lying to
ourselves about the parameters actually described by the PSCI specification.

With that change:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
