Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbbAGVPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:15:06 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:45652 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbbAGVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:15:04 -0500
Date: Wed, 7 Jan 2015 16:15:00 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <20150107205346.GO12302@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1501071558000.1322@knanqh.ubzr>
References: <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr> <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com> <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
 <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com> <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com> <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr> <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
 <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr> <20150107205346.GO12302@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Russell King - ARM Linux wrote:

> On Wed, Jan 07, 2015 at 03:34:42PM -0500, Nicolas Pitre wrote:
> > On Wed, 7 Jan 2015, Linus Torvalds wrote:
> > 
> > > On Wed, Jan 7, 2015 at 11:00 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > > >
> > > > We'll make sure it is scaled properly so not to have orders of magnitude
> > > > discrepancy whether the timer based or the CPU based loop is used for
> > > > the purpose of making people feel good.
> > > 
> > > Why?
> > > 
> > > You'd basically be lying.  And it might actually hide real problems.
> > > If the scaling hides the fact that the timer source cannot do a good
> > > job at microsecond resolution delays, then it's not just lying, it's
> > > lying in ways that hide real issues. So why should that kind of
> > > behavior be encouraged? The actual *real* unscaled resolution of the
> > > timer is valid and real information.
> > 
> > I think you are missing something fundamental in this thread.
> 
> I think what Linus is trying to tell us is that:
> 
> 1. Where the kernel uses a software loop for implementing delays,
>    the kernel bogomips gives us a calibration of that loop.
> 
> 2. Where the kernel uses a hardware timer for implementing delays,
>    the kernel bogomips gives us a calibration of that hardware timer.
> 
> And it doesn't matter whether or not that timer has anything to do with
> the raw CPU speed.
> 
> In other words, bogomips is a statement about the accuracy of the
> internal kernel mechanism being used for delays, nothing more, nothing
> less.

I'm not clear if that's actually what Linus is trying to tell us.

But that statement makes no sense at all.  Why would user space care 
about kernel internal mechanism for small delays?  This hardly has any 
influence on user space and I just can't imagine any user space code 
consuming the bogomips value for that purpose.

What user space did with bogomips, though, is to get some relative 
measure of the CPU speed for whatever calibration purposes, or simply 
for pretty printing.

> Now, if I understand Linus correctly, what irks him is when someone
> upgrades a kernel on a platform, and some userland breaks.  That's
> something which I've said multiple times I don't have a problem
> agreeing with, and I suspect no one in this thread would disagree
> that this is a serious failing, and one which needs fixing ASAP.

I agree too.  And that is fixed in mainline with commit 4bf9636c39.

> However, if running userland on platform A works, and but it doesn't
> work on platform B.  The breakage may well be due to platform A reporting
> 300 bogomips because it's using the kernel software loop, and platform
> B reporting 6 bogomips because its using a hardware timer, but the CPU
> is actually faster.  However, this is not a kernel problem, and it
> certainly is not a regression.  It's a userspace bug which needs
> userspace to fix.

There I disagree.  In the spirit of "the kernel shall never break user 
space ever" I'd say that the kernel is simply doing a poor job at 
providing user space with a value that won't break user space 
expectations.  And since it is not that hard to do (I made a patch 
already) I'd say we have less to lose by fixing it than keeping a 
totally senseless value around.


Nicolas
