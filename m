Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaEUHzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:55:33 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64625 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaEUHz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <1400651502-23703-1-git-send-email-inderpal.s@samsung.com>
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
	<1400651502-23703-1-git-send-email-inderpal.s@samsung.com>
Date: Wed, 21 May 2014 13:25:28 +0530
Message-ID: <CAKohpo=UgVoBL2xNBwe_AoqtCOYj4Rcc=vHh2kb=64UHLjjiAw@mail.gmail.com>
Subject: Re: [PATCH v2] PM / OPP: Implement opp_remove and free_opp_table functions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Inderpal Singh <inderpal.s@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 May 2014 11:21, Inderpal Singh <inderpal.s@samsung.com> wrote:
> At the driver unloading time the associated opps and its table may need
> to be deleted. Otherwise it amounts to memory leak. The existing
> OPP library does not have provision to do so.
>
> Hence this patch implements the required functions to free the same.
>
> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
> ---
> Changes in v2:
>         - As suggested by Nishanth, added support to remove a single OPP
>           for non-DT users
>         - Added an internal helper function to avoid the code duplication
>           between opp_remove and free_opp_table functions
>
>  drivers/base/power/opp.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/pm_opp.h   |  14 +++++-
>  2 files changed, 134 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index faae9cf..22adef3 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -89,6 +89,7 @@ struct device_opp {
>         struct device *dev;
>         struct srcu_notifier_head head;
>         struct list_head opp_list;
> +       struct rcu_head head_rcu;

This isn't used ...

>  };
>
>  /*
> @@ -427,7 +428,6 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
>                                 __func__);
>                         return -ENOMEM;
>                 }
> -

Unrelated change.
