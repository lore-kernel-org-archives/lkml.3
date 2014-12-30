Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaL3W1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:27:54 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:53039 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaL3W1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:27:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Agner <stefan@agner.ch>
Cc: Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        kernel@pengutronix.de,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/12] ARM: allow MULTIPLATFORM with !MMU
Date: Tue, 30 Dec 2014 23:27:20 +0100
Message-ID: <1622755.AGsAr84gTH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <8ec6bcf0fe2ec13898cf6c259d9da559@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch> <CAL_JsqK94Pk2xPF1MMX0GU0CQEiwiDD2qv9v3k4WLg2znDVjgA@mail.gmail.com> <8ec6bcf0fe2ec13898cf6c259d9da559@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:lhhGMzJZd7pLc8qSO/ULSIwDpsYBUlbWICvkX9B0w8DgOXMUPzY
 RIXWuqwa4+4zUZQi+Ij6ra/F1Wx9PyK7MhHbyo8g1pxB2feFl5bwLYK8xPehAVH9Uc0161a
 FWebU1WE/CTm6LiN7/lVLCpimk4KUuzuuag5fxA73HM+SWa0NOcM/yuFfwLkazSbx0J8VQo
 P6dtDJvj1HaUAq8Z0AFJw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 December 2014 23:02:31 Stefan Agner wrote:
> On 2014-12-30 22:42, Rob Herring wrote:
> > On Mon, Dec 29, 2014 at 5:32 PM, Stefan Agner <stefan@agner.ch> wrote:
> >> @@ -783,13 +780,13 @@ comment "CPU Core family selection"
> >>
> >>  config ARCH_MULTI_V4
> >>         bool "ARMv4 based platforms (FA526)"
> >> -       depends on !ARCH_MULTI_V6_V7
> >> +       depends on !ARCH_MULTI_V6_V7 && MMU
> > 
> > This is not right. !MMU does not mean the ARM arch does not have an
> > MMU, but rather the MMU is already setup with identity mapping (or
> > some other static mapping).
> 
> Yes, I'm aware of that. However, there are several configuration
> depending on "!MMU". Allowing !MMU on ARCH_MULTI_V4...V7 would open up
> new combination of configurations... This patch avoids this as much as
> possible, by making !MMU only available for ARCH_MULTI_V7M.
> 
> I'm not sure what tests/verification would be expected before allowing
> those new configurations... Personally, I also don't see much value in
> allowing these configurations.

There is a much bigger question to be answered here. Traditionally we
have allowed non-MMU configurations for all platforms, but with the
introduction of multiplatform support, that was implicitly dropped
for each platform that got converted. This was not really intended, but
we also never got complaints from users that were missing functionality
as a result of this.

In 3.19, we have also removed support for the last ARMv4 platform that
did not have an MMU (Atmel at91x40), so now we have four classes of
nommu systems remaining:

a) ARMv7-M: Cortex-M3 and M4 based platforms. We definitely need to
   support these, as that is the entire point of your series and other
   users want it too.

b) ARMv7-R and ARMv7-A with MMU disabled: This is almost supported by
   the kernel, except we don't have any platform using it. ARMv7-R
   support is probably useful if anybody invests the time to make it
   work, and being able to test those kernels on ARMv7-A hardware also
   seems worthwhile.

c) Out of mainline ARMv4t/ARMv5 platforms (based on arm7tdmi, arm9tdmi,
   arm9e, arm740t, arm940t, arm946e, or some unsupported Faraday or
   Marvell core), in theory also ARM Integrator with the respective
   core tiles. It may just be time now to remove this support from the
   kernel, as practically everyone with those cores is already stuck
   on ancient kernels, maybe with the exception of Russell's OKI platform
   port.
   I've asked around at conferences among people that are still interested
   in NOMMU hardware in general, and apparently running modern kernels
   on this class of hardware isn't interesting to anyone I found.

c) Any other hardware with MMU disabled. I personally don't see a reason
   to keep it, but maybe I'm just not creative enough. I have an old
   patch series to get this to compile for random configurations that
   are currently broken. If we keep this enabled, we should at least
   get allmodconfig with MMU disabled to build.

	Arnd
