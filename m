Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3GFI4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 04:56:33 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:36210 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3GFI4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 04:56:30 -0400
Message-ID: <51D7DB6E.9010004@ahsoftware.de>
Date: Sat, 06 Jul 2013 10:55:10 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: rtc-linux@googlegroups.com
CC: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [rtc-linux] Re: [PATCH 3/9 v2] rtc: rtc-hid-sensor-time: delay
 registering as rtc into a work
References: <1371228732-5749-4-git-send-email-holler@ahsoftware.de> <1371724776-5572-1-git-send-email-holler@ahsoftware.de> <20130626125501.3d64408309a6f63100cc7d08@linux-foundation.org> <51CB5E6B.109@ahsoftware.de> <20130626220758.GA32461@kroah.com> <51CB7E88.6000704@ahsoftware.de>
In-Reply-To: <51CB7E88.6000704@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.06.2013 01:51, schrieb Alexander Holler:
> Am 27.06.2013 00:07, schrieb Greg KH:
>> On Wed, Jun 26, 2013 at 11:34:35PM +0200, Alexander Holler wrote:
>>>>> +	/*
>>>>> +	 * The HID device has to be registered to read the clock.
>>>>> +	 * Because rtc_device_register() might read the time, we have to delay
>>>>> +	 * rtc_device_register() to a work in order to finish the probe before.
>>>>> +	 */
>>>>> +	time_state->workts = kmalloc(sizeof(struct hid_time_workts),
>>>>> +		GFP_KERNEL);
>>>>> +	if (time_state->workts == NULL) {
>>>>> +		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
>>>>> +		return -ENOMEM;
>>>>>   	}
>>>>> +	time_state->workts->time_state = time_state;
>>>>> +	INIT_WORK(&time_state->workts->work,
>>>>> +			hid_time_register_rtc_work);
>>>>> +	schedule_work(&time_state->workts->work);
>>>>
>>>> This seems unreliable.  The scheduled work can run one nanosecond
>>>> later, on this or a different CPU.  What guarantees that the HID device
>>>> will then be fully registered?
>>>
>>> Nothing, but schedule_delayed_work() is as unreliable as without delay
>>> and I don't know of any callback after registration has happened. I have
>>> to dig through the hid-(sensor-)code, maybe I will find a callback I can
>>> (mis)use to register the rtc driver after the hid driver was registered.
>>
>> Why not use the deferred_probe code, which is there just for this type
>> of thing (i.e. your other drivers/devices aren't present/initialized
>> yet.)?  Just return -EPROBE_DEFER from your probe function if you don't
>> find everything already set up properly, the driver core will call you
>> again later after it has initialized everything it has found.
>
> Hmm, didn't know about the deferred_probe stuff. Thanks.
>
> Unfortunately I currently don't see how this might help here. The
> rtc-device will not be probed, so it can't be deferred. And even if I
> will find or implement a way to add a probe for the rtc device, I still
> have to search how to find out if the HID device is registered.
>
> Anyway, back to reading to sources. Maybe there already is some callback
> from hid-sensor-hub or the hid-subsystem I can use. I haven't searched
> in deep for such because using a work worked just fine here on several
> machines (besides that it was a quick hack which got only necessary with
> the changed hctosys which reads the time in rtc_device_register()).
>
> I already wondered why using a work (even without delay) did work, but I
> explained it with some (maybe imaginary) locality of works, such that
> they get called after the scheduling thread gives up his timeslice which
> happily happened after the hid-device was registered. So I hoped (hope
> dies last ;) ) to only have to fix it, if it actually doesn't work
> somewhere or sometimes after the foreseen discussion about hctosys has
> come to an end.
>

I've now traced down why the above patch _really_ is needed: it's 
because of how the locking is done in the hid-subsystem. So my intuition 
to use a work was ok, but my assumption that it's because the HID device 
driver wasn't registered before probe() finished was wrong.

What happens without using a work is the following (shortened a lot):

hid_device_probe() // hid subsystem locks hdev->driver_input_lock
   hid_time_probe()
     devm_rtc_device_register() // wants to read the clock
       hid_rtc_read_time() // submits GET_REPORT and waits for the answer
                           // (the timestamp from the clock)
         hid_input_report()

And there we have something like a deadlock situation because 
hid_input_report() needs hdev->driver_input_lock to submit the report to 
the HID driver.

So in short, it's currently impossible for a HID driver to read input 
from a HID device from inside it's probe function.

That means the patch is fine, but the comment is wrong.

Because I think it would be better to change the locking inside the HID 
subsystem (drivers/hid/hid-core.c) in order to allow the probe function 
of HID drivers to read input, I will first have a look if I see a way to 
change the locking in hid-core.c, before I will post an update to the 
above patch with a corrected comment. But this might need some time as 
I'm not familiar with the locking in the HID subsystem and my motivation 
currently isn't very high.

Regards,

Alexander Holler
