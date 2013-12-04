Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab3LDRFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:05:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556Ab3LDRFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:05:39 -0500
Date: Wed, 4 Dec 2013 09:05:38 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Adrien =?iso-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Will Deacon <will.deacon@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 3/3] ARM Coresight: Add PID control support for ETM
 tracing
Message-ID: <20131204170538.GA14773@kroah.com>
References: <CANsc=4Vy911xcf7fYEjyeV_CNGp8POje9BZrLSP8xrk4YAfSNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANsc=4Vy911xcf7fYEjyeV_CNGp8POje9BZrLSP8xrk4YAfSNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:40:59PM -0500, Adrien Vergé wrote:
> In the same manner as for enabling tracing, an entry is created in
> sysfs to set the PID that triggers tracing. This change requires
> CONFIG_PID_IN_CONTEXTIDR to be set when using on-chip ETM.
> 
> Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Ben Dooks <ben.dooks@codethink.co.uk>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> ---
>  arch/arm/Kconfig.debug                    |  1 +
>  arch/arm/include/asm/hardware/coresight.h |  3 ++
>  arch/arm/kernel/etm.c                     | 73 ++++++++++++++++++++++++++++---
>  3 files changed, 70 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 5765abf..fef32e15 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -1130,6 +1130,7 @@ config EARLY_PRINTK
>  config OC_ETM
>   bool "On-chip ETM and ETB"
>   depends on ARM_AMBA
> + select PID_IN_CONTEXTIDR
>   help
>    Enables the on-chip embedded trace macrocell and embedded trace
>    buffer driver that will allow you to collect traces of the
> diff --git a/arch/arm/include/asm/hardware/coresight.h
> b/arch/arm/include/asm/hardware/coresight.h
> index 8c50cf6..009cdf9 100644
> --- a/arch/arm/include/asm/hardware/coresight.h
> +++ b/arch/arm/include/asm/hardware/coresight.h
> @@ -98,6 +98,9 @@
>  #define ETMR_ADDRCOMP_VAL(x) (0x40 + (x) * 4)
>  #define ETMR_ADDRCOMP_ACC_TYPE(x) (0x80 + (x) * 4)
> 
> +#define ETMR_CTXIDCOMP_VAL(x) (0x1b0 + (x) * 4)
> +#define ETMR_CTXIDCOMP_MASK (0x1bc)
> +
>  /* ETM status register, "ETM Architecture", 3.3.2 */
>  #define ETMR_STATUS (0x10)
>  #define ETMST_OVERFLOW BIT(0)
> diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
> index a72382b..18afed1 100644
> --- a/arch/arm/kernel/etm.c
> +++ b/arch/arm/kernel/etm.c
> @@ -40,12 +40,14 @@ struct tracectx {
>   void __iomem *etm_regs;
>   unsigned long flags;
>   int naddrcmppairs;
> + int nctxidcmp;
>   int etm_portsz;
>   struct device *dev;
>   struct clk *emu_clk;
>   struct mutex mutex;
>   unsigned long addrrange_start;
>   unsigned long addrrange_end;
> + long pid;

pid is not a long, your code is totally broken for pid namespaces, and
really, I don't know how you would fix it given that you don't have a
way to specify the pid namespace with this interface.

sorry,

greg k-h
