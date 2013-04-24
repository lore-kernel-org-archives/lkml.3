Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab3DXVY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:24:56 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59396 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab3DXVYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:24:55 -0400
Message-ID: <51784DA3.5030003@linaro.org>
Date: Wed, 24 Apr 2013 14:24:51 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: lkml <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time
 optimizaitons
References: <1366828376-18124-1-git-send-email-john.stultz@linaro.org> <CAPXgP123q9K8-NibkpmbvwpRTM1cdODWycq3o-HdWEYBwoGCFQ@mail.gmail.com> <51782A9D.20303@linaro.org> <CAPXgP12UmmcSDUg60mM08AD=P-Qsy_RabfkDifDFMAp0_1EbLQ@mail.gmail.com>
In-Reply-To: <CAPXgP12UmmcSDUg60mM08AD=P-Qsy_RabfkDifDFMAp0_1EbLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 12:18 PM, Kay Sievers wrote:
> On Wed, Apr 24, 2013 at 8:55 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On 04/24/2013 11:41 AM, Kay Sievers wrote:
>>> On Wed, Apr 24, 2013 at 8:32 PM, John Stultz <john.stultz@linaro.org>
>>> wrote:
>>>> Kay Sievers noted that the ALWAYS_USE_PERSISTENT_CLOCK config,
>>>> which enables some minor compile time optimization to avoid
>>>> uncessary code in mostly the suspend/resume path could cause
>>>> problems for userland.
>>>>
>>>> In particular, the dependency for RTC_HCTOSYS on
>>>> !ALWAYS_USE_PERSISTENT_CLOCK, which avoids setting the time
>>>> twice and simplifies suspend/resume, has the side effect
>>>> of causing the /sys/class/rtc/rtcN/hctosys flag to always be
>>>> zero, and this flag is commonly used by udev to setup the
>>>> /dev/rtc symlink to /dev/rtcN, which can cause pain for
>>>> older applications.
>>> FWIW, in the light of the original change, I've just removed the
>>> /dev/rtc creation from the default udev rules now, so that thing will
>>> be phased out in the future.
>> Is that actually wanted? What happens to applications that use /dev/rtc?
>>
>> I think setting up the /dev/rtc link is important. Its just that setting it
>> up exclusively by the hctosys flag is maybe more fragile then we'd like.
>> Instead the hctosys flag maybe should only be used as a hint if there is
>> more then one RTC available.
> So far we only created the symlink for an rtc with the hctosys flag
> set. It was added as a workaround for ARM, which sometimes has
> multiple RTCs. But there is now also logic in udev/systemd anyway to
> search for the system's rtc, which does not rely on the symlink. Other
> commonly used tools we checked just use /dev/rtc0 directly.

Yea, but there are likely a number of legacy applications that will 
still need the /dev/rtc link. I remember lots of pain when the /dev/rtcN 
devices showed up, and I suspect that's all been quiet due to the 
/dev/rtc links.

Dropping that link seems way too risky to me, thus why I'm submitting a 
revert. As I didn't realize the link was dependent on the hctosys flag.


> As mentioned in the mail yesterday, I expected that
> CONFIG_RTC_HCTOSYS=y was also needed on x86. The current udev logic
> would need updating anyway, if we disable CONFIG_RTC_HCTOSYS=y now. So
> let's just find out what's really needed here and add it back properly
> if something really needs it.

I'm really fine with the revert, and would like to avoid any userland 
changes. There's more changes to come in that area of the kernel, so if 
there is any userland implications (which I'd actually prefer to avoid), 
lets make sure they are well thought out and not rushed.

> While we are at it, the interface to read and set the persistent clock
> from userspace, the clock the kernel internally uses, is still to just
> use the /dev/rtc0 device with the ioctls? There is no other native
> kernel timer interface or something else for that, right?

Right, the persistent_clock is only useful to the kernel over the RTC in 
the case where interrupts are disabled. Userland should stick to the 
RTC, and we shouldn't expose the persistent_clock out to userland. I'm 
hoping we'll be able to push the persistent_clock functionality into the 
RTC code (though I suspect the micro embedded folks will complain about 
having to compile the generic rtc core in as well - though we can always 
leave time initialization to userland for those crazier cases).

thanks
-john
