Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaIXOuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:50:50 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40950 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751937AbaIXOur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:50:47 -0400
Date: Wed, 24 Sep 2014 15:50:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nathan Lynch <Nathan_Lynch@mentor.com>
Cc: Christopher Covington <cov@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Sonny Rao <sonnyrao@chromium.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] arm_arch_timer: VDSO preparation, code
	consolidation
Message-ID: <20140924145025.GX5182@n2100.arm.linux.org.uk>
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com> <20140922153919.GQ25809@arm.com> <20140922223022.GO5182@n2100.arm.linux.org.uk> <5420BE92.7050504@mentor.com> <5422D138.8000002@codeaurora.org> <5422D616.7060807@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5422D616.7060807@mentor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:32:54AM -0500, Nathan Lynch wrote:
> On 09/24/2014 09:12 AM, Christopher Covington wrote:
> > Hi Nathan,
> > 
> > On 09/22/2014 08:28 PM, Nathan Lynch wrote:
> >> Hmm, this patch set is merely exposing the hardware counter when it is
> >> present for the VDSO's use; I take it you have no objection to that?
> >>
> >> While the 32-bit ARM VDSO I've posted (in a different thread) exploits a
> >> facility that is required by the virtualization option in the
> >> architecture, its utility is not limited to guest operating systems.
> > 
> > Just to clarify, were the performance improvements you measured from a
> > virtualized guest or native?
> 
> Yeah I should have been explicit about this.  My tests and measurements
> (and all test results I've received from others, I believe) have been on
> native/host kernels, not guests.

Have there been any measurements on systems without the architected
timers?

> > I count 18 dts* files that have "arm,armv7-timer", including platforms with
> > Krait, Exynos, and Tegra processors.
> 
> Yup.

That's not the full story.  Almost every ARM to date has not had an
architected timer.  Architected timers are a recent addition - as
pointed out, a Cortex A7/A12/A15 invention.  Most of the platforms I
see are Cortex A9 which doesn't have any architected timers.

Yes, it may be fun to work on new hardware and make that perform
much better than previous, but we should not loose sight that there
is older hardware out there, and we shouldn't unnecessarily penalise
it when adding new features.

What we /need/ to know is what the effect providing a VDSO in an
environment without an architected timer (so using the VDSO fallback
functions calling the syscalls) and having glibc use it is compared
to the current situation where there is no VDSO for glibc to use.

If you can show that there's no difference, then I'm happy to go with
always providing the VDSO.  If there's a detrimental effect (which I
suspect there may be, since we now have to have glibc test to see if
the VDSO is there, jump to the VDSO, the VDSO then tests whether we
have an architected timer, and then we finally get to issue the
syscall), then we must avoid providing the VDSO on systems which have
no architected timer.

Things like the time keeping syscalls tend to be hot paths, and having
extra unnecessary cycles in them can hurt userspace performance.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
