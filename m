Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaFLXbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:31:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaFLXR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:17:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 3.15 07/12] mei: me: read H_CSR after asserting reset
Date: Thu, 12 Jun 2014 16:21:09 -0700
Message-Id: <20140612232045.176406701@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232044.886466924@linuxfoundation.org>
References: <20140612232044.886466924@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit c40765d919d25d2d44d99c4ce39e48808f137e1e upstream.

According the spec the host should read H_CSR again
after asserting reset H_RST to ensure that reset was
read by the firmware

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -189,6 +189,18 @@ static int mei_me_hw_reset(struct mei_de
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
 


