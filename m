Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaEGH7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:59:06 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38156 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750910AbaEGH7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:59:03 -0400
Date: Wed, 7 May 2014 10:58:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC v3 5/5] media: Add registration helpers for V4L2
 flash sub-devices
Message-ID: <20140507075828.GD8753@valkosipuli.retiisi.org.uk>
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
 <1397228216-6657-6-git-send-email-j.anaszewski@samsung.com>
 <20140416182141.GG8753@valkosipuli.retiisi.org.uk>
 <534F9044.6080508@samsung.com>
 <20140423152435.GJ8753@valkosipuli.retiisi.org.uk>
 <535E3A95.6010206@samsung.com>
 <20140502110651.GX8753@valkosipuli.retiisi.org.uk>
 <536884D9.4050104@samsung.com>
 <20140506091059.GB8753@valkosipuli.retiisi.org.uk>
 <5369DEB1.2060803@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5369DEB1.2060803@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Wed, May 07, 2014 at 09:20:17AM +0200, Jacek Anaszewski wrote:
> On 05/06/2014 11:10 AM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Tue, May 06, 2014 at 08:44:41AM +0200, Jacek Anaszewski wrote:
> >>Hi Sakari,
> >>
> >>On 05/02/2014 01:06 PM, Sakari Ailus wrote:
> >>
> >>>>>>[...]
> >>>>>>>>+static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
> >>>>>>>>+					struct led_ctrl *config,
> >>>>>>>>+					u32 intensity)
> >>>>>>>
> >>>>>>>Fits on a single line.
> >>>>>>>
> >>>>>>>>+{
> >>>>>>>>+	return intensity / config->step;
> >>>>>>>
> >>>>>>>Shouldn't you first decrement the minimum before the division?
> >>>>>>
> >>>>>>Brightness level 0 means that led is off. Let's consider following case:
> >>>>>>
> >>>>>>intensity - 15625
> >>>>>>config->step - 15625
> >>>>>>intensity / config->step = 1 (the lowest possible current level)
> >>>>>
> >>>>>In V4L2 controls the minimum is not off, and zero might not be a possible
> >>>>>value since minimum isn't divisible by step.
> >>>>>
> >>>>>I wonder how to best take that into account.
> >>>>
> >>>>I've assumed that in MODE_TORCH a led is always on. Switching
> >>>>the mode to MODE_FLASH or MODE_OFF turns the led off.
> >>>>This way we avoid the problem with converting 0 uA value to
> >>>>led_brightness, as available torch brightness levels start from
> >>>>the minimum current level value and turning the led off is
> >>>>accomplished on transition to MODE_OFF or MODE_FLASH, by
> >>>>calling brightness_set op with led_brightness = 0.
> >>>
> >>>I'm not sure if we understood the issue the same way. My concern was that if
> >>>the intensity isn't a multiple of step (but intensity - min is), the above
> >>>formula won't return a valid result (unless I miss something).
> >>>
> >>
> >>Please note that v4l2_flash_intensity_to_led_brightness is called only
> >>from s_ctrl callback, and thus it expects to get the intensity aligned
> >>to the step value, so it will always be a multiple of step.
> >>Is it possible that s_ctrl callback would be passed a non-aligned
> >>control value?
> >
> >In a nutshell: value - min is aligned but value is not. Please see
> >validate_new() in drivers/media/v4l2-core/v4l2-ctrls.c .
> >
> 
> Still, to my mind, value is aligned.
> 
> Below I execute the calculation steps one by one
> according to the V4L2_CTRL_TYPE_INTEGER case in the
> validate_new function:
> 
> c->value = 35000
> 
> val = c->value + step / 2;       // 35000 + 15625 / 2 = 42812
> val = clamp(val, min, max);      // val = 42812
> offset = val - min;              // 42812 - 15625 = 27187
> offset = step * (offset / step); // 15625 * (27187 / 15625) = 15625
> c->value = min + offset;         // 15625 + 15625 = 31250
> 
> Value is aligned to the nearest step.
> 
> Please spot any discrepancies in my way of thinking if there
> are any :)

min is aligned to step above. This is not necessarily the case. And if min
is not aligned, neither is value.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
