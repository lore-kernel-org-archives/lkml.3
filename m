Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaAUCWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 21:22:41 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44153 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaAUCW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 21:22:29 -0500
Date: Mon, 20 Jan 2014 18:22:27 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        James Ralston <james.d.ralston@intel.com>,
        Bill Brown <bill.e.brown@intel.com>,
        Matt Porter <matt.porter@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] i2c: New bus driver for the QUP I2C controller
Message-ID: <20140121022227.GD13785@codeaurora.org>
References: <1389999819-10648-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1389999819-10648-3-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389999819-10648-3-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Bjorn Andersson wrote:
> diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
> new file mode 100644
> index 0000000..2e0020e
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-qup.c
> @@ -0,0 +1,894 @@
> +/* Copyright (c) 2009-2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +
> +/* QUP Registers */
> +#define QUP_CONFIG		0x000
> +#define QUP_STATE		0x004
> +#define QUP_IO_MODE		0x008
> +#define QUP_SW_RESET		0x00c
> +#define QUP_OPERATIONAL		0x018
> +#define QUP_ERROR_FLAGS		0x01c
> +#define QUP_ERROR_FLAGS_EN	0x020
> +#define QUP_HW_VERSION		0x030
> +#define QUP_MX_OUTPUT_CNT	0x100
> +#define QUP_OUT_FIFO_BASE	0x110
> +#define QUP_MX_WRITE_CNT	0x150
> +#define QUP_MX_INPUT_CNT	0x200
> +#define QUP_MX_READ_CNT		0x208
> +#define QUP_IN_FIFO_BASE	0x218
> +#define QUP_I2C_CLK_CTL		0x400
> +#define QUP_I2C_STATUS		0x404
> +
> +/* QUP States and reset values */
> +#define QUP_RESET_STATE		0
> +#define QUP_RUN_STATE		1
> +#define QUP_PAUSE_STATE		3
> +#define QUP_STATE_MASK		3
> +
> +#define QUP_STATE_VALID		BIT(2)
> +#define QUP_I2C_MAST_GEN	BIT(4)
> +
> +#define QUP_OPERATIONAL_RESET	0x000ff0
> +#define QUP_I2C_STATUS_RESET	0xfffffc
> +
> +/* QUP OPERATIONAL FLAGS */
> +#define QUP_OUT_SVC_FLAG	BIT(8)
> +#define QUP_IN_SVC_FLAG		BIT(9)
> +#define QUP_MX_INPUT_DONE	BIT(11)
> +
> +/* I2C mini core related values */
> +#define I2C_MINI_CORE		(2 << 8)
> +#define I2C_N_VAL		15
> +/* Most significant word offset in FIFO port */
> +#define QUP_MSW_SHIFT		(I2C_N_VAL + 1)
> +#define QUP_CLOCK_AUTO_GATE	BIT(13)
> +
> +/* Packing/Unpacking words in FIFOs, and IO modes */
> +#define QUP_UNPACK_EN		BIT(14)
> +#define QUP_PACK_EN		BIT(15)
> +#define QUP_OUTPUT_BLK_MODE	BIT(10)
> +#define QUP_INPUT_BLK_MODE	BIT(12)
> +
> +#define QUP_REPACK_EN		(QUP_UNPACK_EN | QUP_PACK_EN)
> +
> +#define QUP_OUTPUT_BLOCK_SIZE(x)(((x) & (0x03 << 0)) >> 0)
> +#define QUP_OUTPUT_FIFO_SIZE(x)	(((x) & (0x07 << 2)) >> 2)
> +#define QUP_INPUT_BLOCK_SIZE(x)	(((x) & (0x03 << 5)) >> 5)
> +#define QUP_INPUT_FIFO_SIZE(x)	(((x) & (0x07 << 7)) >> 7)
> +
> +/* QUP tags */
> +#define QUP_OUT_NOP		(0 << 8)
> +#define QUP_OUT_START		(1 << 8)
> +#define QUP_OUT_DATA		(2 << 8)
> +#define QUP_OUT_STOP		(3 << 8)
> +#define QUP_OUT_REC		(4 << 8)
> +#define QUP_IN_DATA		(5 << 8)
> +#define QUP_IN_STOP		(6 << 8)
> +#define QUP_IN_NACK		(7 << 8)
> +
> +/* Status, Error flags */
> +#define I2C_STATUS_WR_BUFFER_FULL	BIT(0)
> +#define I2C_STATUS_BUS_ACTIVE		BIT(8)
> +#define I2C_STATUS_BUS_MASTER		BIT(9)
> +#define I2C_STATUS_ERROR_MASK		0x38000fc
> +#define QUP_I2C_NACK_FLAG		BIT(3)
> +#define QUP_IN_NOT_EMPTY		BIT(5)
> +#define QUP_STATUS_ERROR_FLAGS		0x7c
> +
> +/* Master bus_err clock states */
> +#define I2C_CLK_RESET_BUSIDLE_STATE	0
> +#define I2C_CLK_FORCED_LOW_STATE	5
> +
> +#define QUP_MAX_CLK_STATE_RETRIES	300
> +#define QUP_MAX_QUP_STATE_RETRIES	100
> +#define I2C_STATUS_CLK_STATE		13
> +#define QUP_OUT_FIFO_NOT_EMPTY		0x10
> +#define QUP_READ_LIMIT			256
> +
> +struct qup_i2c_dev {
> +	struct device		*dev;
> +	void __iomem		*base;
> +	int			irq;
> +	struct clk		*clk;
> +	struct clk		*pclk;
> +	struct i2c_adapter	adap;
> +
> +	int			clk_ctl;
> +	int			one_bit_t;
> +	int			out_fifo_sz;
> +	int			in_fifo_sz;
> +	int			out_blk_sz;
> +	int			in_blk_sz;
> +	unsigned long		xfer_time;
> +	unsigned long		wait_idle;
> +
> +	struct i2c_msg		*msg;
> +	/* Current posion in user message buffer */

s/posion/position/

> +	int			pos;
> +	/* Keep number of bytes left to be transmitted */
> +	int			cnt;
> +	/* I2C protocol errors */
> +	u32			bus_err;
> +	/* QUP core errors */
> +	u32			qup_err;
> +	/*
> +	 * Maximum bytes that could be send (per iteration). Could be
> +	 * equal of fifo size or block size (in block mode)
> +	 */
> +	int			chunk_sz;
> +	struct completion	xfer;
> +};
[...]
> +
> +static int
> +qup_i2c_poll_state(struct qup_i2c_dev *qup, u32 req_state, bool only_valid)
> +{
> +	int retries = 0;
> +	u32 state;
> +
> +	do {
> +		state = readl(qup->base + QUP_STATE);
> +
> +		/*
> +		 * If only valid bit needs to be checked, requested state is
> +		 * 'don't care'
> +		 */
> +		if (state & QUP_STATE_VALID) {
> +			if (only_valid)
> +				return 0;
> +			if ((req_state & QUP_I2C_MAST_GEN)
> +			    && (state & QUP_I2C_MAST_GEN))
> +				return 0;
> +			if ((state & QUP_STATE_MASK) == req_state)
> +				return 0;
> +		}
> +
> +		udelay(1);
> +	} while (retries++ != QUP_MAX_QUP_STATE_RETRIES);
> +
> +	return -ETIMEDOUT;
> +}
> +

