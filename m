Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaELJVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:21:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:14702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbaELJU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:20:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1033,1389772800"; 
   d="scan'208";a="510161881"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 3/3] mei: me: read H_CSR after asserting reset
Date: Mon, 12 May 2014 12:19:41 +0300
Message-Id: <1399886381-16040-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399886381-16040-1-git-send-email-tomas.winkler@intel.com>
References: <1399886381-16040-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According the spec the host should read H_CSR again
after asserting reset H_RST to ensure that reset was
read by the firmware

Cc: stable@vger.kernel.org
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hw-me.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 031efcf..016ad88 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -206,6 +206,18 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
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
 	if (intr_enable == false)
 		mei_me_hw_reset_release(dev);
 
-- 
1.9.0

