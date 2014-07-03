Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbaGCKJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:09:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51703 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248AbaGCJWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 053/198] mei: me: read H_CSR after asserting reset
Date: Thu,  3 Jul 2014 10:18:16 +0100
Message-Id: <1404379241-8590-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit c40765d919d25d2d44d99c4ce39e48808f137e1e upstream.

According the spec the host should read H_CSR again
after asserting reset H_RST to ensure that reset was
read by the firmware

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/mei/hw-me.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 6cba26d9465f..e2ca1574d22a 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -186,6 +186,18 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	dev->recvd_hw_ready = false;
 	mei_me_reg_write(hw, H_CSR, hcsr);
 
+	/*
+	 * Host reads the H_CSR once to ensure that the
+	 * posted write to H_CSR completes.
+	 */
+	hcsr = mei_hcsr_read(hw);
+
+	if ((hcsr & H_RST) == 0)
+		dev_warn(&dev->pdev->dev, "H_RST is not set = 0x%08X", hcsr);
+
+	if ((hcsr & H_RDY) == H_RDY)
+		dev_warn(&dev->pdev->dev, "H_RDY is not cleared 0x%08X", hcsr);
+
 	if (dev->dev_state == MEI_DEV_POWER_DOWN)
 		mei_me_hw_reset_release(dev);
 
-- 
1.9.1

