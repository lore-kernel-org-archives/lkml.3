Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3J2P5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:57:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39528 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837Ab3J2P5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:57:31 -0400
Date: Tue, 29 Oct 2013 10:56:16 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v3 02/10] spmi: Linux driver framework for SPMI
Message-ID: <20131029155616.GG20207@joshc.qualcomm.com>
References: <cover.1382985169.git.joshc@codeaurora.org>
 <149bbfe89e37376cc176c3aeb6c1fab9e4fd2b91.1382985169.git.joshc@codeaurora.org>
 <526FD278.8080102@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526FD278.8080102@metafoo.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Lars-

Thanks for the feedback.  CC'ing Ivan, since he had the same feedback
regarding the PM callbacks.

On Tue, Oct 29, 2013 at 04:21:28PM +0100, Lars-Peter Clausen wrote:
> Couple of high-level comments on the in-kernel API.
> 
> On 10/28/2013 07:12 PM, Josh Cartwright wrote:
> > +#ifdef CONFIG_PM_SLEEP
> > +static int spmi_pm_suspend(struct device *dev)
> > +{
> > +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> > +
> > +	if (pm)
> > +		return pm_generic_suspend(dev);
> 
> pm_generic_suspend() checks both dev->driver and dev->driver->pm and returns
> 0 if either of them is NULL, so there should be no need to wrap the function.
> 
> > +	else
> > +		return 0;
> > +}
> > +
> > +static int spmi_pm_resume(struct device *dev)
> > +{
> > +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> > +
> > +	if (pm)
> > +		return pm_generic_resume(dev);
> 
> Same here

Sounds good.  I'll drop these.

> > +/**
> > + * spmi_controller_remove: Controller tear-down.
> > + * @ctrl: controller to be removed.
> > + *
> > + * Controller added with the above API is torn down using this API.
> > + */
> > +int spmi_controller_remove(struct spmi_controller *ctrl)
> 
> The return type should be void. The function can't fail and nobody is going
> to check the return value anyway.

Alright.

> > +{
> > +	int dummy;
> > +
> > +	if (!ctrl)
> > +		return -EINVAL;
> > +
> > +	dummy = device_for_each_child(&ctrl->dev, NULL,
> > +				      spmi_ctrl_remove_device);
> > +	device_unregister(&ctrl->dev);
> 
> Should be device_del(). device_unregister() will do both device_del() and
> put_device(). But usually you'd want to do something in between like release
> resources used by the controller.

I'm not sure I understand your suggestion here.  If put_device() isn't
called here, wouldn't we be leaking the controller?  What resources
would I want to be releasing here that aren't released as part of the
controller's release() function?

> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(spmi_controller_remove);
> > +
> [...]
> > +/**
> > + * spmi_controller_alloc: Allocate a new SPMI controller
> > + * @ctrl: associated controller
> > + *
> > + * Caller is responsible for either calling spmi_device_add() to add the
> > + * newly allocated controller, or calling spmi_device_put() to discard it.
> > + */
> > +struct spmi_device *spmi_device_alloc(struct spmi_controller *ctrl);
> > +
> > +static inline void spmi_device_put(struct spmi_device *sdev)
> 
> For symmetry reasons it might make sense to call this spmi_device_free().

Except that it doesn't necessarily free() the underlying device, so I
find that more confusing.

> > +{
> > +	if (sdev)
> > +		put_device(&sdev->dev);
> > +}
> [...]
> > +#define to_spmi_controller(d) container_of(d, struct spmi_controller, dev)
> 
> Should be a inline function for better type safety.

Sounds good.  Will change the to_spmi_*() macros.

> [...]
> > +static inline void spmi_controller_put(struct spmi_controller *ctrl)
> 
> For symmetry reasons it might make sense to call this spmi_controller_free().
> 
> > +{
> > +	if (ctrl)
> > +		put_device(&ctrl->dev);
> > +}
> > +
> [....]
> > +struct spmi_driver {
> > +	struct device_driver driver;
> > +	int	(*probe)(struct spmi_device *sdev);
> > +	int	(*remove)(struct spmi_device *sdev);
> 
> The type of the remove function should be found. The Linux device model
> doesn't really allow for device removal to fail.
> 
> > +	void	(*shutdown)(struct spmi_device *sdev);
> > +	int	(*suspend)(struct spmi_device *sdev, pm_message_t pmesg);
> > +	int	(*resume)(struct spmi_device *sdev);
> 
> The framework seems to support dev_pm_ops just fine, there should be no need
> for legacy suspend/resume callbacks.

Yep.  Will drop.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
