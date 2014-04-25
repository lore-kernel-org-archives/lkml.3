Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaDYL2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:28:30 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:38616 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaDYL22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:28:28 -0400
MIME-Version: 1.0
In-Reply-To: <2801565.1dAEgrXAm3@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1402271001190.1150-100000@iolanthe.rowland.org>
	<5039115.7hOuWtlQhG@vostro.rjw.lan>
	<2801565.1dAEgrXAm3@vostro.rjw.lan>
Date: Fri, 25 Apr 2014 13:28:27 +0200
Message-ID: <CAPDyKFqLBcj9qYA1jLO5rJBV0gqB8-G=G+M-WJSMJCvOBL671Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/3][Resend] PM / runtime: Routine for checking
 device status during system suspend
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 April 2014 00:39, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Add a new helper routine, pm_runtime_enabled_and_suspended(), to
> allow subsystems (or PM domains) to check the runtime PM status of
> devices during system suspend (possibly to avoid resuming those
> devices upfront at that time).
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/base/power/runtime.c |   28 ++++++++++++++++++++++++++++
>  include/linux/pm_runtime.h   |    2 ++
>  2 files changed, 30 insertions(+)
>
> Index: linux-pm/include/linux/pm_runtime.h
> ===================================================================
> --- linux-pm.orig/include/linux/pm_runtime.h
> +++ linux-pm/include/linux/pm_runtime.h
> @@ -57,6 +57,7 @@ extern unsigned long pm_runtime_autosusp
>  extern void pm_runtime_update_max_time_suspended(struct device *dev,
>                                                  s64 delta_ns);
>  extern void pm_runtime_set_memalloc_noio(struct device *dev, bool enable);
> +extern bool pm_runtime_enabled_and_suspended(struct device *dev);
>
>  static inline bool pm_children_suspended(struct device *dev)
>  {
> @@ -165,6 +166,7 @@ static inline unsigned long pm_runtime_a
>                                 struct device *dev) { return 0; }
>  static inline void pm_runtime_set_memalloc_noio(struct device *dev,
>                                                 bool enable){}
> +static inline bool pm_runtime_enabled_and_suspended(struct device *dev) { return false; }
>
>  #endif /* !CONFIG_PM_RUNTIME */
>
> Index: linux-pm/drivers/base/power/runtime.c
> ===================================================================
> --- linux-pm.orig/drivers/base/power/runtime.c
> +++ linux-pm/drivers/base/power/runtime.c
> @@ -1195,6 +1195,34 @@ void pm_runtime_enable(struct device *de
>  EXPORT_SYMBOL_GPL(pm_runtime_enable);
>
>  /**
> + * pm_runtime_enabled_and_suspended - Check runtime PM status of a device.
> + * @dev: Device to handle.
> + *
> + * This routine is to be executed during system suspend only, after
> + * device_prepare() has been executed for @dev.

Hi Rafael,

Do we really need to state the above constraints. Could we not leave
it to be used in other scenarios as well? I am not sure those would
exists though, but still. :-)

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Ulf Hansson

> + *
> + * Return false if runtime PM is disabled for the device.  Otherwise, wait
> + * for pending transitions to complete and check the runtime PM status of the
> + * device after that.  Return true if it is RPM_SUSPENDED.
> + */
> +bool pm_runtime_enabled_and_suspended(struct device *dev)
> +{
> +       unsigned long flags;
> +       bool ret;
> +
> +       spin_lock_irqsave(&dev->power.lock, flags);
> +       if (dev->power.disable_depth) {
> +               ret = false;
> +       } else {
> +               __pm_runtime_barrier(dev);
> +               ret = pm_runtime_status_suspended(dev);
> +       }
> +       spin_unlock_irqrestore(&dev->power.lock, flags);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(pm_runtime_enabled_and_suspended);
> +
> +/**
>   * pm_runtime_forbid - Block runtime PM of a device.
>   * @dev: Device to handle.
>   *
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
