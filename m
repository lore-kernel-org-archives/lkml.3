Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113AbaE3RMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:12:39 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43336 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934029AbaE3RMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:12:37 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v5 00/13] Add Qualcomm SD Card Controller support
Date: Fri, 30 May 2014 18:11:58 +0100
Message-Id: <1401469918-26817-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Thankyou Linus W, Ulf H and everyone for reviewing RFC to v4 patches.

This patch series adds Qualcomm SD Card Controller support in pl180 mmci
driver. QCom SDCC is basically a pl180, but bit more customized, some of the
register layouts and offsets are different to the ones mentioned in pl180
datasheet. The plan is to totally remove the standalone SDCC driver
drivers/mmc/host/msm_sdcc.* and start using generic mmci driver for all
Qualcomm parts, as we get chance to test on other Qcom boards.

To start using the existing mmci driver, a fake amba id for Qualcomm is added
in patches:
 mmc: mmci: Add Qualcomm specific register defines.
 mmc: mmci: Add Qualcomm Id to amba id table.

Second change is, adding a 3 clock cycle delay in between writes to
CLKCTRL/POWER/DATACTRL/COMMAND registers. Most of the delays are taken care with
the existing driver except delay for the COMMAND register was too small. 
This patch fixes it.
  mmc: mmci: Add enough delay between writes to CMD register.

Third change is to accommodate CLK, DATCTRL and MMCICLK register layout changes
in Qcom SDCC and provide more flexibity in driver to specify these changes via
variant datastructure. Which are done in patches:
  mmc: mmci: Add Qcom datactrl register variant
  mmc: mmci: add ddrmode mask to variant data
  mmc: mmci: add 8bit bus support in variant data
  mmc: mmci: add edge support to data and command out in variant data.
  mmc: mmci: add Qcom specifics of clk and datactrl registers.
  mmc: mmci: Add support to data commands via variant structure.
  mmc: mmci: add f_max to variant structure
  mmc: mmci: add explicit clk control

Fourth change was to add qcom specfic fifocnt logic, the need for
this is because the way MCIFIFOCNT register behaved in QCOM SDCC is very
 different to the one in pl180. This change is done in patch:
  mmc: mmci: Add Qcom specific rx_fifocnt logic.

Last some Qcom unrelated changes/cleanup to driver are done in patches:
  mmc: mmci: use NSEC_PER_SEC macro
  mmc: mmci: convert register bits to use BIT() macro.

This patches are tested in PIO mode on IFC8064 board with both eMMC and
external SD card. I would like to get this support in v3.16.

Changes from v4:
	- moved the amba id table addition to the end of the patchset as suggested by Ulf.
	- reused the mmci_pio_read function after experimenting with the fifo behaviour.
	- simplify f_max/f_min calculation logic as suggested by Ulf.
	- created a new patch for the register defination as suggested by Ulf.

Changes from v3:
	- moved pio_read to a function pointer so as to reduce additional cycles
	in hot-path, suggested by Ulf.
	- simplify the flags used for explicit mclk control, suggested by Ulf.
	- fixed issues in cacluating f_max and f_min pointed and suggested by Ulf.
	- removed unessary DDR flags on un-supported STE variants.
	- used BIT macros as suggested by Ulf.
	- removed the read/write wrappers with delays, and used most optimal way
	to introduce the delays to the only registers that require delays.

Changes from v2:
	- merged fbclk latch patch with clkreg_enable patch as suggested by Linus W.
	- remove qcom prefix for explicit clk control pointed by Linus W.
	- cleaned up mmci_qcom_pio_read and consider SDIO as suggested by Linus W.

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

Am hoping to get this for v3.16.

All these patches are tested on IF6410 board on both eMMC and external SD card.

Thanks,
srini

Srinivas Kandagatla (13):
  mmc: mmci: use NSEC_PER_SEC macro
  mmc: mmci: convert register bits to use BIT() macro.
  mmc: mmci: Add Qualcomm specific register defines.
  mmc: mmci: Add enough delay between writes to CMD register.
  mmc: mmci: Add Qcom datactrl register variant
  mmc: mmci: add ddrmode mask to variant data
  mmc: mmci: add 8bit bus support in variant data
  mmc: mmci: add edge support to data and command out in variant data.
  mmc: mmci: Add support to data commands via variant structure.
  mmc: mmci: add f_max to variant structure
  mmc: mmci: add explicit clk control
  mmc: mmci: Add Qcom specific rx_fifocnt logic.
  mmc: mmci: Add Qualcomm Id to amba id table

 drivers/mmc/host/mmci.c | 129 ++++++++++++++++++++++++---
 drivers/mmc/host/mmci.h | 228 ++++++++++++++++++++++++++----------------------
 2 files changed, 241 insertions(+), 116 deletions(-)

-- 
1.9.1

