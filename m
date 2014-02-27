Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaB0FAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:00:51 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40995 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaB0FAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:00:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "MyungJoo Ham" <myungjoo.ham@samsung.com>,
        "Mark Brown" <broonie@kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140227023455.GA15712@kahuna>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
References: <1392755543-28335-1-git-send-email-nm@ti.com>
 <1392755543-28335-2-git-send-email-nm@ti.com>
 <20140225055142.22529.21814@quantum> <530D0394.4020208@ti.com>
 <20140227023455.GA15712@kahuna>
Message-ID: <20140227050043.12081.54173@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC PATCH 1/6] PM / Voltagedomain: Add generic clk notifier handler for
 regulator based dynamic voltage scaling
Date: Wed, 26 Feb 2014 21:00:43 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nishanth Menon (2014-02-26 18:34:55)
> +/**
> + * pm_runtime_get_rate() - Returns the device operational frequency
> + * @dev:       Device to handle
> + * @rate:      Returns rate in Hz.
> + *
> + * Returns appropriate error value in case of error conditions, else
> + * returns 0 and rate is updated. The pm_domain logic does all the necessary
> + * operation (which may consider magic hardware stuff) to provide the rate.
> + *
> + * NOTE: the rate returned is a snapshot and in many cases just a bypass
> + * to clk api to set the rate.
> + */
> +int pm_runtime_get_rate(struct device *dev, unsigned long *rate)

Instead of "rate", how about we use "level" and leave it undefined as to
what that means? It would be equally valid for level to represent a
clock rate, or an opp from a table of opp's, or a p-state, or some value
passed to a PM microcontroller.

Code that is tightly coupled to the hardware would simply know what
value to use with no extra sugar.

Generic code would need to get the various supported "levels" populated
at run time, but a DT binding could do that, or a query to the ACPI
tables, or whatever.

> +{
> +       unsigned long flags;
> +       int error = -ENOSYS;
> +
> +       if (!rate || !dev)
> +               return -EINVAL;
> +
> +       spin_lock_irqsave(&dev->power.lock, flags);
> +       if (!pm_runtime_active(dev)) {
> +               error = -EINVAL;
> +               goto out;
> +       }
> +
> +       if (dev->pm_domain && dev->pm_domain->active_ops.get_rate)
> +               error = dev->pm_domain->active_ops.get_rate(dev, rate);
> +out:
> +       spin_unlock_irqrestore(&dev->power.lock, flags);
> +
> +       return error;
> +}
> +
> +/**
> + * pm_runtime_set_rate() - Set a specific rate for the device operation
> + * @dev:       Device to handle
> + * @rate:      Rate to set in Hz
> + *
> + * Returns appropriate error value in case of error conditions, else
> + * returns 0. The pm_domain logic does all the necessary operation (which
> + * may include voltage scale operations or other magic hardware stuff) to
> + * achieve the operation. It is guarenteed that the requested rate is achieved
> + * on returning from this function if return value is 0.
> + */
> +int pm_runtime_set_rate(struct device *dev, unsigned long rate)

Additionally I wonder if the function signature should include a way to
specify the sub-unit of a device that we are operating on? This is a way
to tackle the issues you raised regarding multiple clocks per device,
etc. Two approaches come to mind:

int pm_runtime_set_rate(struct device *dev, int index,
				unsigned long rate);

Where index is a sub-unit of struct device *dev. The second approach is
to create a publicly declared structure representing the sub-unit. Some
variations on that theme:

int pm_runtime_set_rate(struct perf_domain *perfdm, unsigned long rate);

or,

int pm_runtime_set_rate(struct generic_power_domain *gpd,
				unsigned long rate);

or whatever that sub-unit looks like. The gpd thing might be a total
layering violation, I don't know. Or perhaps it's a decent idea but it
shouldn't be as a PM runtime call. Again, I dunno.

Regards,
Mike
