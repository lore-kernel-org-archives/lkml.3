Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab3DYSdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 14:33:09 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:34729 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759333Ab3DYSdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 14:33:07 -0400
Date: Thu, 25 Apr 2013 12:33:01 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Alexander Holler <holler@ahsoftware.de>, Kay Sievers <kay@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
Message-ID: <20130425183301.GA31863@obsidianresearch.com>
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
 <517746E4.908@linaro.org>
 <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
 <51774F44.2060704@linaro.org>
 <517769A9.5060308@ahsoftware.de>
 <51780348.6090202@linaro.org>
 <5178D719.2060405@ahsoftware.de>
 <5179562C.3000903@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5179562C.3000903@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 09:13:32AM -0700, John Stultz wrote:
> On 04/25/2013 12:11 AM, Alexander Holler wrote:
> >Am 24.04.2013 18:07, schrieb John Stultz:
> >
> >>>And why is RTC_SYSTOHC now gone on x86?
> >>
> >>So summarizing the above, because as much as I'm aware, its always been
> >>redundant and unnecessary on x86.  Thus being able at build time to mark
> >>it as unnecessary was attractive, since it reduced the code paths
> >>running at suspend/resume.
> >
> >Hmm, I thought RTC_SYSTOHC was there to update the used RTC clock
> >with the time from NTP (and liked that). Therefor I don't
> >understand why it is redundant and unnecessary on x86. Of course,
> >most systems do have something in userspace to set the RTC on
> >shutdown, so it isn't really needed.
> 
> Prior to SYSTOHC being introduced, we only synced system time to the
> RTC via update_persistent_clock() on systems that had that
> interface. SYSTOHC is relatively new and lets the system sync to
> RTCs that don't have the persistent clock.

Right,

Per John's comments on SYSTOHC, when enabled, NTP still always prefers
the update_persistent_clock clock path if it is available, to avoid
any possible unforseen breakage.

In most cases GENERIC_CMOS_UPDATE and SYSTOHC would ultimately call
exactly the same code, but x86 is very complex in this area and they
can call different code. GENERIC_CMOS_UPDATE calls
arch/x86/kernel/rtc.c:mach_set_rtc_mmss() and SYSTOHC calls
include/asm-generic/rtc.h:__set_rtc_time() (AFAICT)

I would think the SYSTOHC path is the better choice because it is the
path used by userspace /dev/rtc* access and is certainly more tested -
but I don't know for sure. For instance, the NTP path was once
specially optimized to align the second tick of the RTC to the system
clock and I can't tell if both functions have that property.

Anyhow, I think at this point update_persistent_clock and
CONFIG_GENERIC_CMOS_UPDATE are archaic - I left them in when I made
the SYSTOHC patch because untangling everything is a big job.

John mentioned they might be kept for embedded - eg size reduction.
The issue with that idea is if you do not enable the class RTC
subsystem then there is no way for a small embedded userspace to set
the RTC. The /dev/rtc* device obviously goes away, but it also turns
out that that CONFIG_GENERIC_CMOS_UPDATE only works when combined with
a heavy weight userspace NTPD that runs the kernel PLL properly. The
kernel NTP code is enormously conservative and it is actually quite
hard to get it to write to the RTC. An RTC that cannot be set is
useless, so these days I feel CONFIG_RTC is pragmatically mandatory -
and my space constrained embedded systems do set it, for these
reasons.

So, my conclusion is nobody with a RTC looking for space savings, will
disable CONFIG_RTC, which means we can safely rely on
CONFIG_RTC_SYSTOHC to do this work. To that end, I would encourage
everyone who sets CONFIG_GENERIC_CMOS_UPDATE to also set
CONFIG_RTC_SYSTOHC - that will let update_persistent_clock to be
ripped out over time without impacting users.

Regards,
Jason
