Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab3DLHqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 03:46:05 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:53070 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3DLHqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 03:46:03 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Arnd Bergmann <arnd@arndb.de>, linux-samsung-soc@vger.kernel.org,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 17/30] pwm: samsung: repair the worst MMIO abuses
Date: Fri, 12 Apr 2013 00:46:00 -0700 (PDT)
Message-ID: <1469653.nxt3obZ5EV@flatron>
User-Agent: KMail/4.10.2 (Linux/3.8.6-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130412070635.GA16956@avionic-0098.mockup.avionic-design.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-18-git-send-email-arnd@arndb.de> <20130412070635.GA16956@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 of April 2013 09:06:35 Thierry Reding wrote:
> On Thu, Apr 11, 2013 at 02:04:59AM +0200, Arnd Bergmann wrote:
> > The Samsung PWM driver uses "magic" pointers that are mapped
> > at boot time to point its MMIO registers. This fails horribly
> > with a multiplatform kernel, which can not rely on platform
> > specific header files to contain the right values, aside from
> > this being a really bad idea in general.
> > 
> > This changes the driver to at least pass an __iomem token
> > around in the device structure to dereference that. Fixing
> > the platform code is much harder, so we'll leave that
> > until we have a DT binding for pwm-samsung, which may require
> > other changes in this area. Since we are already touching
> > every MMIO accessor in this driver, let's also use the
> > proper readl_relaxed variant rather than __raw_readl.
> > 
> > Tomasz Figa has a set of patches to clean this up in a proper
> > way, but that might be too late for 3.10.
> 
> Joonyoung Shim (Cc'ed) posted a driver for Exynos back in December. I
> had a few comments on it but never saw an updated version. Is Tomasz'
> work based on that patch?

Is this the patch you are talking about?

https://lkml.org/lkml/2012/12/13/84

If yes, it solves the problems only for Exynos SoCs (excluding Exynos 4210 
rev0), which don't need to share the PWM hardware between two drivers.

On older platforms (S3C24xx, S3C64xx, S5P64x0, S5PC100, S5PV210 and Exynos 
4210 rev0) the same hardware block is used for two drivers - clocksource 
driver and PWM driver.

You can get more information from these two threads:

- http://thread.gmane.org/gmane.linux.kernel.samsung-soc/16480/focus=16510
(starting from the linked post)

- http://thread.gmane.org/gmane.linux.kernel.samsung-soc/17464
 

> Given that this patch solves a real problem and doesn't make things any
> worse, I think it's okay to use it temporarily until Tomasz has had time
> to finish up the proper driver, so:

Well, from what I've seen, the PWM might have been already broken on non-
DT platforms using channels higher than 0, because the driver registers 
each channel passing -1 as base, which makes the id being assigned 
dynamically (usually to 0, since it's the only PWM channel used), while in 
all platform data, the real (hardware) PWM channel id is used and no PWM 
lookup is registered.

You can use the following grep to find all platforms with broken PWM:
git grep pwm_id arch/arm/mach-s[35]* | grep -v "= 0"

I have a set of patches to fix everything up in the PWM driver, but they 
depend on my patches providing the infrastructure to share the PWM 
hardware, on next version of which I'm currently working.

So, for now, Arnd's patch is fine to me as well.

Best regards,
Tomasz

