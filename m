Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3IINSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:18:18 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:19153 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3IINRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:17:09 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        Mike Marciniszyn <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>,
        Roland Dreier <roland@purestorage.com>
CC: <linux-kernel@vger.kernel.org>, Mark Einon <mark.einon@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        <linux-rdma@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 6/6] radeon: Use pcie_get_readrq() and pcie_set_readrq() to simplify code
Date: Mon, 9 Sep 2013 21:13:08 +0800
Message-ID: <1378732388-4508-7-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pcie_get_readrq() and pcie_set_readrq() functions to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/gpu/drm/radeon/evergreen.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index d5b49e3..b191f92 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1169,23 +1169,16 @@ int evergreen_set_uvd_clocks(struct radeon_device *rdev, u32 vclk, u32 dclk)
 
 void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
 {
-	u16 ctl, v;
-	int err;
-
-	err = pcie_capability_read_word(rdev->pdev, PCI_EXP_DEVCTL, &ctl);
-	if (err)
-		return;
-
-	v = (ctl & PCI_EXP_DEVCTL_READRQ) >> 12;
+	int readrq;
+	u16 v;
 
+	readrq = pcie_get_readrq(rdev->pdev);
+	v = ffs(readrq) - 8;
 	/* if bios or OS sets MAX_READ_REQUEST_SIZE to an invalid value, fix it
 	 * to avoid hangs or perfomance issues
 	 */
-	if ((v == 0) || (v == 6) || (v == 7)) {
-		ctl &= ~PCI_EXP_DEVCTL_READRQ;
-		ctl |= (2 << 12);
-		pcie_capability_write_word(rdev->pdev, PCI_EXP_DEVCTL, ctl);
-	}
+	if ((v == 0) || (v == 6) || (v == 7))
+		pcie_set_readrq(rdev->pdev, 512);
 }
 
 static bool dce4_is_in_vblank(struct radeon_device *rdev, int crtc)
-- 
1.7.1


