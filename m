Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3IEU2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:28:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3IEU2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Shuah Khan <shuah.kh@samsung.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [ 29/36] mei: me: fix hardware reset flow
Date: Thu,  5 Sep 2013 13:27:58 -0700
Message-Id: <20130905202705.734863483@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit ff96066e3171acdea356b331163495957cb833d0 upstream.

Both H_IS and H_IE needs to be set to receive H_RDY
interrupt

1. Assert H_IS to clear the interrupts during hw reset
and use mei_me_reg_write instead of mei_hcsr_set as the later
strips down the H_IS

2. fix interrupt disablement embarrassing typo
  hcsr |= ~H_IE -> hcsr &= ~H_IE;
this will remove the unwanted interrupt on power down

3. remove useless debug print outs

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: Shuah Khan <shuah.kh@samsung.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -176,16 +176,14 @@ static void mei_me_hw_reset(struct mei_d
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


