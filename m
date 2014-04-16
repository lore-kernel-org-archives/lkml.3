Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaDPS3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:29:07 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:51547 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbaDPSZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:25:34 -0400
From: Doug Anderson <dianders@chromium.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Olof Johansson <olof@lixom.net>, Sachin Kamat <sachin.kamat@linaro.org>,
        ajaykumar.rs@samsung.com, linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, devicetree@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, Mark Brown <broonie@kernel.org>,
        Simon Glass <sjg@chromium.org>, linux-doc@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, Pawel Moll <pawel.moll@arm.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Sean Paul <seanpaul@chromium.org>, Michael Spang <spang@chromium.org>
Subject: [PATCH v2 0/5] Fixes for tps65090 for Samsung ARM Chromebook
Date: Wed, 16 Apr 2014 11:25:19 -0700
Message-Id: <1397672724-9063-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1397592876-5741-1-git-send-email-dianders@chromium.org>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These five patches bring tps65090 up to speed with what's currently
in the Chromium OS kernel 3.8 tree and running on the Samsung ARM
Chromebook.  Changes were tested atop the current linux tree
(v3.15-rc1).  FET retries were tested on a machine with a known flaky
tps65090.  Since display isn't working on pure upstream, I augmented
the code to turn FET1 (vcd_led) on/off 500 times at bootup.  When
testing I included <https://patchwork.kernel.org/patch/3980731/> to
make sure tps65090 was in exynos5250-snow's device tree.

Dependencies:
- Patch #1 (mfd no irq) has no dependencies, though patch #2 won't
  work without it.
- Patch #2 (charger polling) can be applied without patch #1 but won't
  actually make charger polling work without it.
- Patch #3 (caching) can be applied before retries patch but not
  after.
- Patch #4 (overcurrent wait time) can be applied before retries patch
  but not after (just due to merge conflicts, no other reason).
- Patch #5 (retries) absolutely requires patch #3 (caching).

Changes in v2:
- Split noirq (polling mode) changes into MFD and charger
- Leave cache on for the registers that can be cached.
- Move register offsets to mfd header file.
- Separated the overcurrent and retries changes into two patches.
- Now set overcurrent at probe time since it doesn't change.
- Separated the overcurrent and retries changes into two patches.
- No longer open code fet_is_enabled().
- Fixed tps6090 typo.
- For loop => "while true".
- Removed a set of braces.

Doug Anderson (5):
  mfd: tps65090: Don't tell child devices we have an IRQ if we don't
  charger: tps65090: Allow charger module to be used when no irq
  mfd: tps65090: Stop caching most registers
  regulator: tps65090: Allow setting the overcurrent wait time
  regulator: tps65090: Make FETs more reliable by adding retries

 .../devicetree/bindings/regulator/tps65090.txt     |   4 +
 drivers/mfd/tps65090.c                             |  41 ++--
 drivers/power/tps65090-charger.c                   |  87 ++++++---
 drivers/regulator/tps65090-regulator.c             | 208 +++++++++++++++++++--
 include/linux/mfd/tps65090.h                       |  19 ++
 5 files changed, 300 insertions(+), 59 deletions(-)

-- 
1.9.1.423.g4596e3a

