Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213Ab3DKSwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:52:20 -0400
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:54106 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754678Ab3DKSwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:52:18 -0400
Date: Thu, 11 Apr 2013 18:54:14 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: rtc-linux@googlegroups.com
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [rtc-linux] Re: [PATCH v2 0/5] ARM: at91: fix hanged boot
Message-ID: <20130411165414.GC25242@game.jcrosoft.org>
References: <20130311180611.GF8797@localhost>
 <1363025279-17615-1-git-send-email-jhovold@gmail.com>
 <20130411155505.GD21305@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411155505.GD21305@localhost>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16979415021339388849
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -51
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedruddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogfuuhhsphgvtghtffhomhgrihhnucdlgeelmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -51
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedruddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogfuuhhsphgvtghtffhomhgrihhnucdlgeelmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:55 Thu 11 Apr     , Johan Hovold wrote:
> On Mon, Mar 11, 2013 at 07:07:54PM +0100, Johan Hovold wrote:
> > These patches fix a few severe issues affecting most AT91 SOCs where
> > boot can hang after a non-general reset, and where the only way to get
> > the system booting again is to do a general reset -- something which
> > could require physically removing any backup battery.
> 
> Have you had time to look at these patches yet, Nicolas?
> 
> I don't think not having decided on the path forward for DT-support for
> rtc-at91sam9 needs to be a blocker. The rtt-nodes will be needed in any
> case.
> 
> I could respin the series on top of the DT-patch for rtc-at91rm9200, and
> add interrupt and status-disabled properties to the DT-nodes as well.
for this this is still a no go

this way too much ugly

Best Regards,
J.
> 
> Thanks,
> Johan
> 
> > The problems stem from the fact that the RTC and RTT-peripherals are
> > powered by backup power (VDDBU) and are not reset on wake-up, user,
> > watchdog or software reset. Consequently, RTC and RTT-alarms and their
> > interrupts may be enabled at boot, leading to a system lock-up when an
> > interrupt arrives on the shared system-interrupt line before the
> > appropriate handler (e.g. RTC-driver) has been installed.
> > 
> > The easiest way to trigger this is to simply wake up from an RTC-alarm
> > on at91sam9g45. The RTC-driver currently does not disable interrupts at
> > shutdown so even after a clean shut-down the system will always hang
> > after waking up.
> > 
> > The first patch fixes this very general case of RTC-wake up after a
> > clean shutdown in the RTC-driver and is marked for stable as it is
> > perfectly straight-forward. [ Note that the other, RTT-based, AT91
> > RTC-driver already disables its interrupts at shutdown. ]
> > 
> > The more general problem can be triggered, for example, by doing a
> > user-reset while updating the RTC-time or if an RTC or RTT-alarm goes
> > off after a non-clean shutdown.
> > 
> > To fix this I propose that arch-code should mask the relevant interrupts
> > before enabling the system interrupt at early boot, and this is what
> > the fifth patch does. To access the RTC-registers I choose to revert a
> > recent patch that moved the register definitions to drivers/rtc.
> > 
> > Arguably, the relevant interrupts could also be disabled in bootloaders,
> > but I suggest fixing it in the kernel once and for all.
> > 
> > The patches have been tested on at91sam9263 and at91sam9g45 (non-DT),
> > and compile-tested for the other SOCs and DT.
> > 
> > Johan
> > 
> > 
> > v2:
> >  - add DT-support
> >  - make sys_irq_mask non-mandatory
> > 
> > 
> > Johan Hovold (5):
> >   ARM: at91/rtc: fix boot after RTC wake-up
> >   ARM: at91/dts: add RTC nodes
> >   ARM: at91/dts: add RTT nodes
> >   Revert "arm: at91: move at91rm9200 rtc header in drivers/rtc"
> >   ARM: at91: fix hanged boot
> 
> -- 
> -- 
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.
> --- 
> You received this message because you are subscribed to the Google Groups "rtc-linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to rtc-linux+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
> 
> 
