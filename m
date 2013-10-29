Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab3J2PVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:21:40 -0400
Received: from smtp-out-046.synserver.de ([212.40.185.46]:1122 "EHLO
	smtp-out-046.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab3J2PVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:21:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11694
Message-ID: <526FD278.8080102@metafoo.de>
Date: Tue, 29 Oct 2013 16:21:28 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH v3 02/10] spmi: Linux driver framework for SPMI
References: <cover.1382985169.git.joshc@codeaurora.org> <149bbfe89e37376cc176c3aeb6c1fab9e4fd2b91.1382985169.git.joshc@codeaurora.org>
In-Reply-To: <149bbfe89e37376cc176c3aeb6c1fab9e4fd2b91.1382985169.git.joshc@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of high-level comments on the in-kernel API.

On 10/28/2013 07:12 PM, Josh Cartwright wrote:
> +#ifdef CONFIG_PM_SLEEP
> +static int spmi_pm_suspend(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +
> +	if (pm)
> +		return pm_generic_suspend(dev);

pm_generic_suspend() checks both dev->driver and dev->driver->pm and returns
0 if either of them is NULL, so there should be no need to wrap the function.

> +	else
> +		return 0;
> +}
> +
> +static int spmi_pm_resume(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +
> +	if (pm)
> +		return pm_generic_resume(dev);

Same here

> +	else
> +		return 0;
> +}
> +#else
> +#define spmi_pm_suspend		NULL
> +#define spmi_pm_resume		NULL
> +#endif
[...]
> +/**
> + * spmi_controller_remove: Controller tear-down.
> + * @ctrl: controller to be removed.
> + *
> + * Controller added with the above API is torn down using this API.
> + */
> +int spmi_controller_remove(struct spmi_controller *ctrl)

The return type should be void. The function can't fail and nobody is going
to check the return value anyway.

> +{
> +	int dummy;
> +
> +	if (!ctrl)
> +		return -EINVAL;
> +
> +	dummy = device_for_each_child(&ctrl->dev, NULL,
> +				      spmi_ctrl_remove_device);
> +	device_unregister(&ctrl->dev);

Should be device_del(). device_unregister() will do both device_del() and
put_device(). But usually you'd want to do something in between like release
resources used by the controller.

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(spmi_controller_remove);
> +
[...]
> +/**
> + * spmi_controller_alloc: Allocate a new SPMI controller
> + * @ctrl: associated controller
> + *
> + * Caller is responsible for either calling spmi_device_add() to add the
> + * newly allocated controller, or calling spmi_device_put() to discard it.
> + */
> +struct spmi_device *spmi_device_alloc(struct spmi_controller *ctrl);
> +
> +static inline void spmi_device_put(struct spmi_device *sdev)

For symmetry reasons it might make sense to call this spmi_device_free().

> +{
> +	if (sdev)
> +		put_device(&sdev->dev);
> +}
[...]
> +#define to_spmi_controller(d) container_of(d, struct spmi_controller, dev)

Should be a inline function for better type safety.

[...]
> +static inline void spmi_controller_put(struct spmi_controller *ctrl)

For symmetry reasons it might make sense to call this spmi_controller_free().

> +{
> +	if (ctrl)
> +		put_device(&ctrl->dev);
> +}
> +
[....]
> +struct spmi_driver {
> +	struct device_driver driver;
> +	int	(*probe)(struct spmi_device *sdev);
> +	int	(*remove)(struct spmi_device *sdev);

The type of the remove function should be found. The Linux device model
doesn't really allow for device removal to fail.

> +	void	(*shutdown)(struct spmi_device *sdev);
> +	int	(*suspend)(struct spmi_device *sdev, pm_message_t pmesg);
> +	int	(*resume)(struct spmi_device *sdev);

The framework seems to support dev_pm_ops just fine, there should be no need
for legacy suspend/resume callbacks.

> +};
> +#define to_spmi_driver(d) container_of(d, struct spmi_driver, driver)

Inline function here as well
[...]
