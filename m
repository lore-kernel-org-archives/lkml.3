Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3LCXCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:02:19 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51113 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755248Ab3LCXCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:02:16 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] PM / Sleep: Add pm_generic functions to re-use runtime PM callbacks
Date: Wed, 04 Dec 2013 00:15:13 +0100
Message-ID: <5255487.U4HM7Lafsi@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385566500-7666-2-git-send-email-ulf.hansson@linaro.org>
References: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org> <1385566500-7666-2-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 27, 2013 04:34:56 PM Ulf Hansson wrote:
> To put devices into low power state during sleep, it sometimes makes
> sense at subsystem-level to re-use the runtime PM callbacks.
> 
> The PM core will at device_suspend_late disable runtime PM, after that
> we can safely operate on these callbacks. At suspend_late the device
> will be put into low power state by invoking the runtime_suspend
> callbacks, unless the runtime status is already suspended. At
> resume_early the state is restored by invoking the runtime_resume
> callbacks. Soon after the PM core will re-enable runtime PM before
> returning from device_resume_early.
> 
> The new pm_generic functions are named pm_generic_suspend_late_runtime
> and pm_generic_resume_early_runtime, they are supposed to be used in
> pairs.
> 
> Do note that these new generic callbacks will work smothly even with
> and without CONFIG_PM_RUNTIME, as long as the runtime PM callbacks are
> implemented inside CONFIG_PM instead of CONFIG_PM_RUNTIME.
> 
> A special thanks to Alan Stern who came up with this idea.
> 
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/base/power/generic_ops.c |   86 ++++++++++++++++++++++++++++++++++++++
>  include/linux/pm.h               |    2 +
>  2 files changed, 88 insertions(+)
> 
> diff --git a/drivers/base/power/generic_ops.c b/drivers/base/power/generic_ops.c
> index 5ee030a..8e78ad1 100644
> --- a/drivers/base/power/generic_ops.c
> +++ b/drivers/base/power/generic_ops.c
> @@ -93,6 +93,49 @@ int pm_generic_suspend_late(struct device *dev)
>  EXPORT_SYMBOL_GPL(pm_generic_suspend_late);

After a bit of reconsideration it appears to me that the only benefit of that
would be to make it possible for drivers to work around incomplete PM domains
implementations.  Which would be of questionable value.

>  /**
> + * pm_generic_suspend_late_runtime - Generic suspend_late callback for drivers
> + * @dev: Device to suspend.
> + * Use to invoke runtime_suspend callbacks at suspend_late.
> + */
> +int pm_generic_suspend_late_runtime(struct device *dev)
> +{
> +	int (*callback)(struct device *);
> +	int ret = 0;
> +
> +	/*
> +	 * PM core has disabled runtime PM in device_suspend_late, thus we can
> +	 * safely check the device's runtime status and decide whether
> +	 * additional actions are needed to put the device into low power state.
> +	 * If so, we invoke the runtime_suspend callbacks.
> +	 * For the !CONFIG_PM_RUNTIME case, pm_runtime_status_suspended() always
> +	 * returns false and therefore the runtime_suspend callback will be
> +	 * invoked.
> +	 */
> +	if (pm_runtime_status_suspended(dev))
> +		return 0;
> +
> +	if (dev->pm_domain)
> +		callback = dev->pm_domain->ops.runtime_suspend;

First of all, for this to work you need to assume that the type/bus/class will
not exercise hardware in any way by itself (or you can look at the PCI bus type
for an example why it won't generally work otherwise), so you could simply skip
the rest of this conditional.

For the bus types you are concerned about (platform and AMBA) that actually is
the case as far as I can say.

> +	else if (dev->type && dev->type->pm)
> +		callback = dev->type->pm->runtime_suspend;
> +	else if (dev->class && dev->class->pm)
> +		callback = dev->class->pm->runtime_suspend;
> +	else if (dev->bus && dev->bus->pm)
> +		callback = dev->bus->pm->runtime_suspend;
> +	else
> +		callback = NULL;
> +
> +	if (!callback && dev->driver && dev->driver->pm)
> +		callback = dev->driver->pm->runtime_suspend;
> +
> +	if (callback)
> +		ret = callback(dev);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pm_generic_suspend_late_runtime);

After that you're left with something like this:

int prototype_suspend_late(struct device *dev)
{
	int (*callback)(struct device *);

	if (pm_runtime_status_suspended(dev))
		return 0;

	if (dev->pm_domain)
		callback = dev->pm_domain->ops.runtime_suspend;
	else if (dev->driver && dev->driver->pm)
		callback = dev->driver->pm->runtime_suspend;
	else
		callback = NULL;

	return callback ? callback(dev) : 0;
}

Moreover, if a driver's .suspend_late is pointed to the above, it can be called
in two ways.  The first way is via type/bus/class or the PM core itself which
means that all PM handling at this stage is going to be done by
prototype_suspend_late().  The other way is via a PM domain, in which case
there may be some additional PM handling in the domain code in principle
(before or after calling the driver's .suspend_late()).  However, in the
latter case it generally wouldn't be OK to call PM domain's .runtime_suspend(),
because that may interfere with the PM handling in its .suspend_late().  So
again, this pretty much requires that the PM domain's .suspend_late pointer be
NULL or point to a routine that simply executes the driver's callback and does
noting in addition to that.

Now, I suspect that if the driver's runtime_suspend callback is
driver_runtime_suspend() and the PM domain's runtime_suspend callback is
pm_domain_runtime_suspend(), the code you actually want to be executed at the
"late suspend" stage will be

	if (!pm_runtime_status_suspended(dev))
		pm_domain_runtime_suspend()
			driver_runtime_suspend()

(where the assumption is that pm_domain_runtime_suspend() will call
driver_runtime_suspend() for you).  Clearly, prototype_suspend_late() will lead
to that effective result in the conditions in which it makes sense to use it.

So, instead of pointing the driver's .suspend_late() to prototype_suspend_late(),
why don't you point the .suspend_late of the *PM* *domain* to the following
slightly modified version of that function:

int pm_domain_simplified_suspend_late(struct device *dev)
{
	int (*callback)(struct device *) = NULL;

	if (pm_runtime_status_suspended(dev))
		return 0;

	/* Try to execute our own .runtime_suspend() callback. */
	if (dev->pm_domain)
		callback = dev->pm_domain->ops.runtime_suspend;

	if (WARN_ON(!callback) && dev->driver && dev->driver->pm)
		callback = dev->driver->pm->runtime_suspend;

	return callback ? callback(dev) : 0;
}

This will cause exactly the code you need to be executed too (with
a fallback to direct execution of the driver's callback in broken
cases where the PM domain's own .runtime_suspend() is not implemented),
but in a much cleaner way (no going back to the code layer that has just
called you etc.).  And you *can* point the PM domain's .suspend_late
to this, because it has to be either empty of trivial if the
prototype_suspend_late() above is supposed to work as the driver's
.suspend_late() callback.

So in my opinion, if you point the .suspend_late callback pointers of the
PM domains in question to the pm_domain_simplified_suspend_late() above
and their .resume_early callback pointers to the following function:

int pm_domain_simplified_resume_early(struct device *dev)
{
	int (*callback)(struct device *) = NULL;

	if (pm_runtime_status_suspended(dev))
		return 0;

	if (dev->pm_domain)
		callback = dev->pm_domain->ops.runtime_resume;

	if (WARN_ON(!callback) && dev->driver && dev->driver->pm)
		callback = dev->driver->pm->runtime_resume;

	return callback ? callback(dev) : 0;
}

it will solve your problems without that horrible jumping between code
layers.

Thanks,
Rafael

