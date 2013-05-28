Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab3E1DzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52577 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758861Ab3E1DyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wolfram Sang" <wsa@the-dreams.de>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.548780720@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [47/94] i2c: designware: always clear interrupts before enabling them
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/i2c/busses/i2c-designware-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -349,7 +349,8 @@ static void i2c_dw_xfer_init(struct dw_i
 	/* Enable the adapter */
 	dw_writel(dev, 1, DW_IC_ENABLE);
 
-	/* Enable interrupts */
+	/* Clear and enable interrupts */
+	i2c_dw_clear_int(dev);
 	dw_writel(dev, DW_IC_INTR_DEFAULT_MASK, DW_IC_INTR_MASK);
 }
 

