Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbbAGUer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:34:47 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:56031 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbbAGUeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:34:46 -0500
Date: Wed, 7 Jan 2015 15:34:42 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
References: <20150104190123.GA20153@amd> <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr> <20150104201026.GA23427@amd> <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr> <20150104203724.GA16372@amd> <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com> <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr> <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com> <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr> <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Linus Torvalds wrote:

> On Wed, Jan 7, 2015 at 11:00 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> >
> > We'll make sure it is scaled properly so not to have orders of magnitude
> > discrepancy whether the timer based or the CPU based loop is used for
> > the purpose of making people feel good.
> 
> Why?
> 
> You'd basically be lying.  And it might actually hide real problems.
> If the scaling hides the fact that the timer source cannot do a good
> job at microsecond resolution delays, then it's not just lying, it's
> lying in ways that hide real issues. So why should that kind of
> behavior be encouraged? The actual *real* unscaled resolution of the
> timer is valid and real information.

I think you are missing something fundamental in this thread.

On ARM, when the timer is used to provide small delays, it is typically 
the ARM architected timer which by definition must have a constant input 
clock in the MHz range.  This timer clock has *nothing* to do with 
whatever CPU clock you might be using.  On the system I have here, the 
CPU clock is 2GHz and the timer used for delays is 24MHz.  If the CPU 
clock is scaled down to 180MHz the timer clock remains at 24MHz.

The implementation of udelay() in this case is basically doing:

void udelay(unsigned long usecs)
{
	unsigned long timer_ticks = usecs * (24000000 / 1000000);
	unsigned long start = read_timer_count();
	while (read_timer_count() - start < timer_ticks);
}

Some other systems might as well have a completely different timer clock 
based on what its hardware designers thought was best, or based on what 
they smoked the night before.  There is no calibrating of the timer 
input clock: it is just set and the timer clock rate for a given 
hardware implementation is advertised by the firmware.  No calibration 
is necessary.  No calibration would even be possible if that's the only 
time source on the system.

Now tell me what this means for bogomips?  Nothing.  Absolutely nothing. 
Deriving a bogomips number from a 24MHz timer clock that bares no 
relationship with the CPU clock is completely useless.  We might as well 
hardcode a constant 1.00 and be done with it.  Or hash the machine name 
and add the RTC time and report that.  At least the later would have 
some entertainment value.

What I'm suggesting is to leave the timer based udelay() alone as it 
doesn't need any loops_per_jiffy or whatnot to operate.  Then, for the 
semi-entertaining value of having *something* displayed alongside 
"bogomips" in /proc/cpuinfo I'm suggesting to simply calibrate 
loops_per_jiffy the traditional way in all cases, whether or not a 
timer based udelay is in use.

Why you might have having a problem with that is beyond my 
understanding.


Nicolas
