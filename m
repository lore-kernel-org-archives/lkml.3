Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3JDHdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 03:33:38 -0400
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:35648 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751257Ab3JDHdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 03:33:37 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Oct 2013 03:33:36 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guenter Roeck <groeck7@gmail.com>, Yang Wenyou <wenyou.yang@atmel.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH v5 0/4] watchdog: at91sam9_wdt: handle already configured wdt
Date: Fri,  4 Oct 2013 09:24:11 +0200
Message-Id: <1380871455-7324-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 7862722000626350304
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series is a porposal to enhance the sam9 watchdog timer support.

The at91sam9 watchdog timer can only be configured once, and the current
implementation tries to configure it in a static way:
- 2 seconds timeout
- wdt restart every 500ms

If the timer has already been configured with different values, it returns an
error and do not create any watchdog device.

This is not critical if the watchdog is disabled, but if it has been enabled
with different timeout values it will lead to a SoC reset.

This patch series tries to address this issue by adapting the heartbeat value
according the WDT timer config:
- it first tries to configure the timer as requested.
- if it fails it fallbacks to the current config, adapting its heartbeat timer
to the needs

This patch series also move to a dynamically allocated at91wdt device instead
of the static instance. I'm not sure this is the best solution, so please tell
me if you prefer to keep static instance of watchdog.

It adds a new at91 wdt type: software. This new type make use of the at91 wdt
interrupt to trigger a software reboot.

Finally it adds several properties to the device tree bindings.

Best Regards,
Boris

Changes since v4:
 - fix coding style issues
 - remove unneeded watchdog_active test

Changes since v3:
 - fix a bug in heartbeat time computation
 - fix a bug in at91_wdt_set_timeout when new timeout is bigger than the old
   one
 - rename at91_wdt_ping into at91_wdt_start
 - remove unneeded ping callback assignment

Changes since v2:
 - fix documentation
 - rework the heartbeat computation to get a more flexible behaviour
 - fix xx_to_yy macros
 - modify warning and error messages
 - remove unneeded parenthesis in arithmetic operations
 - use devm functions to map io memory
 - remove unneeded devm_kfree calls

Change since v1:
 - fix typo in documentaion
 - fix irq dt definition for sama5d3 SoC


Boris BREZILLON (4):
  watchdog: at91sam9_wdt: better watchdog support
  watchdog: at91sam9_wdt: update device tree doc
  ARM: at91/dt: add sam9 watchdog default options to SoCs
  ARM: at91/dt: add watchdog properties to kizbox board

 .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30 +-
 arch/arm/boot/dts/at91sam9260.dtsi                 |    5 +
 arch/arm/boot/dts/at91sam9263.dtsi                 |    5 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |    5 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 |    5 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |    5 +
 arch/arm/boot/dts/kizbox.dts                       |    6 +
 arch/arm/boot/dts/sama5d3.dtsi                     |    5 +
 drivers/watchdog/at91sam9_wdt.c                    |  309 ++++++++++++++------
 9 files changed, 287 insertions(+), 88 deletions(-)

-- 
1.7.9.5

