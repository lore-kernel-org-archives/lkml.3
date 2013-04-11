Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3DKP4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:56:08 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47953 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3DKP4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:56:07 -0400
Date: Thu, 11 Apr 2013 17:55:05 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH v2 0/5] ARM: at91: fix hanged boot
Message-ID: <20130411155505.GD21305@localhost>
References: <20130311180611.GF8797@localhost>
 <1363025279-17615-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363025279-17615-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 07:07:54PM +0100, Johan Hovold wrote:
> These patches fix a few severe issues affecting most AT91 SOCs where
> boot can hang after a non-general reset, and where the only way to get
> the system booting again is to do a general reset -- something which
> could require physically removing any backup battery.

Have you had time to look at these patches yet, Nicolas?

I don't think not having decided on the path forward for DT-support for
rtc-at91sam9 needs to be a blocker. The rtt-nodes will be needed in any
case.

I could respin the series on top of the DT-patch for rtc-at91rm9200, and
add interrupt and status-disabled properties to the DT-nodes as well.

Thanks,
Johan

> The problems stem from the fact that the RTC and RTT-peripherals are
> powered by backup power (VDDBU) and are not reset on wake-up, user,
> watchdog or software reset. Consequently, RTC and RTT-alarms and their
> interrupts may be enabled at boot, leading to a system lock-up when an
> interrupt arrives on the shared system-interrupt line before the
> appropriate handler (e.g. RTC-driver) has been installed.
> 
> The easiest way to trigger this is to simply wake up from an RTC-alarm
> on at91sam9g45. The RTC-driver currently does not disable interrupts at
> shutdown so even after a clean shut-down the system will always hang
> after waking up.
> 
> The first patch fixes this very general case of RTC-wake up after a
> clean shutdown in the RTC-driver and is marked for stable as it is
> perfectly straight-forward. [ Note that the other, RTT-based, AT91
> RTC-driver already disables its interrupts at shutdown. ]
> 
> The more general problem can be triggered, for example, by doing a
> user-reset while updating the RTC-time or if an RTC or RTT-alarm goes
> off after a non-clean shutdown.
> 
> To fix this I propose that arch-code should mask the relevant interrupts
> before enabling the system interrupt at early boot, and this is what
> the fifth patch does. To access the RTC-registers I choose to revert a
> recent patch that moved the register definitions to drivers/rtc.
> 
> Arguably, the relevant interrupts could also be disabled in bootloaders,
> but I suggest fixing it in the kernel once and for all.
> 
> The patches have been tested on at91sam9263 and at91sam9g45 (non-DT),
> and compile-tested for the other SOCs and DT.
> 
> Johan
> 
> 
> v2:
>  - add DT-support
>  - make sys_irq_mask non-mandatory
> 
> 
> Johan Hovold (5):
>   ARM: at91/rtc: fix boot after RTC wake-up
>   ARM: at91/dts: add RTC nodes
>   ARM: at91/dts: add RTT nodes
>   Revert "arm: at91: move at91rm9200 rtc header in drivers/rtc"
>   ARM: at91: fix hanged boot
