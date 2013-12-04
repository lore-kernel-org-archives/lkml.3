Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab3LDPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:25:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab3LDPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:25:27 -0500
Date: Wed, 4 Dec 2013 07:26:31 -0800
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
Subject: Re: [PATCH 2/3] ARM Coresight: Add address control support for ETM
Message-ID: <20131204152630.GB12847@kroah.com>
References: <CANsc=4WgVs413LmWh6Ms_eb_GGNbuiRZUkBeGiS_VtG2VwLpaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANsc=4WgVs413LmWh6Ms_eb_GGNbuiRZUkBeGiS_VtG2VwLpaQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:40:25PM -0500, Adrien Vergé wrote:
> In the same manner as for enabling tracing, an entry is created
> in sysfs to set the address range that triggers tracing.
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
>  arch/arm/kernel/etm.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
> index bd7e8e4..a72382b 100644
> --- a/arch/arm/kernel/etm.c
> +++ b/arch/arm/kernel/etm.c
> @@ -44,6 +44,8 @@ struct tracectx {
>   struct device *dev;
>   struct clk *emu_clk;
>   struct mutex mutex;
> + unsigned long addrrange_start;
> + unsigned long addrrange_end;
>  };

All of the tabs were eaten by your email client, making this patch
impossible to apply to anything :(

> @@ -53,6 +55,13 @@ static inline bool trace_isrunning(struct tracectx *t)
>   return !!(t->flags & TRACER_RUNNING);
>  }
> 
> +/*
> + * Setups ETM to trace only when:
> + *   - address between start and end
> + *     or address not between start and end (if exclude)
> + *   - trace executed instructions
> + *     or trace loads and stores (if data)
> + */
>  static int etm_setup_address_range(struct tracectx *t, int n,
>   unsigned long start, unsigned long end, int exclude, int data)
>  {
> @@ -115,8 +124,8 @@ static int trace_start(struct tracectx *t)
>   return -EFAULT;
>   }
> 
> - etm_setup_address_range(t, 1, (unsigned long)_stext,
> - (unsigned long)_etext, 0, 0);
> + etm_setup_address_range(t, 1, t->addrrange_start, t->addrrange_end,
> + 0, 0);
>   etm_writel(t, 0, ETMR_TRACEENCTRL2);
>   etm_writel(t, 0, ETMR_TRACESSCTRL);
>   etm_writel(t, 0x6f, ETMR_TRACEENEVT);
> @@ -532,6 +541,37 @@ static ssize_t trace_mode_store(struct kobject *kobj,
>  static struct kobj_attribute trace_mode_attr =
>   __ATTR(trace_mode, 0644, trace_mode_show, trace_mode_store);
> 
> +static ssize_t trace_addrrange_show(struct kobject *kobj,
> +    struct kobj_attribute *attr,
> +    char *buf)
> +{
> + return sprintf(buf, "%08lx - %08lx\n", tracer.addrrange_start,
> +       tracer.addrrange_end);
> +}

None of these should be "kobject" attributes, but rather, device
attributes.

Yes, I know you didn't create this mess, but it needs to be cleaned up.

All of these need to be moved to use the correct kernel apis, and
kobject attributes are not the correct ones.

What's wrong with the in-kernel tracing api?  Why do we have some other
random tracing api and character device stuck in an arch specific
directory where no one has ever looked at it, and it's not even
documented in Documentation/ABI/ like it is supposed to be?

In my opinion, this "driver" needs to be deleted or massively cleaned
up, as it's the wrong api for the functionality it is trying to provide.

greg k-h
