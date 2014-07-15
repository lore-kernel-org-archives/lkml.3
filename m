Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbaGOVnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:43:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55110 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964880AbaGOVj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 065/198] mei: me: read H_CSR after asserting reset
Date: Tue, 15 Jul 2014 14:28:55 -0700
Message-Id: <1405459868-15089-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit c40765d919d25d2d44d99c4ce39e48808f137e1e upstream.

According the spec the host should read H_CSR again
after asserting reset H_RST to ensure that reset was
read by the firmware

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.13-stable: also includes mei_me_hw_reset() change from
    33ec082 mei: revamp mei reset state machine ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/mei/hw-me.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 4835edc..cbc9187 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -189,7 +189,19 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
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
1.9.1

