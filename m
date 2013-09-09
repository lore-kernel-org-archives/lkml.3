Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3IINRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:17:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:52482 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3IINRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:17:06 -0400
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
Subject: [PATCH 2/6] title/pci: use cached pci_dev->pcie_mpss to simplify code
Date: Mon, 9 Sep 2013 21:13:04 +0800
Message-ID: <1378732388-4508-3-git-send-email-wangyijing@huawei.com>
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

The PCI core caches the "PCI-E Max Payload Size Supported" in
pci_dev->pcie_mpss, so use that instead of pcie_capability_read_dword().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/tile/kernel/pci.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 67237d3..692a799 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -246,15 +246,12 @@ static void fixup_read_and_payload_sizes(void)
 	/* Scan for the smallest maximum payload size. */
 	for_each_pci_dev(dev) {
 		u32 devcap;
-		int max_payload;
 
 		if (!pci_is_pcie(dev))
 			continue;
 
-		pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &devcap);
-		max_payload = devcap & PCI_EXP_DEVCAP_PAYLOAD;
-		if (max_payload < smallest_max_payload)
-			smallest_max_payload = max_payload;
+		if (dev->pcie_mpss < smallest_max_payload)
+			smallest_max_payload = dev->pcie_mpss;
 	}
 
 	/* Now, set the max_payload_size for all devices to that value. */
-- 
1.7.1


