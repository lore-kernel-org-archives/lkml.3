Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3AQTGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:06:12 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:59609 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab3AQTGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:06:09 -0500
X-Greylist: delayed 885 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 14:06:08 EST
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id
	:subject:from:to:cc:date:in-reply-to:references:content-type
	:content-transfer-encoding:mime-version; q=dns; s=sasl; b=LnE6NQ
	c1Vz3OyaRuuA8qgZk+7jQ3xqIrA1ig7+IcL9dsjySfaiV4usk2+eO9P3G/gAJPvV
	ytG4Xgt3VXtxIfPGhrajNpocfbiUNmDfiRbNxhh/BHZoKogu6GYwAHm6ubO7/dPb
	Nja4JfouLbzqDblCXk/avpIgbpgCMX33cotnA=
Message-ID: <1358448677.26320.22.camel@doorstop.aus.2wire.com>
Subject: Re: [PATCH 1/2] leds: simply LED trigger list management
From: Nathan Lynch <ntl@pobox.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Jan 2013 12:51:17 -0600
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E17700@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E17700@DQHE02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Pobox-Relay-ID: E2AD4ADC-60D6-11E2-8875-0A4F0E5B5709-04752483!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 01:06 +0000, Kim, Milo wrote:
> @@ -242,17 +233,15 @@ EXPORT_SYMBOL_GPL(led_trigger_unregister);
>  void led_trigger_event(struct led_trigger *trig,
>  			enum led_brightness brightness)
>  {
> -	struct list_head *entry;
> +	struct led_classdev *led_cdev;
>  
>  	if (!trig)
>  		return;
>  
>  	read_lock(&trig->leddev_list_lock);
> -	list_for_each(entry, &trig->led_cdevs) {
> -		struct led_classdev *led_cdev;
> -
> -		led_cdev = list_entry(entry, struct led_classdev, trig_list);
> -		led_set_brightness(led_cdev, brightness);
> +	list_for_each_entry(led_cdev, &leds_list, node) {
> +		if (led_cdev->trigger == trig)
> +			led_set_brightness(led_cdev, brightness);
>  	}
>  	read_unlock(&trig->leddev_list_lock);

Continuing to use trig->leddev_list_lock doesn't seem right.  Shouldn't
traversal of leds_list be guarded by the leds_list_lock rwsem?  And if
so, is it safe to use a potentially-blocking lock in this context?


