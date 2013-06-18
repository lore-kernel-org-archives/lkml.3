Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739Ab3FRWFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:05:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36805 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756331Ab3FRWFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:05:41 -0400
Message-ID: <1371593140.2038.8.camel@joe-AO722>
Subject: Re: [RFC PATCH] led: add Cycle LED trigger.
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?Ga=EBl?= PORTAY <g.portay@overkiz.com>
Cc: Rob Landley <rob@landley.net>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Date: Tue, 18 Jun 2013 15:05:40 -0700
In-Reply-To: <1371572663-10846-1-git-send-email-g.portay@overkiz.com>
References: <1371572663-10846-1-git-send-email-g.portay@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 18:24 +0200, Gaël PORTAY wrote:
> Currently, none of available triggers supports playing with the LED brightness
> level.  The cycle trigger provides a way to define custom brightness cycle.
> For example, it is easy to customize the cycle to mock up the rhythm of human
> breathing which is a nice cycle to tell the user the system is doing something.

I think maybe this is a userspace thing, but here's a
trivial comment or two


> +static int cycle_start(struct cycle_trig_data *data)
> +{
> +	unsigned long flags;
> +
> +	if (hrtimer_active(&data->timer))
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&data->lock, flags);
> +	data->plot_index = 0;
> +	data->cycle_count = 0;
> +	hrtimer_start(&data->timer, ktime_get(), HRTIMER_MODE_ABS);
> +	spin_unlock_irqrestore(&data->lock, flags);
> +
> +	return 1;

Maybe return 0 on success

> +static ssize_t cycle_control_store(struct device *dev,
> +				    struct device_attribute *attr,
> +				    const char *buf, size_t size)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct cycle_trig_data *data = led_cdev->trigger_data;
> +
> +	if (strncmp(buf, "start", sizeof("start") - 1) == 0)
> +		cycle_start(data);
> +	else if (strncmp(buf, "stop", sizeof("stop") - 1) == 0)
> +		cycle_stop(data);
> +	else if (strncmp(buf, "reset", sizeof("reset") - 1) == 0)
> +		cycle_reset(data);
> +	else if (strncmp(buf, "pause", sizeof("stop") - 1) == 0)
> +		cycle_pause(data);
> +	else if (strncmp(buf, "resume", sizeof("resume") - 1) == 0)
> +		cycle_resume(data);
> +	else
> +		return -EINVAL;

I think strcasecmp better than strncmp

> +static ssize_t cycle_rawplot_store(struct device *dev,
> +                                  struct device_attribute *attr,
> +                                  const char *buf, size_t size)
> +{
[]
+       plot = kzalloc(size, GFP_KERNEL);
+       if (plot) {
+               hrtimer_cancel(&data->timer);

Ick.

	if (!plot)
		return -ENOMEM;

	etc...

