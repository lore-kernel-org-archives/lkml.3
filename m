Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075Ab3FMUEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 16:04:37 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:58462 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab3FMUEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 16:04:36 -0400
Message-ID: <51BA1FF7.4000206@ahsoftware.de>
Date: Thu, 13 Jun 2013 21:39:35 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: [PATCH 2/3 v2] RFC: timekeeping: rtc: Introduce new kernel parameter
 hctosys
References: <1370452540-3319-1-git-send-email-holler@ahsoftware.de> <1370515910-2883-1-git-send-email-holler@ahsoftware.de> <1370515910-2883-3-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1370515910-2883-3-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.06.2013 12:51, schrieb Alexander Holler:
> hctosys= specifies the driver (RTC) name which sets the system clock at
> boot, if and only if userspace hasn't set the time before the driver will
> be loaded.
>
> If hctosys will not be specified, the first available hardware clock
> with a valid time will be used (again, if and only if ...).
>
> If you don't want that the system clock will be set by any hardware clock,
> just specify a non-existent RTC driver name, e.g. with hctosys=none.
>
> Currently there exist a special name "persistent" for the persistent clock
> found on some systems (e.g. the CMOS clock on x86 platforms which might be
> handled by the driver named rtc_cmos too).
>
> This will replace the existent driver/mechanism hctosys and the kernel
> config options CONFIG_RTC_HCTOSYS and CONFIG_RTC_HCTOSYS_DEVICE (done
> with one of the following patches)
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>

While implementing support for high resolution (read-only) clocks (e.g. 
radio or GPS) for the new hctosys, I've found another bug in my (quickly 
done) RFC hctosys implementation.

Instead of posting the whole patch or the whole series again, here is 
the small diff which should be added to patch2/3:

----------
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 49dd97c..e101468 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -795,7 +795,7 @@ void __init timekeeping_init(void)
         struct timekeeper *tk = &timekeeper;
         struct clocksource *clock;
         unsigned long flags;
-       struct timespec now, boot, tmp;
+       struct timespec now = {0, 0}, boot, tmp;

         if (!hctosys_name[0] || !strcasecmp(hctosys_name, "persistent")) {
                 read_persistent_clock(&now);
----------

I now have 4 additional patches here:

rtc: rtc-hid-sensor-time: delay registering as rtc into a work
rtc: implement rtc_read_timeval()
rtc: hctosys: support rtc_read_timeval() for high precision clocks
rtc: rtc-hid-sensor-time: add support for rtc_read_timeval()

The first oatch is necessary because registering a rtc wants to read the 
clock (for hctosys) and in case of the HID RTC this only works after the 
HID device is actually registered. Therefor registering should not 
happen in probe().

The other 3 new patches do add a read_timeval to rtc_ops and use it, if 
available, instead of read_time to retrieve and set the system clock 
with hctosys using a higher precision timestamp (us).

I requested, I will post the whole series or the just the 
additional/fixed patches.

Regards,

Alexander Holler

