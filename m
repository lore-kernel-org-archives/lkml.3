Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaKKIgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:36:45 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53299 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbaKKIgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:36:39 -0500
From: Vignesh R <vigneshr@ti.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        <richardcochran@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Vignesh R <vigneshr@ti.com>, Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: [PATCH v3 0/6] Touchscreen performance related fixes
Date: Tue, 11 Nov 2014 14:03:58 +0530
Message-ID: <1415694844-11230-1-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fix TSC defects related to lag in touchscreen
performance and cursor jump at touch release. The lag was result of
udelay in TSC interrupt handler. Cursor jump due to false pen-up event.
The patches implement Advisory 1.0.31 in silicon errata of am335x-evm
to avoid false pen-up events and remove udelay. The advisory says to use
steps 1 to 4 for ADC and 5 to 16 for TSC (assuming 4 wire TSC and 4 channel
ADC). Further the X co-ordinate must be the last one to be sampled just
before charge step. The first two patches implement the required changes.

A DT parameter to configure the duration of tsc charge step. It represents
number of ADC clock cycles to wait between applying the step configuration
registers and going back to the IDLE state. The charge delay value can vary
across boards. Configuring correct value of charge delay is important to avoid
false pen-up events. Hence it is necessary to expose charge-delay value as
DT parameter. The pen-up detection happens immediately after the charge step
so this does in fact function as a hardware knob for adjusting the amount of
settling time.

After applying these changes false pen-up events have not be observed and
smooth circles can be drawn on touch screen. The performance is much better
in recognizing quick movement across the screen. No lag or cursor jump is
observed.

Change log:

v3:
 - Replace delta filtering logic in TSC driver with median filtering
   as suggested by Richard.
 - Addressed Lee Jones comments.

v2:
 - Addressed comments by Hartmut Knaack
 - patch 2 was split into two as per Lee Jones comment

Brad Griffis (2):
  input: touchscreen: ti_am335x_tsc Interchange touchscreen and ADC
    steps
  input: touchscreen: ti_am335x_tsc: Remove udelay in interrupt handler

Vignesh R (4):
  mfd: ti_am335x_tscadc: Remove unwanted reg_se_cache save
  ARM: dts: AM335x: Make charge delay a DT parameter for tsc
  input: touchscreen: ti_am335x_tsc: Use charge delay DT parameter
  input: touchscreen: ti_am335x_tsc: Replace delta filtering with median
    filtering

 .../bindings/input/touchscreen/ti-tsc-adc.txt      |  15 ++
 arch/arm/boot/dts/am335x-evm.dts                   |   1 +
 drivers/iio/adc/ti_am335x_adc.c                    |   5 +-
 drivers/input/touchscreen/ti_am335x_tsc.c          | 179 +++++++++++----------
 drivers/mfd/ti_am335x_tscadc.c                     |   7 +-
 include/linux/mfd/ti_am335x_tscadc.h               |   4 +-
 6 files changed, 121 insertions(+), 90 deletions(-)

-- 
1.9.1

