Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab3ILSSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:18:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3ILSPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Shuah Khan <shuah.kh@samsung.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [ 06/16] mei: me: fix hardware reset flow
Date: Thu, 12 Sep 2013 11:14:58 -0700
Message-Id: <20130912181156.906195025@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/misc/mei/hw-me.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -176,21 +176,18 @@ static int mei_me_hw_reset(struct mei_de
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
 


