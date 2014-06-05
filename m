Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaFEFAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:00:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaFEEUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wenkai Du <wenkai.du@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.4 073/214] i2c: designware: Mask all interrupts during i2c controller enable
Date: Wed,  4 Jun 2014 21:17:16 -0700
Message-Id: <20140605041649.358346980@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-designware-core.c |    3 +++
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
 


