Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbaD3IZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:25:25 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35673 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaD3IZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:25:22 -0400
MIME-Version: 1.0
In-Reply-To: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
Date: Wed, 30 Apr 2014 13:55:21 +0530
X-Google-Sender-Auth: YfVvEW4lt6XqgbjZg40BKhBRMB8
Message-ID: <CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
 cpufreq table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Cc: open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This isn't a very big patchset and this patch is very much required to
understand other patches and so please cc all people from other
list here as well..

On Wed, Apr 30, 2014 at 11:58 AM, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> In the frequency table dts file, the frequencies are arranged in

Improve your logs a bit. Which dts file are you talking about here ?
How would anybody know that you are talking about exynos here?

Also, you shouldn't mention that here, just tell the kind of requirement
platforms may have. i.e. people may want to keep the opp list in the
same order in which it came from DT.

> descending order which maps 1 to 1 with other frequency parameter to
> be calculated and programmed in some registers.
> But the OPP library works by generating the frequencies in ascending
> order which breaks the above logic.
> So added OPP_TABLE_ORDER_DESCEND flag to consider descending order.

So, create three flags:
OPP_TABLE_ORDER_ASCENDING              0
OPP_TABLE_ORDER_DESCENDING            1
OPP_TABLE_ORDER_ORIGINAL                  2 (And use this for your case.)

> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/base/power/opp.c |   17 ++++++++++++++++-
>  include/linux/pm_opp.h   |    7 +++++--
>  2 files changed, 21 insertions(+), 3 deletions(-)

You are changing prototype of a function and so all other files which are using
this routine will break after this patch and we can't afford it as we
want git bisect
to work properly.

So, fix all platforms here in this patch only, i.e. part of 2/3 and
complete 3/3 should
have been merged into this one.

> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index 2553867..ec7d553 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -18,6 +18,7 @@
>  #include <linux/cpufreq.h>
>  #include <linux/device.h>
>  #include <linux/list.h>
> +#include <linux/list_sort.h>
>  #include <linux/rculist.h>
>  #include <linux/rcupdate.h>
>  #include <linux/pm_opp.h>
> @@ -597,10 +598,21 @@ int dev_pm_opp_disable(struct device *dev, unsigned
> long freq)
>  EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
>
>  #ifdef CONFIG_CPU_FREQ
> +
> +static int opp_descend_cmp(void *priv, struct list_head *a,
> +                                        struct list_head *b)
> +{
> +        struct dev_pm_opp *ra = list_entry(a, struct dev_pm_opp, node);
> +        struct dev_pm_opp *rb = list_entry(b, struct dev_pm_opp, node);
> +
> +        return rb->rate - ra->rate;
> +}
> +
>  /**
>   * dev_pm_opp_init_cpufreq_table() - create a cpufreq table for a device
>   * @dev:       device for which we do this operation
>   * @table:     Cpufreq table returned back to caller
> + * @flags:     OPP_TABLE_ORDER_DESCEND or zero
>   *
>   * Generate a cpufreq table for a provided device- this assumes that the
>   * opp list is already initialized and ready for usage.
> @@ -622,7 +634,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
>   * or in contexts where mutex locking cannot be used.
>   */
>  int dev_pm_opp_init_cpufreq_table(struct device *dev,
> -                           struct cpufreq_frequency_table **table)
> +               struct cpufreq_frequency_table **table, unsigned char flags)

You are targeting the wrong routine. Fix of_init_opp_table() instead and
things would work automatically then..

And please don't change prototype of dev_pm_opp_add() for now and
just define __dev_pm_opp_add() which will be called from
dev_pm_opp_add() and of_init_opp_table() with 'int order' parameter.
