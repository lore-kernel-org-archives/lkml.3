Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbbATPcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:32:54 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:37302 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbbATPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:32:51 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, mturquette@linaro.org, sboyd@codeaurora.org,
        chris@printf.net, ulf.hansson@linaro.org
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, peppe.cavallaro@st.com,
        olivier.bideau@st.com, gabriel.fernandez@st.com,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 0/4] Add sd/emmc support for stih407 family silicon
Date: Tue, 20 Jan 2015 15:32:40 +0000
Message-Id: <1421767964-8798-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds sd/emmc support to the sdhci-st.c driver for stih407
family silicon. The changes mainly involve congiguring some extra glue
registers which configure the controller.

This series also adds support for UHS modes for eMMC. To allow
UHS HS200/SD104 modes to function correctly, due to the
tight timing constriants and data tuning requirement, support
for PVT independent delay management is also added. Two types
of delay management are supported, static delay management and
dynamic delay management (dynamic delay loop), this delay
management is only available on eMMC pads on stih410 and later
silicon.

This has been tested with stih410-b2120 on eMMC and sd, at various
clock speeds. As part of this testing a bug was also found in the
upstream flexgen clock set_rate implementation.

    max-frequency = 200Mhz
    /dev/mmcblk0p1:
     Timing buffered disk reads: 270 MB in  3.02 seconds =  89.54 MB/sec
    
    max-frequency = 100Mhz
    root@debian-armhf:~# hdparm -t /dev/mmcblk0p1
    /dev/mmcblk0p1:
     Timing buffered disk reads: 210 MB in  3.00 seconds =  70.00 MB/sec
    
    max-frequency = 50Mhz
    root@debian-armhf:~# hdparm -t /dev/mmcblk0p1
    /dev/mmcblk0p1:
     Timing buffered disk reads: 118 MB in  3.00 seconds =  39.28 MB/sec

It has also been tested on stih416-b2020 to ensure we have caused no
regressions. Finally the dt documentation has been updated to reflect
the changes in the driver code. Intrestingly it seems we are the first
upstream platform to be using some of the uhs bindings such as
sd-uhs-sdr104.

regards,

Peter.

Peter Griffin (4):
  clk: st: STiH410: Fix pdiv and fdiv divisor when setting rate
  sdhci-st: Add support for stih407 family silicon.
  mmc: sdhci-st: Update ST SDHCI binding documentation.
  ARM: STi: DT: STiH407: Add dt nodes for sdhci and emmc.

 Documentation/devicetree/bindings/mmc/sdhci-st.txt | 100 +++++-
 arch/arm/boot/dts/stih407-family.dtsi              |  30 ++
 arch/arm/boot/dts/stih410-b2120.dts                |  10 +
 arch/arm/boot/dts/stihxxx-b2120.dtsi               |   8 +
 drivers/clk/st/clk-flexgen.c                       |  19 +-
 drivers/mmc/host/sdhci-st.c                        | 351 ++++++++++++++++++++-
 6 files changed, 496 insertions(+), 22 deletions(-)

-- 
1.9.1

