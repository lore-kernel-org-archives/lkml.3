Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3KOAwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 19:52:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:61385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab3KOAwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 19:52:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="435538644"
Date: Thu, 14 Nov 2013 19:52:30 -0500
From: robert.valiquette@intel.com
To: wsa@the-dreams.de, nhorman@tuxdriver.com, seth.heasley@intel.com
Cc: robert.valiquette@intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH 1/1] i2c-ismt: add the support of the
 I2C_SMBUS_I2C_BLOCK_DATA transaction type
Message-ID: <5285704e.jwiZWyk8R3ZEoySS%robert.valiquette@intel.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support of the I2C_SMBUS_I2C_BLOCK_DATA transaction type for the iSMT SMBus Controller.

Signed-off-by: Robert Valiquette <robert.valiquette@intel.com>
---
--- a/drivers/i2c/busses/i2c-ismt.c	2013-11-14 11:36:15.830322000 -0500
+++ b/drivers/i2c/busses/i2c-ismt.c	2013-11-14 16:01:56.532356000 -0500
@@ -344,6 +344,7 @@
 			data->word = dma_buffer[0] | (dma_buffer[1] << 8);
 			break;
 		case I2C_SMBUS_BLOCK_DATA:
+		case I2C_SMBUS_I2C_BLOCK_DATA:
 			memcpy(&data->block[1], dma_buffer, desc->rxbytes);
 			data->block[0] = desc->rxbytes;
 			break;
@@ -509,6 +510,41 @@
 		}
 		break;
 
+	case I2C_SMBUS_I2C_BLOCK_DATA:
+		/* Make sure the lenght is valid */
+		if (data->block[0] < 1)
+			data->block[0] = 1;
+
+		if (data->block[0] > I2C_SMBUS_BLOCK_MAX)
+			data->block[0] = I2C_SMBUS_BLOCK_MAX;
+
+		if (read_write == I2C_SMBUS_WRITE) {
+			/* i2c Block Write */
+			dev_dbg(dev, "I2C_SMBUS_I2C_BLOCK_DATA:  WRITE\n");
+			dma_size = data->block[0] + 1;
+			dma_direction = DMA_TO_DEVICE;
+			desc->wr_len_cmd = dma_size;
+			desc->control |= ISMT_DESC_I2C;
+			priv->dma_buffer[0] = command;
+			memcpy(&priv->dma_buffer[1], &data->block[1], dma_size);
+		} else {
+			/* i2c Block Read */
+			dev_dbg(dev, "I2C_SMBUS_I2C_BLOCK_DATA:  READ\n");
+			dma_size = data->block[0];
+			dma_direction = DMA_FROM_DEVICE;
+			desc->rd_len = dma_size;
+			desc->wr_len_cmd = command;
+			desc->control |= (ISMT_DESC_I2C | ISMT_DESC_CWRL);
+			/*
+			 * Per the "Table 15-15. I2C Commands",
+			 * in the External Design Specification (EDS),
+			 * (Document Number: 508084, Revision: 2.0),
+			 * the _rw bit must be 0
+			 */
+			desc->tgtaddr_rw = ISMT_DESC_ADDR_RW(addr, 0);
+		}
+		break;
+
 	default:
 		dev_err(dev, "Unsupported transaction %d\n",
 			size);
@@ -582,6 +618,7 @@
 	       I2C_FUNC_SMBUS_WORD_DATA		|
 	       I2C_FUNC_SMBUS_PROC_CALL		|
 	       I2C_FUNC_SMBUS_BLOCK_DATA	|
+	       I2C_FUNC_SMBUS_I2C_BLOCK		|
 	       I2C_FUNC_SMBUS_PEC;
 }
 
