Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaDDRF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:05:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:39797 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbaDDRFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:05:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,796,1389772800"; 
   d="scan'208";a="514974998"
From: "Du, Wenkai" <wenkai.du@intel.com>
To: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
CC: Wolfram Sang <wsa@the-dreams.de>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] i2c-designware: Mask interrupts during i2c controller enable
Thread-Topic: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Index: Ac9QJwrpXJhe4Vv7Q76dkBKVgbE+4A==
Date: Fri, 4 Apr 2014 17:05:23 +0000
Message-ID: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There were "i2c_designware 80860F41:00: controller timed out" errors
on a number of Baytrail platforms. They typically occurred during suspend
resume where some short i2c transfers were exchanged with devices. And they
mostly occurred when using fast mode, not standard mode.

The cause of the problem is that interrupts start right away when the
controller is enabled. There's this comment in __i2c_dw_enable:

/*
 * Wait 10 times the signaling period of the highest I2C
 * transfer supported by the driver (for 400KHz this is
 * 25us) as described in the DesignWare I2C databook.
 */

The __i2c_dw_enable then does a usleep for 25us to 250us, but since interrupts
were previously enabled, this wait wasn't being respected by ISR. With
additional traces, we could see ISR was activated and finished i2c transfer
while the code was still inside __i2c_dw_enable. At combination of fast
mode, certain transfer size and device response time, i2c_dw_clear_int was executed 
and cleared STOP condition flag, which resulted in i2c time out.

static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
{
...
	/* Enable the adapter */
	__i2c_dw_enable(dev, true);

	/* Clear and enable interrupts */
	i2c_dw_clear_int(dev);
	dw_writel(dev, DW_IC_INTR_DEFAULT_MASK, DW_IC_INTR_MASK);
}

The patch disables interrupts before the controller is enabled to remove this
race condition.

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

