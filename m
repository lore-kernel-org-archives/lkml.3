Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab3G3Inu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:43:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:18193 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab3G3Ins (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,776,1367996400"; 
   d="scan'208";a="373329115"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Shuah Khan <huah.kh@samsung.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [char-misc 3.11] mei: me: fix hardware reset flow
Date: Tue, 30 Jul 2013 11:41:58 +0300
Message-Id: <1375173718-9982-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both H_IS and H_IE needs to be set to receive H_RDY 
interrupt

1. Assert H_IS to clear the interrupts during hw reset
and use mei_me_reg_write instead of mei_hcsr_set as the later
strips down the H_IS

2. fix interrupt disablement embarrassing typo
  hcsr |= ~H_IE -> hcsr &= ~H_IE;
this will remove the unwanted interrupt on power down

3. remove useless debug print outs

Cc: Shuah Khan <huah.kh@samsung.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---

Hope this finally resolve the ME reset issue

 drivers/misc/mei/hw-me.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index b22c7e2..3412adc 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -176,21 +176,18 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
 
-	dev_dbg(&dev->pdev->dev, "before reset HCSR = 0x%08x.\n", hcsr);
-
-	hcsr |= (H_RST | H_IG);
+	hcsr |= H_RST | H_IG | H_IS;
 
 	if (intr_enable)
 		hcsr |= H_IE;
 	else
-		hcsr |= ~H_IE;
+		hcsr &= ~H_IE;
 
-	mei_hcsr_set(hw, hcsr);
+	mei_me_reg_write(hw, H_CSR, hcsr);
 
 	if (dev->dev_state == MEI_DEV_POWER_DOWN)
 		mei_me_hw_reset_release(dev);
 
-	dev_dbg(&dev->pdev->dev, "current HCSR = 0x%08x.\n", mei_hcsr_read(hw));
 	return 0;
 }
 
-- 
1.8.1.2

