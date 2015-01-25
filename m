Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbbAYSgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:36:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbbAYSKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.18 126/183] mei: clean reset bit before reset
Date: Sun, 25 Jan 2015 10:07:28 -0800
Message-Id: <20150125180815.645042178@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -234,6 +234,18 @@ static int mei_me_hw_reset(struct mei_de
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


