Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaJPMXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:23:37 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35683 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752583AbaJPMXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:23:36 -0400
Date: Thu, 16 Oct 2014 13:23:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Daniel Drake <drake@endlessm.com>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3.17-rc4 v7 0/6] arm: Implement
 arch_trigger_all_cpu_backtrace
Message-ID: <20141016122322.GO27405@n2100.arm.linux.org.uk>
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org>
 <CAD8Lp44gPOBh_q1zDy3y1GkrRVAvix5YaNr-+E92+g8Q7fLKJA@mail.gmail.com>
 <543F8EA8.6080905@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543F8EA8.6080905@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:23:52AM +0100, Daniel Thompson wrote:
> On 14/10/14 23:37, Daniel Drake wrote:
> > I'm testing your patches on Exynos4412 and I guess in their current
> > state they don't go quite this deep, as the only callers of
> > trigger_all_cpu_backtrace() are sysrq, hung_task and spinlock debug
> > code - none of which seem as fail-safe as a trigger like a
> > pre-programmed watchdog NMI interrupt would be.
> > 
> > Do I need to find a way to get CONFIG_FIQ available on this platform
> > first? and/or CONFIG_HARDLOCKUP_DETECTOR?
> 
> You need CONFIG_FIQ working first. Be aware that this may be impossible
> on Exynos unless you control the TrustZone. For this reason most of my
> development is on Freescale i.MX6 (because i.MX6 boots in secure mode).

CONFIG_FIQ enables the legacy FIQ code which is unsuitable for use on
SMP, so that should not be a requirement.

We still need to validate all the code we're proposing to run in FIQ
context does not violate any locking.  IRQ-safe locks will do not
prevent FIQs occuring, and using IRQ-safe locks which are also taken
in the FIQ path /will/ cause deadlocks.  So, we need to ensure that
the perf internals are safe for this.

Lastly, platforms running in non-secure mode most likely will not be
able to take /any/ advantage from the FIQ stuff because FIQs will 
likely only be available to the secure firmware.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
