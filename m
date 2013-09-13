Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3IMHpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:45:04 -0400
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:39463 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754784Ab3IMHpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:45:00 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [RFC PATCH 0/4] pinctrl: at91: various fixes
Date: Fri, 13 Sep 2013 09:43:33 +0200
Message-Id: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 14077689486294415584
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series fixes some errors in the pinctrl drivers:
- typos in dt-binding macros and pinctrl-at91 driver (patch 1)
- fix several at91-pinctrl functions (patch 2 and 3)
- rework the debounce config handling (patches 4)

The last point is the most important one: the at91sam9x5/pio3 controller
does not provide a per pin debounce time config. Instead it provides a
common debounce time for all the pins on a given bank (PIOX).

In this series I proposed 2 solutions to gracefully handle this limitation:
1) Handle debounce time conflicts at config time (PATCH 4/4).
   In other words, all the pins on a given bank using the debounce option must
   use the same debounce time. If a device tries to configure a pin with
   conflicting a debounce time, this will result in an -EINVAL error return
   during the pin configuration.
2) Provide a device tree property to define the default debounce time on a
   given bank (PATCH alt 4/4)


I prefer the first solution, as it provides a more future proof approach:
- the generic pinconf layer provides a per pin debounce time config and if
  we plan to support it we should take this into consideration
- IMHO we should be able to (re)configure the debounce time after bootup and
  the second solution does not provide any way to do this

I might be wrong, so please feel free to share your thoughts about this.

Best Regards,

Boris


Boris BREZILLON (4):
  pinctrl: at91: fix typos
  pinctrl: at91: reset caller's config variable before setting flags
  pinctrl: at91: fix get_debounce/deglitch functions for sam9x5
    controller
  pinctrl: at91: check for debounce time conflicts

 drivers/pinctrl/pinctrl-at91.c     |   60 +++++++++++++++++++++++++++---------
 include/dt-bindings/pinctrl/at91.h |    2 +-
 2 files changed, 46 insertions(+), 16 deletions(-)

-- 
1.7.9.5

