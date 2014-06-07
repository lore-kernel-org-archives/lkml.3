Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaFGBrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:47:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35949 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wolfram Sang" <wsa@the-dreams.de>,
        "Du, Wenkai" <wenkai.du@intel.com>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.944801715@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 70/92] i2c: designware: Mask all interrupts during i2c
 controller enable
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Du, Wenkai" <wenkai.du@intel.com>

commit 47bb27e78867997040a228328f2a631c3c7f2c82 upstream.

There have been "i2c_designware 80860F41:00: controller timed out" errors
on a number of Baytrail platforms. The issue is caused by incorrect value in
Interrupt Mask Register (DW_IC_INTR_MASK)  when i2c core is being enabled.
This causes call to __i2c_dw_enable() to immediately start the transfer which
leads to timeout. There are 3 failure modes observed:

1. Failure in S0 to S3 resume path

The default value after reset for DW_IC_INTR_MASK is 0x8ff. When we start
the first transaction after resuming from system sleep, TX_EMPTY interrupt
is already unmasked because of the hardware default.

2. Failure in normal operational path

This failure happens rarely and is hard to reproduce. Debug trace showed that
DW_IC_INTR_MASK had value of 0x254 when failure occurred, which meant
TX_EMPTY was unmasked.

3. Failure in S3 to S0 suspend path

This failure also happens rarely and is hard to reproduce. Adding debug trace
that read DW_IC_INTR_MASK made this failure not reproducible. But from ISR
call trace we could conclude TX_EMPTY was unmasked when problem occurred.

The patch masks all interrupts before the controller is enabled to resolve the
faulty DW_IC_INTR_MASK conditions.

Signed-off-by: Wenkai Du <wenkai.du@intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
[wsa: improved the comment and removed typo in commit msg]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/i2c/busses/i2c-designware-core.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -346,6 +346,9 @@ static void i2c_dw_xfer_init(struct dw_i
 		ic_con &= ~DW_IC_CON_10BITADDR_MASTER;
 	dw_writel(dev, ic_con, DW_IC_CON);
 
+	/* enforce disabled interrupts (due to HW issues) */
+	i2c_dw_disable_int(dev);
+
 	/* Enable the adapter */
 	dw_writel(dev, 1, DW_IC_ENABLE);
 

