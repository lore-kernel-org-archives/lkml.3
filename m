Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbaLAVMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:12:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:45153 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:12:53 -0500
Date: Mon, 1 Dec 2014 22:12:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH 3/4] rtc/lib: Provide interfaces to map between 32bit
 hardware and 64bit time
In-Reply-To: <CADcy93Vk96E0djD3rFYtKr_kBcwCJOEesg_UW_ZdGv=B_uM8Ug@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412012121500.3961@nanos>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org> <1417089760-26848-4-git-send-email-pang.xunlei@linaro.org> <alpine.DEB.2.11.1411280005500.3961@nanos> <CADcy93Vk96E0djD3rFYtKr_kBcwCJOEesg_UW_ZdGv=B_uM8Ug@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2014, pang.xunlei wrote:
> On 28 November 2014 at 07:16, Thomas Gleixner <tglx@linutronix.de> wrote:
> > How is that going to be useful w/o a mechanism to adjust the epoch
> > offset at runtime by any means?
> 
> If the rtc epoch changes at runtime, we'll not get the right time once
> the system is rebooting.
> So, it can only be altered throught command line, and must stay
> invariable ever since unless it uses NTP or something.

You are imposing that any machine which needs to handle this must be
rebooted in order to get support for the HW wrap around of the 32bit
seconds counter register.

That's wrong to begin with, simply because you would have to update
the command line and reboot all those machines a few milliseconds
before the wrap around occurs. Not very practicable, right?

Your argument that we wont get the proper time once the
system is rebooting is moot, as in any case there needs to be some
persistant storage which must be updated either to hold the offset
itself or the kernel command line.

So we want a mechanism to apply that change at runtime by whatever
mechanism. And that can be an ad hoc change where we update the offset
and the counter value in one go or a simple store operation which gets
effective when the counter actually wraps around.

That needs a lot more thought so I think we should drop that whole
offset magic for now and concentrate on the far more pressing problem
of time_t which affects all machines in about 24 years.

Once we have done that we can revisit the 2106 problem and design a
well thought out mechanism to handle it and not some cobbled together
ad hoc solution.

That said, I'm not too happy about your comments copied all over the
place. We rather have something which can be easily grepped for, does
not lose context and can be in the best case runtime evaluated.

The simplest solution for this is to do the following:

struct rtc_class_ops {
       ...
       int (*set_mmss)(struct device *, unsigned long secs);
+      int (*set_mmss64)(struct device *, time64_t secs);

So any RTC which is capable of handling time past 2106 will be
converted to use the new interface and leave the set_mmss callback
NULL. The device drivers which cannot be converted to handle anything
past 2106 due to hardware limitations do not need to be touched at
all.

Though we might to consider changing set_mmss() to 
-      int (*set_mmss)(struct device *, unsigned long secs);
+      int (*set_mmss32(struct device *, u32 secs);

but that can be done when the bulk has been converted to
set_mmss64. That's a single coccinelle patch w/o adding randomly
typoed comments to the wrong places.

You can find that nicely with grep, you can detect it compile time by
removing the set_mmss callback and you can evaluate it at runtime.

Once we have a proper solution for the 2106 issue we have a clear
indicator which of the drivers needs that treatment and which ones do
not. We just can deduce it from the set_mmss callback assignment.

Thanks,

	tglx
