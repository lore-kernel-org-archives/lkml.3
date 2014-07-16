Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaGPVzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:55:24 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33553 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751907AbaGPVzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:55:20 -0400
Date: Thu, 17 Jul 2014 00:54:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC v4 06/21] leds: add API for setting torch brightness
Message-ID: <20140716215444.GK16460@valkosipuli.retiisi.org.uk>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <1405087464-13762-7-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1405087464-13762-7-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

Jacek Anaszewski wrote:
...
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 1a130cc..9bea9e6 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -44,11 +44,21 @@ struct led_classdev {
>   #define LED_BLINK_ONESHOT_STOP	(1 << 18)
>   #define LED_BLINK_INVERT	(1 << 19)
>   #define LED_SYSFS_LOCK		(1 << 20)
> +#define LED_DEV_CAP_TORCH	(1 << 21)
>
>   	/* Set LED brightness level */
>   	/* Must not sleep, use a workqueue if needed */
>   	void		(*brightness_set)(struct led_classdev *led_cdev,
>   					  enum led_brightness brightness);
> +	/*
> +	 * Set LED brightness immediately - it is required for flash led
> +	 * devices as they require setting torch brightness to have immediate
> +	 * effect. brightness_set op cannot be used for this purpose because
> +	 * the led drivers schedule a work queue task in it to allow for
> +	 * being called from led-triggers, i.e. from the timer irq context.
> +	 */

Do we need to classify actual devices based on this? I think it's rather 
a different API behaviour between the LED and the V4L2 APIs.

On devices that are slow to control, the behaviour should be asynchronous
over the LED API and synchronous when accessed through the V4L2 API. How
about implementing the work queue, as I have suggested, in the framework, so
that individual drivers don't need to care about this and just implement the
synchronous variant of this op? A flag could be added to distinguish devices
that are fast so that the work queue isn't needed.

It'd be nice to avoid individual drivers having to implement multiple ops to
do the same thing, just for differing user space interfacs.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
