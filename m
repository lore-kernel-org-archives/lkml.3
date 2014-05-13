Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbaEMJQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:16:38 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:44649 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759744AbaEMJQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:16:35 -0400
MIME-Version: 1.0
In-Reply-To: <2675141.cAMB9masRU@vostro.rjw.lan>
References: <4649019.is79p6EySp@vostro.rjw.lan>
	<2675141.cAMB9masRU@vostro.rjw.lan>
Date: Tue, 13 May 2014 11:16:34 +0200
Message-ID: <CAPDyKFrXaxwh9xGK7Zn2Be0ViQqZJeT3hLo12ptmrmZvjMSscQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Move runtime PM barrier invocation
 to device_prepare()
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 May 2014 03:03, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Move the invocation of the runtime PM barrier during system suspend
> (or hibernation) from __device_suspend() to device_prepare() to make
> all runtime PM transitions in progress complete before executing
> ->prepare() callbacks for devices.
>
> That will allow those callbacks to check if devices are runtime
> suspended in a non-racy way.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/base/power/main.c |   31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
>
> Index: linux-pm/drivers/base/power/main.c
> ===================================================================
> --- linux-pm.orig/drivers/base/power/main.c
> +++ linux-pm/drivers/base/power/main.c
> @@ -1312,24 +1312,7 @@ static int __device_suspend(struct devic
>
>         dpm_wait_for_children(dev, async);
>
> -       if (async_error)
> -               goto Complete;
> -
> -       /*
> -        * If a device configured to wake up the system from sleep states
> -        * has been suspended at run time and there's a resume request pending
> -        * for it, this is equivalent to the device signaling wakeup, so the
> -        * system suspend operation should be aborted.
> -        */
> -       if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
> -               pm_wakeup_event(dev, 0);
> -
> -       if (pm_wakeup_pending()) {
> -               async_error = -EBUSY;
> -               goto Complete;
> -       }

I suppose you went a bit too far here!?

We can still have wakeup pending at this point, and thus we should
bail out, right?

> -
> -       if (dev->power.syscore)
> +       if (async_error || dev->power.syscore)
>                 goto Complete;
>
>         dpm_watchdog_set(&wd, dev);
> @@ -1500,6 +1483,18 @@ static int device_prepare(struct device
>          */
>         pm_runtime_get_noresume(dev);
>
> +       /*
> +        * If a device configured to wake up the system from sleep states
> +        * has been suspended at run time and there's a resume request pending
> +        * for it, this is equivalent to the device signaling wakeup, so the
> +        * system suspend operation should be aborted.
> +        */
> +       if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
> +               pm_wakeup_event(dev, 0);
> +
> +       if (pm_wakeup_pending())
> +               return -EBUSY;
> +
>         device_lock(dev);
>
>         dev->power.wakeup_path = device_may_wakeup(dev);
>

Kind regards
Ulf Hansson
