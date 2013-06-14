Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3FNTLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:11:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57149 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3FNTLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:11:14 -0400
Message-ID: <51BB6ACF.9050702@linaro.org>
Date: Fri, 14 Jun 2013 12:11:11 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 6/9 v3] RFC: timekeeping: rtc: remove CONFIG_RTC_HCTOSYS
 and RTC_HCTOSYS_DEVICE
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-7-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1371228732-5749-7-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:52 AM, Alexander Holler wrote:
> Those config options don't make sense anymore with the new hctosys
> mechanism introduced with the previous patch.
>
> That means two things:
>
> - If a (hardware) clock is available it will be used to set the time at
>    boot. This was already the case for system which have a "persistent"
>    clock, e.g. most x86 systems. The only way to specify the device used
>    for hctosys is now by using the kernel parameter hctosys= introduced
>    with a previous patch.
>
> - If a hardware clock was used for hctosys before suspend, this clock
>    will be used to adjust the clock at resume. Again, this doesn't change
>    anything on systems with a "persistent" clock.
>
> What's missing:
>
> I don't know much about those "persistent" clocks and I haven't had a
> deep look at them. That's especially true for the suspend/resume
> mechanism used by them. The mechanism I want to use is the following:
> The RTC subsystem now maintains the ID of the RTC device which was used
> for hctosys (in rtc_hctosys_dev_id) and therefor specifies the device
> which should be used to adjust the time after resume. Additionaly the
> (new) flag systime_was_set will be set to false at suspend and on resume
> this flag will be set to true if either the clock will be adjusted by
> the device used for hctosys or by userspace (through do_settimeofday()).
>
> That all should already work as expected for RTCs, what's missing for
> "persistent" clocks is that the flag systime_was_set is set to false on
> suspend and set to true on resume. Currently it just stays at true
> (which is set through hctosys if a "persistent" clock is found.
> But because "persistent" clocks don't go away (as it is possible with
> RTCs by removing the driver or the RTC itself), nor do "persistent"
> clocks might have two instances, this shouldn't be a problem at all.

This one concerns me a bit. Since you're removing quite a bit and it 
looks like it may break userland expectations.

I ran into this myself recently, when I found some distros look for 
/sys/class/rtc/rtcN/hctosys in order to determine which rtc device 
should be synced with from userland.

So I'd probably suggest instead to re-factor this so you leave all the 
hctosys bits alone, but just change it from being called by a 
late_initcall() and instead have it called when we register the RTC that 
matches CONFIG_RTC_HCTOSYS_DEVICE.

I suspect it will end up being a much smaller change that way.

Then the last bit is just a matter of adding the 
timekeeping_systimeset() check to the hctosys bits.


thanks
-john

