Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3FZWIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:08:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3FZWIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:08:00 -0400
Date: Wed, 26 Jun 2013 15:07:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 3/9 v2] rtc: rtc-hid-sensor-time: delay
 registering as rtc into a work
Message-ID: <20130626220758.GA32461@kroah.com>
References: <1371228732-5749-4-git-send-email-holler@ahsoftware.de>
 <1371724776-5572-1-git-send-email-holler@ahsoftware.de>
 <20130626125501.3d64408309a6f63100cc7d08@linux-foundation.org>
 <51CB5E6B.109@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CB5E6B.109@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:34:35PM +0200, Alexander Holler wrote:
> >> +	/*
> >> +	 * The HID device has to be registered to read the clock.
> >> +	 * Because rtc_device_register() might read the time, we have to delay
> >> +	 * rtc_device_register() to a work in order to finish the probe before.
> >> +	 */
> >> +	time_state->workts = kmalloc(sizeof(struct hid_time_workts),
> >> +		GFP_KERNEL);
> >> +	if (time_state->workts == NULL) {
> >> +		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
> >> +		return -ENOMEM;
> >>  	}
> >> +	time_state->workts->time_state = time_state;
> >> +	INIT_WORK(&time_state->workts->work,
> >> +			hid_time_register_rtc_work);
> >> +	schedule_work(&time_state->workts->work);
> > 
> > This seems unreliable.  The scheduled work can run one nanosecond
> > later, on this or a different CPU.  What guarantees that the HID device
> > will then be fully registered?
> 
> Nothing, but schedule_delayed_work() is as unreliable as without delay
> and I don't know of any callback after registration has happened. I have
> to dig through the hid-(sensor-)code, maybe I will find a callback I can
> (mis)use to register the rtc driver after the hid driver was registered.

Why not use the deferred_probe code, which is there just for this type
of thing (i.e. your other drivers/devices aren't present/initialized
yet.)?  Just return -EPROBE_DEFER from your probe function if you don't
find everything already set up properly, the driver core will call you
again later after it has initialized everything it has found.

Hope this helps,

greg k-h
