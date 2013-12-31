Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab3LaATF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 19:19:05 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58626 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab3LaATD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 19:19:03 -0500
Date: Tue, 31 Dec 2013 00:18:40 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Joe Xue <lgxue@hotmail.com>
Cc: "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Add LED pattern trigger
Message-ID: <20131231001840.039a5a5c@alan.etchedpixels.co.uk>
In-Reply-To: <BLU172-W3543A0F3EFB217C99994F4ACCE0@phx.gbl>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
	<20131230162158.7420e811@alan.etchedpixels.co.uk>
	<BLU172-W3543A0F3EFB217C99994F4ACCE0@phx.gbl>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013 18:24:51 -0500
Joe Xue <lgxue@hotmail.com> wrote:

> >> +#define MAX_PATTEN_LEN 255
> >
> > Arbitary limits that are not needed if it was in userspace, and not it
> > seems a sensible one - why not use 256 ?
> 
> The maximum memory is 256, we keep one for '\0'

Why - you have pattern_len already ?

> >> + del_timer_sync(&pattern_data->timer);
> >> +
> >> + memcpy(pattern_data->pattern, buf, len);
> >> + pattern_data->pattern[len] = '\0';
> >> + pattern_data->pattern_len = len;
> >> + pattern_data->count = 0;
> >> +
> >> + mod_timer(&pattern_data->timer, jiffies + 1);
> >
> > What if the pattern isn't currently active ?
> 
> Doesn't matter as per my test.

What test - you've not explained why it doesn't blow up ?

> > Why +1, you don't need a zero terminator you know the length
> >
> > Why allocate a fixed 256 byte blob when you can make the data the end of
> > the struct (ie pattern[0] in the declaration) and not waste memory.
> 
> This just easy for patten_show.

Even so the fixed 256 is broken - you can just allocate the proper size
for the pattern when you set it up.
 
> >> +static void pattern_trig_deactivate(struct led_classdev *led_cdev)
> >> +{
> >> + struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
> >> +
> >> + if (led_cdev->activated) {
> >> + del_timer_sync(&pattern_data->timer);
> >> + device_remove_file(led_cdev->dev, &dev_attr_pattern);
> >> + device_remove_file(led_cdev->dev, &dev_attr_delay_unit);
> >
> > This doesn't as far as I can see do what you think. If I have the file
> > currently open then device_remove_file will not remove my existing access
> > to it, but you just released the pattern data so I now write to free
> > memory.
> 
> I believe kernel will handle this

I looked through the code paths and I see nothing to protect this at all ?

> >> + led_cdev->trigger_data = NULL;
> >> + led_cdev->activated = false;
> >> + kfree(pattern_data);
> >> + }
> >> + __led_set_brightness(led_cdev, LED_OFF);
> >> +}
> >> +
> >> +static struct led_trigger pattern_trigger = {
> >
> > const ?
> 

You don't want function pointers in objects that are not const, at least
whenever possible. On processors that have suitable protection modes that
helps prevent attacks based upon patching kernel function pointers.


Alan
