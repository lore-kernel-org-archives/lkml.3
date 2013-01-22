Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3AVAir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:38:47 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:32904 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3AVAiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:38:46 -0500
Message-ID: <50FDDF93.5030407@linaro.org>
Date: Mon, 21 Jan 2013 16:38:43 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Sealey <matt@genesi-usa.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com> <50FDC2DD.7090406@linaro.org> <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com>
In-Reply-To: <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 02:54 PM, Matt Sealey wrote:
> On Mon, Jan 21, 2013 at 4:36 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On 01/21/2013 01:14 PM, Matt Sealey wrote:
>>> Or is this one of those things that if your platform doesn't have a
>>> real high resolution timer, you shouldn't enable HRTIMERS and
>>> therefore not enable SCHED_HRTICK as a result? That affects
>>> ARCH_MULTIPLATFORM here. Is the solution as simple as
>>> ARCH_MULTIPLATFORM compliant platforms kind of have to have a high
>>> resolution timer? Documentation to that effect?
>> SO HRITMERS was designed to be be build time enabled, while still giving you
>> a functioning system if it was booted on a system that didn't support
>> clockevents.  We boot with standard HZ, and only switch over to HRT mode if
>> we have a proper clocksource and clockevent driver.
> Okay. I'm still a little confused as to what SCHED_HRTICK actually
> makes a difference to, though.
>
>  From that description, we are booting with standard HZ on ARM, and the
> core sched_clock (as in we can call setup_sched_clock)
> and/or/both/optionally using a real delay_timer switch to HRT mode if
> we have the right equipment available in the kernel and at runtime on
> the SoC.. but the process scheduler isn't compiled with the means to
> actually take advantage of us being in HRT mode?

So I'm actually not super familiar with SCHED_HRTICK details, but from 
my brief skim of it it looks like its useful for turning off the 
periodic timer tick, and allowing the scheduler tick to be triggered by 
an hrtimer itself (There's a number of these interesting inversions that 
go on in switching to HRT mode - for instance, standard timer ticks are 
switched to being hrtimer events themselves).

This likely has the benefit of time-accurate preemption (well, long 
term, as if the timer granularity isn't matching you could be delayed up 
to a tick - but it wouldn't drift).

I'm guessing Thomas would probably know best what the potential issues 
would be from running ((CONFIG_HRTIMER  || CONFIG_NO_HZ) && 
!CONFIG_SCHED_HRTICK).

thanks
-john
