Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3DXQHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:07:40 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39729 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3DXQHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:07:39 -0400
Message-ID: <51780348.6090202@linaro.org>
Date: Wed, 24 Apr 2013 09:07:36 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Kay Sievers <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com> <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com> <51774F44.2060704@linaro.org> <517769A9.5060308@ahsoftware.de>
In-Reply-To: <517769A9.5060308@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 10:12 PM, Alexander Holler wrote:
> Hello,
>
> Am 24.04.2013 05:19, schrieb John Stultz:
>
>> On x86 the persistent_clock() is backed by the
>> CMOS/EFI/kvm-wall/xen/vrtc clock (all via x86_platform.get_wallclock)
>> should be present and we'll initialize the time in timekeeping_init()
>> there.
>>
>> Its only systems where there isn't a persistent_clock is where the RTC
>> layer and the HCTOSYS is helpful.
>
> I'm a bit confused too. ;)
>
> Doesn't this remove the users choice of RTC on x86 systems?

So the userland interfaces for the RTCs are still present.


>
> Why is there a difference made between the CMOS/EFI/... clocks and 
> other RTCs?

Its a mostly history.  Way way back, timekeeping was mostly arch 
specific, and we initialized time with arch specific RTC code. After the 
generic timekeeping went in, the persistent_clock() interface was 
created as a generic interface to CMOS and other RTCs. The catch being, 
since we access the persistent_clock() in very early init as well as 
very late suspend and very early resume, the persistent_clock has to be 
able to function when interrupts are off.

Now, somewhere near this time (my memory is foggy), the generic RTC 
driver infrastructure was also created, pulling most of the RTC drivers 
out of arch specific code and into the generic driver code. The problem 
there was there were many RTCs that were accessed over buses that 
required interrupts to be enabled. So there was no way for the generic 
timekeeping code to use the generic RTC code.

Additionally, since the generic RTC code didn't provide what was needed 
for the persistent_clock interface, we ended up with duplicated code for 
things like the CMOS clock in both drivers/rtc/rtc-cmos.c, and 
arch/x86/kernel/rtc.c

For those (not too common) systems that didn't have a persistent_clock, 
the RTC framework gained the HCTOSYS option, that would set the clock at 
driver init time, as well as on resume.


Now this HCTOSYS approach had some problems that didn't really become 
too apparent until ARM started to get much more popular. First of all, 
since it just set the time on resume we didn't properly measure suspend 
time. So we had to add some special timekeeping interfaces and changes 
to measure the time from the RTC device suspend to RTC device resume.


Unfortuantely this still has a problem, because we have to stop and 
start timekeeping very late in the suspend and early in the resume path. 
Thus any latency between rtc device suspend -> timekeeping suspend and 
timekeeping resume -> rtc device resume, introduces time error. Some 
tweaks have been added to try to bound this error, but its still not ideal.

Now, the persistent_clock() code is nicer for this, since we access it 
in timekeeping suspend and resume, which reduces the introduced error. 
Also, because the persistent_clock it provides an nsec interface rather 
then a sec granular interface, so we can utilize finer grained hardware 
to avoid adding extra error when measuring suspend, where that's available.


Now, on systems that had a persistent_clock, enabling HCTOSYS caused 
some (minor trouble), since we would then repeatedly set the time twice 
at boot up (once in timekeeping_init, and then again in RTC init paths). 
Additionally, during suspend and resume, we would measure suspend in 
timekeeping_resume and get things correct, and then the rtc resume would 
set the time again, causing error. When rtc suspend/resume was tweaked 
to measure suspend time, then we had to be extra careful, since there 
were now two systems measuring suspend and trying to update the clock, 
so we could end up with time moving forward 2x suspend time.

Since that point, the code has basically ignored the HCTOSYS path on 
resume if the persistent_clock was present, which is always true on x86.

> And why is RTC_SYSTOHC now gone on x86?

So summarizing the above, because as much as I'm aware, its always been 
redundant and unnecessary on x86.  Thus being able at build time to mark 
it as unnecessary was attractive, since it reduced the code paths 
running at suspend/resume.

That said, Kay's concerns about userland implications (basically the 
userland side effects of SYSTOHC being enabled) give me pause, so I may 
revert the HAS_PERSISTENT_CLOCK on x86 change.


And again, after recent discussions with both Feng Tang and Jason 
Gunthorpe, there's a visible path forward that will hopefully remove 
some of the redundancy above:

* Adding special no-irq safe accessors to the RTC driver infrastrucutre, 
so the persistent_clock can use the RTC code directly (allowing the 
removal of duplicated code)

* Separating the persistent_clock functionality into separate time 
initialization and suspend timing functions.


Though I'm not sure when in the near term I'll have to start 
implementing this, so I'd be happy to work with interested parties to 
get this cleaned up.

thanks
-john



