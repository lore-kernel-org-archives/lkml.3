Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3FZXwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:52:34 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55719 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3FZXwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:52:33 -0400
Message-ID: <51CB7E88.6000704@ahsoftware.de>
Date: Thu, 27 Jun 2013 01:51:36 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: rtc-linux@googlegroups.com
CC: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 3/9 v2] rtc: rtc-hid-sensor-time: delay
 registering as rtc into a work
References: <1371228732-5749-4-git-send-email-holler@ahsoftware.de> <1371724776-5572-1-git-send-email-holler@ahsoftware.de> <20130626125501.3d64408309a6f63100cc7d08@linux-foundation.org> <51CB5E6B.109@ahsoftware.de> <20130626220758.GA32461@kroah.com>
In-Reply-To: <20130626220758.GA32461@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.06.2013 00:07, schrieb Greg KH:
> On Wed, Jun 26, 2013 at 11:34:35PM +0200, Alexander Holler wrote:
>>>> +	/*
>>>> +	 * The HID device has to be registered to read the clock.
>>>> +	 * Because rtc_device_register() might read the time, we have to delay
>>>> +	 * rtc_device_register() to a work in order to finish the probe before.
>>>> +	 */
>>>> +	time_state->workts = kmalloc(sizeof(struct hid_time_workts),
>>>> +		GFP_KERNEL);
>>>> +	if (time_state->workts == NULL) {
>>>> +		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
>>>> +		return -ENOMEM;
>>>>  	}
>>>> +	time_state->workts->time_state = time_state;
>>>> +	INIT_WORK(&time_state->workts->work,
>>>> +			hid_time_register_rtc_work);
>>>> +	schedule_work(&time_state->workts->work);
>>>
>>> This seems unreliable.  The scheduled work can run one nanosecond
>>> later, on this or a different CPU.  What guarantees that the HID device
>>> will then be fully registered?
>>
>> Nothing, but schedule_delayed_work() is as unreliable as without delay
>> and I don't know of any callback after registration has happened. I have
>> to dig through the hid-(sensor-)code, maybe I will find a callback I can
>> (mis)use to register the rtc driver after the hid driver was registered.
> 
> Why not use the deferred_probe code, which is there just for this type
> of thing (i.e. your other drivers/devices aren't present/initialized
> yet.)?  Just return -EPROBE_DEFER from your probe function if you don't
> find everything already set up properly, the driver core will call you
> again later after it has initialized everything it has found.

Hmm, didn't know about the deferred_probe stuff. Thanks.

Unfortunately I currently don't see how this might help here. The
rtc-device will not be probed, so it can't be deferred. And even if I
will find or implement a way to add a probe for the rtc device, I still
have to search how to find out if the HID device is registered.

Anyway, back to reading to sources. Maybe there already is some callback
from hid-sensor-hub or the hid-subsystem I can use. I haven't searched
in deep for such because using a work worked just fine here on several
machines (besides that it was a quick hack which got only necessary with
the changed hctosys which reads the time in rtc_device_register()).

I already wondered why using a work (even without delay) did work, but I
explained it with some (maybe imaginary) locality of works, such that
they get called after the scheduling thread gives up his timeslice which
happily happened after the hid-device was registered. So I hoped (hope
dies last ;) ) to only have to fix it, if it actually doesn't work
somewhere or sometimes after the foreseen discussion about hctosys has
come to an end.

Regards,

Alexander Holler
