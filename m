Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaFKXx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:53:57 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:65411 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaFKXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:53:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140611230127.GA28066@griso.site>
References: <20140611230127.GA28066@griso.site>
Date: Wed, 11 Jun 2014 16:53:55 -0700
X-Google-Sender-Auth: ppIIVQkZM-_E_i71Ye3uOl8zGo4
Message-ID: <CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com>
Subject: Re: rtc/hctosys.c Problem during kernel boot
From: John Stultz <john.stultz@linaro.org>
To: John Whitmore <arigead@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 4:01 PM, John Whitmore <arigead@gmail.com> wrote:
> I'm having a problem with a DS3234 SPI based RTC chip and rtc/hctosys.c on the
> 3.10.29 kernel of the RaspberryPi. I'm not sure this is a bug or not but
> thought I'd ask. I've enabled the kernel config option for HCTOSYS which, on
> boot, should set the system's date/time to the value read from the RTC. I
> tried tihs but it would never happen on the RPi. I eventually found in syslog
> that the kernel boot is attempting to execute the hctosys functionality prior
> to the SPI being initialised. As a result of this when hctosys is attempted
> there is not /dev/rtc0 yet. A short time later the DS3234 RTC is initialised
> but by then it's too late.
>
> Once the system has booted and I've logged in I can read and write to the RTC
> and all seems good but /sys/class/rtc/rtc0/hctosys is '0' indicating that the
> system time was not set on boot.
>
> There is a "deprecated" warning in the syslog coming from the spi of the board
> file so perhaps that is the cause. So is this a bug? And if so what can I do
> to resolve it. The hctosys is on a "late_initcall" so not sure of timing.

Sigh. Yea, this issue was brought up previously, but we never got
around to a solution that could be merged.

Basically hctosys is late_init, but if the driver is a module, it
might not be loaded in time. Adding hooks at module load time when
RTCs are registered could be done, but then you have the issue that
userspace might have set the clock via something like ntpdate, so
HCTOSYS could then cause the clock to be less accurate.

So we need to make the HCTOSYS functionality happen at RTC register
time, but it needs to set the clock only if nothing has set the clock
already. This requires a new timekeeeping interface - something like
timekeeping_set_time_if_unset(), which atomically would set the time
if it has never been set.

You can read some of the previous discussion here:
https://lkml.org/lkml/2013/6/17/533

I'd be very interested in patches to resolve this!

thanks
-john
