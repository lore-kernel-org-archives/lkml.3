Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbaDJXFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 19:05:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:36008 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbaDJXFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 19:05:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,837,1389772800"; 
   d="scan'208";a="518812590"
From: "Du, Wenkai" <wenkai.du@intel.com>
To: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>
CC: "'Wolfram Sang'" <wsa@the-dreams.de>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] i2c-designware: Mask all interrupts during i2c
 controller enable
Thread-Topic: [PATCH V2] i2c-designware: Mask all interrupts during i2c
 controller enable
Thread-Index: Ac9VEQ5WBst0gdITQoyFI2SqbU1chw==
Date: Thu, 10 Apr 2014 23:03:19 +0000
Message-ID: <7286EAF50D3F4E4AADE7FEECEBF8B5A547FF93E0@ORSMSX110.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Updated problem descriptions from Mika's feedback and new test data: 

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

2. Failure in S3 to S0 suspend path

This failure also happens rarely and is hard to reproduce. Adding debug trace
that read DW_IC_INTR_MASK made this failure not reproducible. But from ISR 
call trace we could conclude TX_EMPTY was unmasked when problem occurred.


The patch masks all interrupts before the controller is enabled to resolve the
faulty DW_IC_INTR_MASK conditions.

Signed-off-by: Wenkai Du <wenkai.du@intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 14c4b30..71a3fa9 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -417,6 +417,9 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
 	 */
 	dw_writel(dev, msgs[dev->msg_write_idx].addr | ic_tar, DW_IC_TAR);
 
+	/* disable interrupts */
+	i2c_dw_disable_int(dev);
+
 	/* Enable the adapter */
 	__i2c_dw_enable(dev, true);
 
-- 
1.7.9.5

