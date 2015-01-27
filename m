Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbbA0M0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:26:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35390 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbbA0MTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 104/126] mei: clean reset bit before reset
Date: Tue, 27 Jan 2015 12:16:49 +0000
Message-Id: <1422361031-19364-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit b13a65ef190e488e2761d65bdd2e1fe8a3a125f5 upstream.

H_RST bit in H_CSR register may be found lit before reset is started,
for example if preceding reset flow hasn't completed.
In that case asserting H_RST will be ignored, therefore we need to clean
H_RST bit to start a successful reset sequence.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.16:
  - replace dev->dev by &dev->pdev->dev ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/mei/hw-me.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 6a2d272cea43..9d0cd32d885a 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -196,6 +196,18 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
 
+	/* H_RST may be found lit before reset is started,
+	 * for example if preceding reset flow hasn't completed.
+	 * In that case asserting H_RST will be ignored, therefore
+	 * we need to clean H_RST bit to start a successful reset sequence.
+	 */
+	if ((hcsr & H_RST) == H_RST) {
+		dev_warn(&dev->pdev->dev, "H_RST is set = 0x%08X", hcsr);
+		hcsr &= ~H_RST;
+		mei_me_reg_write(hw, H_CSR, hcsr);
+		hcsr = mei_hcsr_read(hw);
+	}
+
 	hcsr |= H_RST | H_IG | H_IS;
 
 	if (intr_enable)
-- 
2.1.4

