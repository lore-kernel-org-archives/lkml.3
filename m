Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaF3MGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:06:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52032 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753740AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 087/181] mei: me: read H_CSR after asserting reset
Date: Mon, 30 Jun 2014 13:51:48 +0200
Message-Id: <9c535353f1c3ea9b70ee99fa76d91d4d95a4fa97.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c40765d919d25d2d44d99c4ce39e48808f137e1e upstream.

According the spec the host should read H_CSR again
after asserting reset H_RST to ensure that reset was
read by the firmware

Cc: stable@vger.kernel.org #3.12
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/misc/mei/hw-me.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 6cba26d9465f..aef6ec137acd 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -186,7 +186,19 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	dev->recvd_hw_ready = false;
 	mei_me_reg_write(hw, H_CSR, hcsr);
 
-	if (dev->dev_state == MEI_DEV_POWER_DOWN)
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
+	if (intr_enable == false)
 		mei_me_hw_reset_release(dev);
 
 	return 0;
-- 
2.0.0

