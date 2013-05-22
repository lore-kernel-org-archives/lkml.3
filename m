Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab3EVWO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:14:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509Ab3EVWKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [ 06/21] i2c: designware: always clear interrupts before enabling them
Date: Wed, 22 May 2013 15:10:24 -0700
Message-Id: <20130522205233.408598986@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 2a2d95e9d6d29e726cc294b65391917ed2e32bf4 upstream.

If the I2C bus is put to a low power state by an ACPI method it might pull
the SDA line low (as its power is removed). Once the bus is put to full
power state again, the SDA line is pulled back to high. This transition
looks like a STOP condition from the controller point-of-view which sets
STOP detected bit in its status register causing the driver to fail
subsequent transfers.

Fix this by always clearing all interrupts before we start a transfer.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-designware-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -361,7 +361,8 @@ static void i2c_dw_xfer_init(struct dw_i
 	/* Enable the adapter */
 	dw_writel(dev, 1, DW_IC_ENABLE);
 
-	/* Enable interrupts */
+	/* Clear and enable interrupts */
+	i2c_dw_clear_int(dev);
 	dw_writel(dev, DW_IC_INTR_DEFAULT_MASK, DW_IC_INTR_MASK);
 }
 


