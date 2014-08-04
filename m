Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaHDMua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:50:30 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53770 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751033AbaHDMu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:50:28 -0400
Date: Mon, 4 Aug 2014 15:50:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC v4 06/21] leds: add API for setting torch brightness
Message-ID: <20140804125019.GA16460@valkosipuli.retiisi.org.uk>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <1405087464-13762-7-git-send-email-j.anaszewski@samsung.com>
 <20140716215444.GK16460@valkosipuli.retiisi.org.uk>
 <53DF7E0E.2060705@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DF7E0E.2060705@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

Thank you for your continued efforts on this!

On Mon, Aug 04, 2014 at 02:35:26PM +0200, Jacek Anaszewski wrote:
> On 07/16/2014 11:54 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >Jacek Anaszewski wrote:
> >...
> >>diff --git a/include/linux/leds.h b/include/linux/leds.h
> >>index 1a130cc..9bea9e6 100644
> >>--- a/include/linux/leds.h
> >>+++ b/include/linux/leds.h
> >>@@ -44,11 +44,21 @@ struct led_classdev {
> >>  #define LED_BLINK_ONESHOT_STOP    (1 << 18)
> >>  #define LED_BLINK_INVERT    (1 << 19)
> >>  #define LED_SYSFS_LOCK        (1 << 20)
> >>+#define LED_DEV_CAP_TORCH    (1 << 21)
> >>
> >>      /* Set LED brightness level */
> >>      /* Must not sleep, use a workqueue if needed */
> >>      void        (*brightness_set)(struct led_classdev *led_cdev,
> >>                        enum led_brightness brightness);
> >>+    /*
> >>+     * Set LED brightness immediately - it is required for flash led
> >>+     * devices as they require setting torch brightness to have
> >>immediate
> >>+     * effect. brightness_set op cannot be used for this purpose because
> >>+     * the led drivers schedule a work queue task in it to allow for
> >>+     * being called from led-triggers, i.e. from the timer irq context.
> >>+     */
> >
> >Do we need to classify actual devices based on this? I think it's rather
> >a different API behaviour between the LED and the V4L2 APIs.
> >
> >On devices that are slow to control, the behaviour should be asynchronous
> >over the LED API and synchronous when accessed through the V4L2 API. How
> >about implementing the work queue, as I have suggested, in the
> >framework, so
> >that individual drivers don't need to care about this and just implement
> >the
> >synchronous variant of this op? A flag could be added to distinguish
> >devices
> >that are fast so that the work queue isn't needed.
> >
> >It'd be nice to avoid individual drivers having to implement multiple
> >ops to
> >do the same thing, just for differing user space interfacs.
> >
> 
> It is not only the matter of a device controller speed. If a flash
> device is to be made accessible from the LED subsystem, then it
> should be also compatible with led-triggers. Some of led-triggers
> call brightness_set op from the timer irq context and thus no
> locking in the callback can occur. This requirement cannot be
> met i.e. if i2c bus is to be used. This is probably the primary
> reason for scheduling work queue tasks in brightness_set op.
> 
> Having the above in mind, setting a brightness in a work queue
> task must be possible for all LED Class Flash drivers, regardless
> whether related devices have fast or slow controller.
> 
> Let's recap the cost of possible solutions then:
> 
> 1) Moving the work queues to the LED framework
> 
>   - it would probably require extending led_set_brightness and
>     __led_set_brightness functions by a parameter indicating whether it
>     should call brightness_set op in the work queue task or directly;
>   - all existing triggers would have to be updated accordingly;
>   - work queues would have to be removed from all the LED drivers;
> 
> 2) adding led_set_torch_brightness API
> 
>   - no modifications in existing drivers and triggers would be required
>   - instead, only the modifications from the discussed patch would
>     be required
> 
> Solution 1 looks cleaner but requires much more modifications.

How about a combination of the two, i.e. option 1 with the old op remaining
there for compatibility with the old drivers (with a comment telling it's
deprecated)?

This way new drivers will benefit from having to implement this just once,
and modifications to the existing drivers could be left for later. The
downside is that any old drivers wouldn't get V4L2 flash API but that's
entirely acceptable in my opinion since these would hardly be needed in use
cases that would benefit from V4L2 flash API.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
