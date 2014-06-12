Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaFLBIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:08:06 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62939 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaFLBIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:08:05 -0400
Date: Thu, 12 Jun 2014 02:06:46 +0100
From: John Whitmore <arigead@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: rtc/hctosys.c Problem during kernel boot
Message-ID: <20140612010643.GA28976@griso.site>
References: <20140611230127.GA28066@griso.site>
 <CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:53:55PM -0700, John Stultz wrote:
> On Wed, Jun 11, 2014 at 4:01 PM, John Whitmore <arigead@gmail.com> wrote:
> > I'm having a problem with a DS3234 SPI based RTC chip and rtc/hctosys.c on the
> > 3.10.29 kernel of the RaspberryPi. I'm not sure this is a bug or not but
> > thought I'd ask. I've enabled the kernel config option for HCTOSYS which, on
> > boot, should set the system's date/time to the value read from the RTC. I
> > tried tihs but it would never happen on the RPi. I eventually found in syslog
> > that the kernel boot is attempting to execute the hctosys functionality prior
> > to the SPI being initialised. As a result of this when hctosys is attempted
> > there is not /dev/rtc0 yet. A short time later the DS3234 RTC is initialised
> > but by then it's too late.
> >
> > Once the system has booted and I've logged in I can read and write to the RTC
> > and all seems good but /sys/class/rtc/rtc0/hctosys is '0' indicating that the
> > system time was not set on boot.
> >
> > There is a "deprecated" warning in the syslog coming from the spi of the board
> > file so perhaps that is the cause. So is this a bug? And if so what can I do
> > to resolve it. The hctosys is on a "late_initcall" so not sure of timing.
> 
> Sigh. Yea, this issue was brought up previously, but we never got
> around to a solution that could be merged.
> 
> Basically hctosys is late_init, but if the driver is a module, it
> might not be loaded in time. Adding hooks at module load time when
> RTCs are registered could be done, but then you have the issue that
> userspace might have set the clock via something like ntpdate, so
> HCTOSYS could then cause the clock to be less accurate.
> 
> So we need to make the HCTOSYS functionality happen at RTC register
> time, but it needs to set the clock only if nothing has set the clock
> already. This requires a new timekeeeping interface - something like
> timekeeping_set_time_if_unset(), which atomically would set the time
> if it has never been set.
> 
> You can read some of the previous discussion here:
> https://lkml.org/lkml/2013/6/17/533
> 

Thanks a million for that information I'll have a look, as I might try and
resolve the issue.

> I'd be very interested in patches to resolve this!
> 
> thanks
> -john
