Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaLXWjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 17:39:13 -0500
Received: from mga14.intel.com ([192.55.52.115]:59309 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaLXWjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 17:39:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="503758175"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        <stable@vger.kernel.org>, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.19] mei: clean reset bit before reset
Date: Thu, 25 Dec 2014 00:37:46 +0200
Message-Id: <1419460666-10251-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

H_RST bit in H_CSR register may be found lit before reset is started,
for example if preceding reset flow hasn't completed.
In that case asserting H_RST will be ignored, therefore we need to clean
H_RST bit to start a successful reset sequence.

Cc: <stable@vger.kernel.org> #3.10+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index ff2755062b44..06ff0a2ec960 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -234,6 +234,18 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
 
+	/* H_RST may be found lit before reset is started,
+	 * for example if preceding reset flow hasn't completed.
+	 * In that case asserting H_RST will be ignored, therefore
+	 * we need to clean H_RST bit to start a successful reset sequence.
+	 */
+	if ((hcsr & H_RST) == H_RST) {
+		dev_warn(dev->dev, "H_RST is set = 0x%08X", hcsr);
+		hcsr &= ~H_RST;
+		mei_me_reg_write(hw, H_CSR, hcsr);
+		hcsr = mei_hcsr_read(hw);
+	}
+
 	hcsr |= H_RST | H_IG | H_IS;
 
 	if (intr_enable)
-- 
1.9.3

