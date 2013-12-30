Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab3L3QWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:22:22 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58286 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3L3QWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:22:20 -0500
Date: Mon, 30 Dec 2013 16:21:58 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Joe Xue <lgxue@hotmail.com>
Cc: cooloney@gmail.com, rpurdie@rpsys.net, rob@landley.net, milo.kim@ti.com,
        pavel@ucw.cz, linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Add LED pattern trigger
Message-ID: <20131230162158.7420e811@alan.etchedpixels.co.uk>
In-Reply-To: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
> + * ledtrig-heartbeat.c and Shuah Khan's ledtrig-transient.c

I stil think this belongs in user space except for platforms with hardware
acceleration for it.

> +#define MAX_PATTEN_LEN	255

Arbitary limits that are not needed if it was in userspace, and not it
seems a sensible one - why not use 256 ?

> +static ssize_t pattern_delay_unit_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
> +	unsigned long state;
> +	ssize_t ret = -EINVAL;
> +
> +	ret = kstrtoul(buf, 10, &state);
> +	if (ret)
> +		return ret;
> +
> +	pattern_data->delay_unit = state;

What happens if this is zero ?

> +static ssize_t pattern_pattern_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
> +	int i;
> +	ssize_t ret = -EINVAL;
> +
> +	int len = (size > MAX_PATTEN_LEN) ? MAX_PATTEN_LEN : (size - 1);
> +
> +	/* legality check */
> +	for (i = 0; i < len; i++) {
> +		if (buf[i] != ' ' && buf[i] != '#' && buf[i] != '/')
> +			return ret;
> +	}
> +
> +	del_timer_sync(&pattern_data->timer);
> +
> +	memcpy(pattern_data->pattern, buf, len);
> +	pattern_data->pattern[len] = '\0';
> +	pattern_data->pattern_len = len;
> +	pattern_data->count = 0;
> +
> +	mod_timer(&pattern_data->timer, jiffies + 1);

What if the pattern isn't currently active ?

> +	return size;

You only consumed len bytes so you should return len here.

> +}
> +
> +static DEVICE_ATTR(pattern, 0644, pattern_pattern_show, pattern_pattern_store);
> +static DEVICE_ATTR(delay_unit, 0644,
> +		pattern_delay_unit_show, pattern_delay_unit_store);

Why are these world readable. If patterns tell you an action is due they
provide information that other processes shouldn't have access to.

> +	memset(tdata->pattern, 0, MAX_PATTEN_LEN + 1);

Why +1, you don't need a zero terminator you know the length

Why allocate a fixed 256 byte blob when you can make the data the end of
the struct (ie pattern[0] in the declaration) and not waste memory.

> +static void pattern_trig_deactivate(struct led_classdev *led_cdev)
> +{
> +	struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
> +
> +	if (led_cdev->activated) {
> +		del_timer_sync(&pattern_data->timer);
> +		device_remove_file(led_cdev->dev, &dev_attr_pattern);
> +		device_remove_file(led_cdev->dev, &dev_attr_delay_unit);

This doesn't as far as I can see do what you think. If I have the file
currently open then device_remove_file will not remove my existing access
to it, but you just released the pattern data so I now write to free
memory.

> +		led_cdev->trigger_data = NULL;
> +		led_cdev->activated = false;
> +		kfree(pattern_data);
> +	}
> +	__led_set_brightness(led_cdev, LED_OFF);
> +}
> +
> +static struct led_trigger pattern_trigger = {

const ?


