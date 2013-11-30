Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3K3Wlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:41:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21678 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3K3Wk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:40:57 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, David Airlie <airlied@linux.ie>
Subject: [PATCH v3 12/12] intel-gtt: Read 64bit for gmar_bus_addr
Date: Sat, 30 Nov 2013 14:40:38 -0800
Message-Id: <1385851238-21085-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That bar could be 64bit pref mem and above 4G.

-v2: refresh to 3.13-rc1

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/char/agp/intel-gtt.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index b8e2014..b929e9d 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -609,8 +609,10 @@ static bool intel_gtt_can_wc(void)
 static int intel_gtt_init(void)
 {
 	u32 gma_addr;
+	u32 addr_hi = 0;
 	u32 gtt_map_size;
 	int ret;
+	int pos;
 
 	ret = intel_private.driver->setup();
 	if (ret != 0)
@@ -660,13 +662,17 @@ static int intel_gtt_init(void)
 	}
 
 	if (INTEL_GTT_GEN <= 2)
-		pci_read_config_dword(intel_private.pcidev, I810_GMADDR,
-				      &gma_addr);
+		pos = I810_GMADDR;
 	else
-		pci_read_config_dword(intel_private.pcidev, I915_GMADDR,
-				      &gma_addr);
+		pos = I915_GMADDR;
+
+	pci_read_config_dword(intel_private.pcidev, pos, &gma_addr);
+
+	if (gma_addr & PCI_BASE_ADDRESS_MEM_TYPE_64)
+		pci_read_config_dword(intel_private.pcidev, pos + 4, &addr_hi);
 
 	intel_private.gma_bus_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
+	intel_private.gma_bus_addr |= (u64)addr_hi << 32;
 
 	return 0;
 }
-- 
1.8.1.4

