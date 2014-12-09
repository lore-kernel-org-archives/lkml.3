Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaLIHTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:19:12 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:33558 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaLIHTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:19:09 -0500
MIME-Version: 1.0
In-Reply-To: <1417786892-477-3-git-send-email-amerilainen@nvidia.com>
References: <1417786892-477-1-git-send-email-amerilainen@nvidia.com> <1417786892-477-3-git-send-email-amerilainen@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 9 Dec 2014 16:18:48 +0900
Message-ID: <CAAVeFuLZsbmzjOZw3Y2KnPCQvGuN2P-Ax4ZqHT4QTi-=RM=gcQ@mail.gmail.com>
Subject: Re: [RFC RESEND 2/3] PM / devfreq: Add watermark simple governor
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, srasal@nvidia.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 10:41 PM, Arto Merilainen <amerilainen@nvidia.com> wrote:
> From: Shridhar Rasal <srasal@nvidia.com>
>
> This patch adds a new devfreq governor, watermark simple. The
> governor decides next frequency naively by selecting the previous
> frequency in the frequency table if we received low watermark
> - or the next frequency in case we received high watermark.
>
> Signed-off-by: Shridhar Rasal <srasal@nvidia.com>
> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
> ---
>  drivers/devfreq/Kconfig                 |   7 +
>  drivers/devfreq/Makefile                |   1 +
>  drivers/devfreq/governor_wmark_simple.c | 245 ++++++++++++++++++++++++++++++++
>  3 files changed, 253 insertions(+)
>  create mode 100644 drivers/devfreq/governor_wmark_simple.c
>
> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
> index faf4e70c42e0..37710d999ffe 100644
> --- a/drivers/devfreq/Kconfig
> +++ b/drivers/devfreq/Kconfig
> @@ -63,6 +63,13 @@ config DEVFREQ_GOV_USERSPACE
>           Otherwise, the governor does not change the frequnecy
>           given at the initialization.
>
> +config DEVFREQ_GOV_WMARK_SIMPLE
> +       tristate "Simple Watermark"
> +       help
> +         Sets the frequency based on monitor watermark events.
> +         This governor returns the next frequency from frequency table
> +         based on type watermark event.
> +
>  comment "DEVFREQ Drivers"
>
>  config ARM_EXYNOS4_BUS_DEVFREQ
> diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
> index 16138c9e0d58..92024eeb73b6 100644
> --- a/drivers/devfreq/Makefile
> +++ b/drivers/devfreq/Makefile
> @@ -3,6 +3,7 @@ obj-$(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)       += governor_simpleondemand.o
>  obj-$(CONFIG_DEVFREQ_GOV_PERFORMANCE)  += governor_performance.o
>  obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)    += governor_powersave.o
>  obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)    += governor_userspace.o
> +obj-$(CONFIG_DEVFREQ_GOV_WMARK_SIMPLE) += governor_wmark_simple.o
>
>  # DEVFREQ Drivers
>  obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)  += exynos/
> diff --git a/drivers/devfreq/governor_wmark_simple.c b/drivers/devfreq/governor_wmark_simple.c
> new file mode 100644
> index 000000000000..bd14adcc84cb
> --- /dev/null
> +++ b/drivers/devfreq/governor_wmark_simple.c
> @@ -0,0 +1,245 @@
> +/*
> + * Copyright (c) 2014, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/devfreq.h>
> +#include <linux/debugfs.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +#include <linux/notifier.h>
> +#include <linux/platform_device.h>
> +
> +#include "governor.h"
> +
> +struct wmark_gov_info {
> +       /* probed from the devfreq */
> +       unsigned int            *freqlist;
> +       int                     freq_count;
> +
> +       /* algorithm parameters */
> +       unsigned int            p_high_wmark;
> +       unsigned int            p_low_wmark;
> +
> +       /* dynamically changing data */
> +       enum watermark_type     event;

I would rename this to last_event for clarity.

> +       unsigned int            last_request;

last_freq might be a more appropriate name here.

> +
> +       /* common data */
> +       struct devfreq          *df;

Unless I missed something this member is only set once in
devfreq_watermark_start() and never touched afterwards.

> +       struct platform_device  *pdev;

Same with this one.

