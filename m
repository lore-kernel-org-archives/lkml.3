Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936431AbaFIJlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:41:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755913AbaFIJ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Du, Wenkai" <wenkai.du@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 131/146] i2c: designware: Mask all interrupts during i2c controller enable
Date: Mon,  9 Jun 2014 10:51:06 +0200
Message-Id: <7f002e22dca5df9ea1c9a5f530613575bedca2db.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, Wenkai" <wenkai.du@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/i2c/busses/i2c-designware-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 5888feef1ac5..a4dd9bdf737b 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -418,6 +418,9 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
 	 */
 	dw_writel(dev, msgs[dev->msg_write_idx].addr | ic_tar, DW_IC_TAR);
 
+	/* enforce disabled interrupts (due to HW issues) */
+	i2c_dw_disable_int(dev);
+
 	/* Enable the adapter */
 	__i2c_dw_enable(dev, true);
 
-- 
1.9.3

