Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3DXTSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 15:18:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59112 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab3DXTSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 15:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <51782A9D.20303@linaro.org>
References: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
 <CAPXgP123q9K8-NibkpmbvwpRTM1cdODWycq3o-HdWEYBwoGCFQ@mail.gmail.com> <51782A9D.20303@linaro.org>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 24 Apr 2013 21:18:29 +0200
Message-ID: <CAPXgP12UmmcSDUg60mM08AD=P-Qsy_RabfkDifDFMAp0_1EbLQ@mail.gmail.com>
Subject: Re: [PATCH] time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 8:55 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 04/24/2013 11:41 AM, Kay Sievers wrote:
>>
>> On Wed, Apr 24, 2013 at 8:32 PM, John Stultz <john.stultz@linaro.org>
>> wrote:
>>>
>>> Kay Sievers noted that the ALWAYS_USE_PERSISTENT_CLOCK config,
>>> which enables some minor compile time optimization to avoid
>>> uncessary code in mostly the suspend/resume path could cause
>>> problems for userland.
>>>
>>> In particular, the dependency for RTC_HCTOSYS on
>>> !ALWAYS_USE_PERSISTENT_CLOCK, which avoids setting the time
>>> twice and simplifies suspend/resume, has the side effect
>>> of causing the /sys/class/rtc/rtcN/hctosys flag to always be
>>> zero, and this flag is commonly used by udev to setup the
>>> /dev/rtc symlink to /dev/rtcN, which can cause pain for
>>> older applications.
>>
>> FWIW, in the light of the original change, I've just removed the
>> /dev/rtc creation from the default udev rules now, so that thing will
>> be phased out in the future.
>
> Is that actually wanted? What happens to applications that use /dev/rtc?
>
> I think setting up the /dev/rtc link is important. Its just that setting it
> up exclusively by the hctosys flag is maybe more fragile then we'd like.
> Instead the hctosys flag maybe should only be used as a hint if there is
> more then one RTC available.

So far we only created the symlink for an rtc with the hctosys flag
set. It was added as a workaround for ARM, which sometimes has
multiple RTCs. But there is now also logic in udev/systemd anyway to
search for the system's rtc, which does not rely on the symlink. Other
commonly used tools we checked just use /dev/rtc0 directly.

As mentioned in the mail yesterday, I expected that
CONFIG_RTC_HCTOSYS=y was also needed on x86. The current udev logic
would need updating anyway, if we disable CONFIG_RTC_HCTOSYS=y now. So
let's just find out what's really needed here and add it back properly
if something really needs it.

While we are at it, the interface to read and set the persistent clock
from userspace, the clock the kernel internally uses, is still to just
use the /dev/rtc0 device with the ioctls? There is no other native
kernel timer interface or something else for that, right?

Thanks,
Kay
