Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966304Ab3HIJqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:46:15 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51181 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965287Ab3HIJqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:46:13 -0400
Message-ID: <5204BA2E.8000100@ahsoftware.de>
Date: Fri, 09 Aug 2013 11:45:18 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: rtc-linux@googlegroups.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew de los Reyes <adlr@chromium.org>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [rtc-linux] Re: [PATCH 2/2 RESEND] rtc: rtc-hid-sensor-time:
 enable HID input processing early
References: <1375382342-25454-1-git-send-email-holler@ahsoftware.de> <1375382342-25454-2-git-send-email-holler@ahsoftware.de> <20130808151106.7ccaedd4ea3d4e5faa6aa220@linux-foundation.org>
In-Reply-To: <20130808151106.7ccaedd4ea3d4e5faa6aa220@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.08.2013 00:11, schrieb Andrew Morton:
> On Thu,  1 Aug 2013 20:39:02 +0200 Alexander Holler <holler@ahsoftware.de> wrote:
>
>> Enable the processing of HID input records before the RTC will be registered,
>> in order to allow the RTC register function to read clock. Without doing
>> that the clock can only be read after the probe function has finished.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>> ---
>>   drivers/rtc/rtc-hid-sensor-time.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
>> index 1ab3d13..1006a62 100644
>> --- a/drivers/rtc/rtc-hid-sensor-time.c
>> +++ b/drivers/rtc/rtc-hid-sensor-time.c
>> @@ -279,11 +279,18 @@ static int hid_time_probe(struct platform_device *pdev)
>>   		return ret;
>>   	}
>>
>> +	/*
>> +	 * Enable HID input processing early in order to be able to read the
>> +	 * clock already in devm_rtc_device_register().
>> +	 */
>> +	hid_device_io_start(hsdev->hdev);
>> +
>>   	time_state->rtc = devm_rtc_device_register(&pdev->dev,
>>   					"hid-sensor-time", &hid_time_rtc_ops,
>>   					THIS_MODULE);
>>
>>   	if (IS_ERR_OR_NULL(time_state->rtc)) {
>> +		hid_device_io_stop(hsdev->hdev);
>>   		ret = time_state->rtc ? PTR_ERR(time_state->rtc) : -ENODEV;
>>   		time_state->rtc = NULL;
>>   		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
>
> Shouldn't now there be a hid_device_io_stop() in hid_time_remove()?

That isn't how I understood the commit message to commit 
c849a6143bec520aff2a6646518b0d041402428b which introduced that 
functionality in 3.10. But maybe I'm wrong. I haven't looked at the 
underlying code and haven't tested that (very unlikely) error path with 
the new change I made.

> Also, hid_device_io_start() does a weird up() on a
> downed-by-someone-else semaphore.  Where was that down() performed in
> this case?

Uh, don't know, as already said, I haven't looked at the underlying 
code. But I will now do and will enable all mutex/semaphore debug 
options I find. I have to admit, I didn't have tested the change with 
debug options enabled, so if the kernel doesn't cry on wierd uo()'s 
without debug options enabled, I would have missed that.

> Also, your changelog implies that the kernel is already doing this
> hid_device_io_start(), only it does it too late.  If that is the case
> then will the existing-before-this-patch call to hid_device_io_start()
> generate the "io already started" warning?

No, hid_device_io_start() was introduced especially for such cases. I 
need it because devm_rtc_device_register() might want to read the clock, 
but without hid_device_io_start() that only is possible after probe 
finished (therefor not during devm_rtc_device_register()).

Some time later ...

With several debug options enabled I've got (once) the below backtrace 
with the error path enabled (time_state->rtc = NULL instead of 
time_state->rtc = rtc_device_register()).

[    8.007975] rtc_hid_sensor_time HID-SENSOR-2000a0.0: milliseconds 
supported
[    8.015499] rtc_hid_sensor_time HID-SENSOR-2000a0.0: rtc device 
register failed!
(...)
[   65.551939] =================================
[   65.556343] [ INFO: inconsistent lock state ]

To add some more explanations for the trace (below in full without 
times): The device I use does send the time around once every minute as 
an hid input report and this just might have happened here, causing the 
lock warning. What makes me wonder here is that hid-sensor-hub seems to 
receive the input report even after hid_device_io_stop() was called and 
the probe function for the hid device in question (rtc-hid-sensor-time) 
failed with a rc of -ENODEV.

I've added the HID maintainer and the author of the above mentioned 
commit to cc.

I will need some time (hopefully this weekend) to have a deeper look at 
what goes wrong there. Unfortunatley rtc-hid-sensor-time currently seems 
to be the only user of hid_device_io_stop(), so I might have hit a bug 
or did use it wrong.

But nevertheless, the non-error-path does work as expected, at least I 
haven't seen a problem until now.

Regards,

Alexander Holler

----------
=================================
[ INFO: inconsistent lock state ]
3.10.5-dockstar-00038-g03242d1-dirty #408 Not tainted
---------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
  (&(&sd->dyn_callback_lock)->rlock){?.+...}, at: [<c02af9f8>] 
sensor_hub_raw_event+0x10c/0x204
{HARDIRQ-ON-W} state was registered at:
   [<c004dba0>] __lock_acquire+0x630/0x18f0
   [<c004f31c>] lock_acquire+0x64/0x78
   [<c039c960>] _raw_spin_lock+0x40/0x50
   [<c02af854>] sensor_hub_register_callback+0x2c/0xc4
   [<c029ce1c>] hid_time_probe+0x2f8/0x36c
   [<c0234c98>] platform_drv_probe+0x14/0x18
   [<c0233d48>] driver_probe_device+0xb4/0x210
   [<c023243c>] bus_for_each_drv+0x48/0x8c
   [<c0233c50>] device_attach+0x68/0x8c
   [<c02332a8>] bus_probe_device+0x28/0xa0
   [<c0231a84>] device_add+0x3d8/0x594
   [<c0235064>] platform_device_add+0x130/0x1c0
   [<c023ca50>] mfd_add_device+0x1d0/0x23c
   [<c023cc38>] mfd_add_devices+0x7c/0xac
   [<c02afeec>] sensor_hub_probe+0x2a0/0x364
   [<c02aa614>] hid_device_probe+0x90/0x128
   [<c0233d48>] driver_probe_device+0xb4/0x210
   [<c023243c>] bus_for_each_drv+0x48/0x8c
   [<c0233c50>] device_attach+0x68/0x8c
   [<c02332a8>] bus_probe_device+0x28/0xa0
   [<c0231a84>] device_add+0x3d8/0x594
   [<c02aa28c>] hid_add_device+0x244/0x29c
   [<c02b1f10>] usbhid_probe+0x368/0x448
   [<c027bc14>] usb_probe_interface+0x13c/0x1e0
   [<c0233d48>] driver_probe_device+0xb4/0x210
   [<c023243c>] bus_for_each_drv+0x48/0x8c
   [<c0233c50>] device_attach+0x68/0x8c
   [<c02332a8>] bus_probe_device+0x28/0xa0
   [<c0231a84>] device_add+0x3d8/0x594
   [<c027a45c>] usb_set_configuration+0x610/0x6bc
   [<c02821d4>] generic_probe+0x3c/0x74
   [<c027bcdc>] usb_probe_device+0x24/0x3c
   [<c0233d48>] driver_probe_device+0xb4/0x210
   [<c023243c>] bus_for_each_drv+0x48/0x8c
   [<c0233c50>] device_attach+0x68/0x8c
   [<c02332a8>] bus_probe_device+0x28/0xa0
   [<c0231a84>] device_add+0x3d8/0x594
   [<c0272c04>] usb_new_device+0x1dc/0x304
   [<c0274050>] hub_thread+0x9c4/0xf70
   [<c0034600>] kthread+0xa0/0xb0
   [<c00090a0>] ret_from_fork+0x14/0x34
irq event stamp: 139814
hardirqs last  enabled at (139811): [<c02a24e8>] 
cpuidle_enter_state+0x50/0x100
hardirqs last disabled at (139812): [<c0008b74>] __irq_svc+0x34/0xa0
softirqs last  enabled at (139814): [<c001d9c8>] irq_enter+0x44/0x64
softirqs last disabled at (139813): [<c001d9bc>] irq_enter+0x38/0x64

  might help us debug this:
  Possible unsafe locking scenario:
        CPU0
        ----
   lock(&(&sd->dyn_callback_lock)->rlock);
   <Interrupt>
     lock(&(&sd->dyn_callback_lock)->rlock);

**

1 lock held by swapper/0:
  #0:  (&(&sd->lock)->rlock){-.....}, at: [<c02af92c>] 
sensor_hub_raw_event+0x40/0x204

:
CPU: 0 PID: 0 Comm: swapper Not tainted 
3.10.5-dockstar-00038-g03242d1-dirty #408
[<c000d670>] (unwind_backtrace+0x0/0xe0) from [<c000b2bc>] 
(show_stack+0x10/0x14)
[<c000b2bc>] (show_stack+0x10/0x14) from [<c0396884>] 
(print_usage_bug.part.25+0x21c/0x284)
[<c0396884>] (print_usage_bug.part.25+0x21c/0x284) from [<c004d34c>] 
(mark_lock+0x438/0x65c)
[<c004d34c>] (mark_lock+0x438/0x65c) from [<c004db24>] 
(__lock_acquire+0x5b4/0x18f0)
[<c004db24>] (__lock_acquire+0x5b4/0x18f0) from [<c004f31c>] 
(lock_acquire+0x64/0x78)
[<c004f31c>] (lock_acquire+0x64/0x78) from [<c039c960>] 
(_raw_spin_lock+0x40/0x50)
[<c039c960>] (_raw_spin_lock+0x40/0x50) from [<c02af9f8>] 
(sensor_hub_raw_event+0x10c/0x204)
[<c02af9f8>] (sensor_hub_raw_event+0x10c/0x204) from [<c02a9a80>] 
(hid_input_report+0x148/0x170)
[<c02a9a80>] (hid_input_report+0x148/0x170) from [<c02b1a18>] 
(hid_irq_in+0x98/0x228)
[<c02b1a18>] (hid_irq_in+0x98/0x228) from [<c0275fa0>] 
(usb_hcd_giveback_urb+0x94/0xf0)
[<c0275fa0>] (usb_hcd_giveback_urb+0x94/0xf0) from [<c0284c7c>] 
(ehci_urb_done+0x6c/0x78)
[<c0284c7c>] (ehci_urb_done+0x6c/0x78) from [<c0287254>] 
(qh_completions+0x310/0x394)
[<c0287254>] (qh_completions+0x310/0x394) from [<c0289550>] 
(ehci_work+0x14c/0x780)
[<c0289550>] (ehci_work+0x14c/0x780) from [<c028a4cc>] 
(ehci_irq+0x21c/0x248)
[<c028a4cc>] (ehci_irq+0x21c/0x248) from [<c0275958>] 
(usb_hcd_irq+0x38/0x6c)
[<c0275958>] (usb_hcd_irq+0x38/0x6c) from [<c00621bc>] 
(handle_irq_event_percpu+0x2c/0x1a4)
[<c00621bc>] (handle_irq_event_percpu+0x2c/0x1a4) from [<c0062370>] 
(handle_irq_event+0x3c/0x5c)
[<c0062370>] (handle_irq_event+0x3c/0x5c) from [<c0064864>] 
(handle_level_irq+0xd0/0xe8)
[<c0064864>] (handle_level_irq+0xd0/0xe8) from [<c0061c40>] 
(generic_handle_irq+0x20/0x30)
[<c0061c40>] (generic_handle_irq+0x20/0x30) from [<c00098e8>] 
(handle_IRQ+0x60/0x84)
[<c00098e8>] (handle_IRQ+0x60/0x84) from [<c0008b78>] (__irq_svc+0x38/0xa0)
[<c0008b78>] (__irq_svc+0x38/0xa0) from [<c02a24f8>] 
(cpuidle_enter_state+0x60/0x100)
[<c02a24f8>] (cpuidle_enter_state+0x60/0x100) from [<c02a2674>] 
(cpuidle_idle_call+0xdc/0x144)
[<c02a2674>] (cpuidle_idle_call+0xdc/0x144) from [<c0009a2c>] 
(arch_cpu_idle+0x8/0x44)
[<c0009a2c>] (arch_cpu_idle+0x8/0x44) from [<c0042ebc>] 
(cpu_startup_entry+0x80/0xec)
[<c0042ebc>] (cpu_startup_entry+0x80/0xec) from [<c050a750>] 
(start_kernel+0x29c/0x2e4)
----------