This is what I was suggesting. Don't know if it's any clearer,
but it saves us a whopping 3 lines!

---8<----
 drivers/i2c/busses/i2c-qup.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index 2e0020e829ae..431de13f6281 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -47,7 +47,7 @@
 #define QUP_STATE_MASK		3
 
 #define QUP_STATE_VALID		BIT(2)
-#define QUP_I2C_MAST_GEN	BIT(4)
+#define QUP_I2C_MAST_GEN	(QUP_STATE_VALID | BIT(4))
 
 #define QUP_OPERATIONAL_RESET	0x000ff0
 #define QUP_I2C_STATUS_RESET	0xfffffc
@@ -190,43 +190,40 @@ done:
 	return IRQ_HANDLED;
 }
 
-static int
-qup_i2c_poll_state(struct qup_i2c_dev *qup, u32 req_state, bool only_valid)
+static int __qup_i2c_poll_state(struct qup_i2c_dev *qup, u32 mask, u32 value)
 {
 	int retries = 0;
 	u32 state;
 
 	do {
 		state = readl(qup->base + QUP_STATE);
-
-		/*
-		 * If only valid bit needs to be checked, requested state is
-		 * 'don't care'
-		 */
-		if (state & QUP_STATE_VALID) {
-			if (only_valid)
-				return 0;
-			if ((req_state & QUP_I2C_MAST_GEN)
-			    && (state & QUP_I2C_MAST_GEN))
-				return 0;
-			if ((state & QUP_STATE_MASK) == req_state)
-				return 0;
-		}
-
+		if ((state & mask) == value)
+			return 0;
 		udelay(1);
 	} while (retries++ != QUP_MAX_QUP_STATE_RETRIES);
 
 	return -ETIMEDOUT;
 }
 
+static int qup_i2c_poll_state_bit(struct qup_i2c_dev *qup, u32 mask)
+{
+	return __qup_i2c_poll_state(qup, mask, mask);
+}
+
+static int qup_i2c_poll_state(struct qup_i2c_dev *qup, u32 state)
+{
+	return __qup_i2c_poll_state(qup, QUP_STATE_VALID | QUP_STATE_MASK,
+					 QUP_STATE_VALID | state);
+}
+
 static int qup_i2c_change_state(struct qup_i2c_dev *qup, u32 state)
 {
-	if (qup_i2c_poll_state(qup, 0, true) != 0)
+	if (qup_i2c_poll_state_bit(qup, QUP_STATE_VALID) != 0)
 		return -EIO;
 
 	writel(state, qup->base + QUP_STATE);
 
-	if (qup_i2c_poll_state(qup, state, false) != 0)
+	if (qup_i2c_poll_state(qup, state) != 0)
 		return -EIO;
 	return 0;
 }
@@ -616,7 +613,7 @@ qup_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 		goto out;
 
 	writel(1, qup->base + QUP_SW_RESET);
-	ret = qup_i2c_poll_state(qup, QUP_RESET_STATE, false);
+	ret = qup_i2c_poll_state(qup, QUP_RESET_STATE);
 	if (ret) {
 		dev_err(qup->dev, "cannot goto reset state\n");
 		goto out;
@@ -633,7 +630,7 @@ qup_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 		writel(0, qup->base + QUP_I2C_CLK_CTL);
 		writel(QUP_I2C_STATUS_RESET, qup->base + QUP_I2C_STATUS);
 
-		if (qup_i2c_poll_state(qup, QUP_I2C_MAST_GEN, false) != 0) {
+		if (qup_i2c_poll_state_bit(qup, QUP_I2C_MAST_GEN) != 0) {
 			ret = -EIO;
 			goto out;
 		}
@@ -730,7 +727,7 @@ static int qup_i2c_probe(struct platform_device *pdev)
 	 * so we reset the core before registering for interrupts.
 	 */
 	writel(1, qup->base + QUP_SW_RESET);
-	ret = qup_i2c_poll_state(qup, 0, true);
+	ret = qup_i2c_poll_state(qup, QUP_STATE_VALID);
 	if (ret)
 		goto fail;
 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
