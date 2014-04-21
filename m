Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaDUVpC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:45:02 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37990 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaDUVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:44:58 -0400
From: srinivas.kandagatla@linaro.org
To: linux-mmc@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        agross@quicinc.com, linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 00/12] Add Qualcomm SD Card Controller support.
Date: Mon, 21 Apr 2014 22:43:44 +0100
Message-Id: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch series adds Qualcomm SD Card Controller support in pl180 mmci
driver. QCom SDCC is basically a pl180, but bit more customized, some of the
register layouts and offsets are different to the ones mentioned in pl180
datasheet. The plan is to totally remove the standalone SDCC driver
drivers/mmc/host/msm_sdcc.* and start using generic mmci driver for all
Qualcomm parts, as we get chance to test on other Qcom boards.

To start using the existing mmci driver, a fake amba id for Qualcomm is added
in patches:
 ARM: amba: Add Qualcomm vendor ID.
 mmc: mmci: Add Qualcomm Id to amba id table.

Second change is, adding a 3 clock cycle delay for register writes on QCOM SDCC
registers, which is done in patches:
  mmc: mmci: Add register read/write wrappers.
  mmc: mmci: Add write delay to variant structure.
  mmc: mmci: Qcomm: Add 3 clock cycle delay after each register write

Third change was to accommodate DATCTRL and MMCICLK register layout changes in
Qcom SDCC. Which is done in patches:
  mmc: mmci: Add Qcom datactrl register variant
  mmc: mmci: Add Qcom variations to MCICommand register.
  mmc: mmci: Qcom fix MCICLK register settings.
  mmc: mmci: Add clock support for Qualcomm.

Fourth major change was to add qcom specfic pio read function, the need for
this is because the way MCIFIFOCNT register behaved in QCOM SDCC is very
 different to the one in pl180. This change is done in patch:
  mmc: mmci: Add Qcom specific pio_read function.

Last some Qcom unrelated changes to support Qcom are done in patches:
  mmc: mmci: use NSEC_PER_SEC macro
  mmc: mmci: move ST specific register extensions access under condition.

This patches are tested in PIO mode on IFC8064 board with both eMMC and
external SD card. I would appreciate any feedback/suggestions on the overall
approach.

Thanks,
srini

Srinivas Kandagatla (12):
  ARM: amba: Add Qualcomm vendor ID.
  mmc: mmci: Add Qualcomm Id to amba id table
  mmc: mmci: Add Qcom datactrl register variant
  mmc: mmci: Add register read/write wrappers.
  mmc: mmci: use NSEC_PER_SEC macro
  mmc: mmci: Add write delay to variant structure.
  mmc: mmci: Qcomm: Add 3 clock cycle delay after each register write
  mmc: mmci: move ST specific register extensions access under condition.
  mmc: mmci: Qcom fix MCICLK register settings.
  mmc: mmci: Add clock support for Qualcomm.
  mmc: mmci: Add Qcom variations to MCICommand register.
  mmc: mmci: Add Qcom specific pio_read function.

 drivers/mmc/host/mmci.c  |  239 +++++++++++++++++++++++++++++++++-------------
 drivers/mmc/host/mmci.h  |   28 ++++++
 include/linux/amba/bus.h |    1 +
 3 files changed, 202 insertions(+), 66 deletions(-)

-- 
1.7.9.5

