Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaEOJe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:34:59 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61990 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaEOJe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:34:56 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 00/14] Add Qualcomm SD Card Controller support
Date: Thu, 15 May 2014 10:34:07 +0100
Message-Id: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Thankyou everyone for reviewing both RFC and v1 patches.

This patch series adds Qualcomm SD Card Controller support in pl180 mmci
driver. QCom SDCC is basically a pl180, but bit more customized, some of the
register layouts and offsets are different to the ones mentioned in pl180
datasheet. The plan is to totally remove the standalone SDCC driver
drivers/mmc/host/msm_sdcc.* and start using generic mmci driver for all
Qualcomm parts, as we get chance to test on other Qcom boards.

To start using the existing mmci driver, a fake amba id for Qualcomm is added
in patches:
 mmc: mmci: Add Qualcomm Id to amba id table.

Second change is, adding a 3 clock cycle delay for register writes on QCOM SDCC
registers, which is done in patches:
  mmc: mmci: Add register read/write wrappers.
  mmc: mmci: Qcomm: Add 3 clock cycle delay after register write

Third change is to accommodate CLK, DATCTRL and MMCICLK register layout changes
in Qcom SDCC and provide more flexibity in driver to specify these changes via
variant datastructure. Which are done in patches:
  mmc: mmci: Add Qcom datactrl register variant
  mmc: mmci: add ddrmode mask to variant data
  mmc: mmci: add 8bit bus support in variant data
  mmc: mmci: add edge support to data and command out in variant data.
  mmc: mmci: add Qcom specifics of clk and datactrl registers.
  mmc: mmci: Add support to data commands via variant structure.
  mmc: mmci: add support for fbclk to latch data and cmd.
  mmc: mmci: add qcom specific clk control

Fourth major change was to add qcom specfic pio read function, the need for
this is because the way MCIFIFOCNT register behaved in QCOM SDCC is very
 different to the one in pl180. This change is done in patch:
  mmc: mmci: Add Qcom specific pio_read function.

Last some Qcom unrelated changes/cleanup to driver are done in patches:
  mmc: mmci: use NSEC_PER_SEC macro
  mmc: mmci: convert register bits to use BIT() macro.

This patches are tested in PIO mode on IFC8064 board with both eMMC and
external SD card. I would like to get this support in v3.16.

Changes from v1:
	- moved most of the SOC specifics to variant parameters as suggested
	  by Linus W.
	- renamed registers as suggested by Linus W.
	- Added comments in the code as suggested by Linus W.
	- moved out AMBA ID addition patch from this series.
	- rebased the patches to 
		git://git.linaro.org/people/ulf.hansson/mmc.git next 
	  as suggested by Ulf H.

Changes from RFC:
	- moved out clk setup out of spinlock as pointed by Stephen B.
	
Thanks,
srini

Srinivas Kandagatla (14):
  mmc: mmci: use NSEC_PER_SEC macro
  mmc: mmci: convert register bits to use BIT() macro.
  mmc: mmci: Add Qualcomm Id to amba id table
  mmc: mmci: Add Qcom datactrl register variant
  mmc: mmci: Add register read/write wrappers.
  mmc: mmci: Qcomm: Add 3 clock cycle delay after register write
  mmc: mmci: add ddrmode mask to variant data
  mmc: mmci: add 8bit bus support in variant data
  mmc: mmci: add edge support to data and command out in variant data.
  mmc: mmci: add Qcom specifics of clk and datactrl registers.
  mmc: mmci: Add support to data commands via variant structure.
  mmc: mmci: add support for fbclk to latch data and cmd.
  mmc: mmci: add qcom specific clk control
  mmc: mmci: Add Qcom specific pio_read function.

 drivers/mmc/host/mmci.c | 245 ++++++++++++++++++++++++++++++++++++------------
 drivers/mmc/host/mmci.h | 232 +++++++++++++++++++++++++--------------------
 2 files changed, 311 insertions(+), 166 deletions(-)

-- 
1.9.1