> +       struct dentry           *debugdir;
> +};
> +
> +static unsigned long freqlist_up(struct wmark_gov_info *wmarkinfo,
> +                                unsigned long curr_freq)
> +{
> +       int i, pos;
> +
> +       for (i = 0; i < wmarkinfo->freq_count; i++)
> +               if (wmarkinfo->freqlist[i] > curr_freq)
> +                       break;
> +
> +       pos = min(wmarkinfo->freq_count - 1, i);
> +
> +       return wmarkinfo->freqlist[pos];
> +}
> +
> +static unsigned int freqlist_down(struct wmark_gov_info *wmarkinfo,
> +                                 unsigned long curr_freq)
> +{
> +       int i, pos;
> +
> +       for (i = wmarkinfo->freq_count - 1; i >= 0; i--)
> +               if (wmarkinfo->freqlist[i] < curr_freq)
> +                       break;
> +
> +       pos = max(0, i);
> +       return wmarkinfo->freqlist[pos];
> +}
> +
> +static int devfreq_watermark_target_freq(struct devfreq *df,
> +                                        unsigned long *freq)
> +{
> +       struct wmark_gov_info *wmarkinfo = df->data;
> +       struct devfreq_dev_status dev_stat;
> +       int err;
> +
> +       err = df->profile->get_dev_status(df->dev.parent, &dev_stat);
> +       if (err < 0)
> +               return err;
> +
> +       switch (wmarkinfo->event) {
> +       case HIGH_WATERMARK_EVENT:
> +               *freq = freqlist_up(wmarkinfo, dev_stat.current_frequency);
> +
> +               /* always enable low watermark */
> +               df->profile->set_low_wmark(df->dev.parent,
> +                                          wmarkinfo->p_low_wmark);
> +
> +               /* disable high watermark if no change */
> +               if (*freq == wmarkinfo->last_request)
> +                       df->profile->set_high_wmark(df->dev.parent, 1000);
> +               break;
> +       case LOW_WATERMARK_EVENT:
> +               *freq = freqlist_down(wmarkinfo, dev_stat.current_frequency);
> +
> +               /* always enable high watermark */
> +               df->profile->set_high_wmark(df->dev.parent,
> +                                           wmarkinfo->p_high_wmark);
> +
> +               /* disable low watermark if no change */
> +               if (*freq == wmarkinfo->last_request)
> +                       df->profile->set_low_wmark(df->dev.parent, 0);
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       /* Mark that you handled event */

s/you/we

> +       wmarkinfo->event = NO_WATERMARK_EVENT;
> +       wmarkinfo->last_request = *freq;
> +
> +       return 0;
> +}
> +
> +static void devfreq_watermark_debug_start(struct devfreq *df)
> +{
> +       struct wmark_gov_info *wmarkinfo = df->data;
> +       char dirname[128];
> +
> +       snprintf(dirname, sizeof(dirname), "%s_scaling",
> +               to_platform_device(df->dev.parent)->name);
> +
> +       if (!wmarkinfo)
> +               return;
> +
> +       wmarkinfo->debugdir = debugfs_create_dir(dirname, NULL);
> +       if (!wmarkinfo->debugdir)
> +               return;
> +
> +       debugfs_create_u32("low_wmark", S_IRUGO | S_IWUSR,
> +                          wmarkinfo->debugdir, &wmarkinfo->p_low_wmark);
> +       debugfs_create_u32("high_wmark", S_IRUGO | S_IWUSR,
> +                          wmarkinfo->debugdir, &wmarkinfo->p_high_wmark);

Shouldn't we call set_low_wmark() and set_high_wmark() when these
values are changed so the hardware reacts to the new values?

> +}
> +
> +static void devfreq_watermark_debug_stop(struct devfreq *df)
> +{
> +       struct wmark_gov_info *wmarkinfo = df->data;
> +
> +       debugfs_remove_recursive(wmarkinfo->debugdir);
> +}
> +
> +static int devfreq_watermark_start(struct devfreq *df)
> +{
> +       struct wmark_gov_info *wmarkinfo;
> +       struct platform_device *pdev = to_platform_device(df->dev.parent);
> +
> +       if (!df->profile->freq_table) {
> +               dev_err(&pdev->dev, "Frequency table missing\n");
> +               return -EINVAL;

This error is not propagated by devfreq_watermark_event_handler(). It
definitely should be.

Also you will want to fail if d->profile->max_state == 0, otherwise
funny things will happen when a watermark is reached.

> +       }
> +
> +       wmarkinfo = kzalloc(sizeof(struct wmark_gov_info), GFP_KERNEL);

This memory is never freed.

> +       if (!wmarkinfo)
> +               return -ENOMEM;
> +
> +       df->data = (void *)wmarkinfo;
> +       wmarkinfo->freqlist = df->profile->freq_table;
> +       wmarkinfo->freq_count = df->profile->max_state;

Contrary to what its comment says, freq_table is not optional anymore
and only used for statistics if one intents to use a watermark
governor. It should probably be updated to reflect this.

> +       wmarkinfo->event = NO_WATERMARK_EVENT;
> +       wmarkinfo->df = df;
> +       wmarkinfo->pdev = pdev;
> +       wmarkinfo->p_low_wmark = 100;
> +       wmarkinfo->p_high_wmark = 600;
> +
> +       devfreq_watermark_debug_start(df);
> +
> +       return 0;
> +}
> +
> +static int devfreq_watermark_event_handler(struct devfreq *df,
> +                                          unsigned int event,
> +                                          void *wmark_type)
> +{
> +       int ret = 0;
> +       struct wmark_gov_info *wmarkinfo = df->data;
> +       enum watermark_type *type = wmark_type;
> +
> +       switch (event) {
> +       case DEVFREQ_GOV_START:
> +               devfreq_watermark_start(df);

This function does not really start anything - it prepares df to be
used with this governor. Maybe call it devfreq_watermark_init()
instead? Then you could have a devfreq_watermark_fini() function
called when we stop the governor that frees the memory previously
allocated.

Also I think you want to call try_module_get(THIS_MODULE) here to
prevent the governor module from being removed it if is used by
someone.

> +               wmarkinfo = df->data;
> +               if (df->profile->set_low_wmark)
> +                       df->profile->set_low_wmark(df->dev.parent,
> +                                                  wmarkinfo->p_low_wmark);
> +               if (df->profile->set_high_wmark)
> +                       df->profile->set_high_wmark(df->dev.parent,
> +                                                   wmarkinfo->p_high_wmark);

Isn't it an error if one (or both) of these functions is missing? For
we will never receive any event. Not sure about this.

> +               break;
> +       case DEVFREQ_GOV_STOP:
> +               devfreq_watermark_debug_stop(df);

As said above, have a devfreq_watermark_fini() (or any other name)
here that frees the kzalloc'd memory and calls
devfreq_watermark_debug_stop(). Also you should probably call
module_put(THIS_MODULE).

> +               break;
> +       case DEVFREQ_GOV_SUSPEND:
> +               devfreq_monitor_suspend(df);

Shouldn't we call set_low_wmark() and set_high_wmark() to prevent the
hardware from firing interrupts after devfreq_monitor_suspend() is
called?
