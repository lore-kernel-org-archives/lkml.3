Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaFILnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:43:01 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42169 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaFILm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:42:59 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 9 Jun 2014 13:42:22 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Bryan Wu <cooloney@gmail.com>,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Subject: Re: [PATCH v2] leds: USB: Add support for MSI GT683R led panels
Message-ID: <20140609114222.GC9307@localhost>
References: <1402003746-6354-1-git-send-email-janne.kanniainen@gmail.com>
 <20140606094752.GB9307@localhost>
 <CAEEjW04UAsi7yOdmF3FZ3sLE7m7B-VAH0prDPYjaMXarAfNwcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEEjW04UAsi7yOdmF3FZ3sLE7m7B-VAH0prDPYjaMXarAfNwcw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2014 at 01:12:39PM +0300, Janne Kanniainen wrote:
> > First of all, please reply to the original thread and make sure to not
> > drop people or lists from CC.
> 
> Sorry this is my first patch and i didn't know that. Now I know.
> 
> > For arrays you can use the ARRAY_SIZE() macro if that was the reason for
> > this change. I should have mentioned that when I pointed out that you
> > cannot use strlen().
> 
> That wasn't the reason. I just thought it might be better to use u64
> than char[8]. I know why I can't use strlen and that was only careless
> error. And there was lot of them :( I will be more careful next time.

No problem, that's what review is for, and the second version was much
cleaner even if there were still a few issues (some hard to know about,
such as the DMA from stack issue, which is also a very common error).

> > Where did you get these (HID report) values from by the way?
> 
> I got them by reverse engineering.

Traffic sniffing?

> >> +
> >> +static void gt683r_brightness_set(struct led_classdev *led_cdev,
> >> +                               enum led_brightness brightness)
> >> +{
> >> +     struct gt683r_led *led =
> >> +                     container_of(led_cdev, struct gt683r_led, led_dev);
> >> +
> >> +     mutex_lock(&led->lock);
> >
> > You cannot grab a mutex here since this function can be called from
> > interrupt context (if I remember correctly). Either way, you shouldn't
> > be holding the lock until the work task has finished...
> 
> I thought use asked me to put some lock there:
> 
> >> +
> >> +static void gt683r_brightness_set(struct led_classdev *led_cdev,
> >> +                               enum led_brightness brightness)
> >> +{
> >> +     struct gt683r_led *led =
> >> +                     container_of(led_cdev, struct gt683r_led, led_dev);
> >> +
> >> +     led->brightness = brightness;
> >
> > Missing locking?

I asked if locking was missing and did not specify how you should be
adding it. ;)

In fact, it seems you can get away with not adding any locking here.
Just do the (mutex) locking in gt683r_led_set (or gt683r_led_work).

Johan
