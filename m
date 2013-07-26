Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab3GZJKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:10:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30078 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GZJKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:10:52 -0400
Message-ID: <51F23D0F.7090909@oracle.com>
Date: Fri, 26 Jul 2013 17:10:39 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: jbarnes@virtuousgeek.org, bjorn.helgaas@hp.com
CC: yinghai@kernel.org, linux-kernel@vger.kernel.org, ethan.kernel@gmail.com
Subject: [PATCH] x86/PCI: MMCONFIG: cleanup and add address warning to pci_mmconfig_insert
Content-Type: multipart/mixed;
 boundary="------------040906020807010901030506"
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040906020807010901030506
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Cleanup the -EINVAL return value handling and add warning message for 
invalid
start,end,addr parameters.

Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
---
  arch/x86/pci/mmconfig-shared.c |   12 ++++++------
  1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 082e881..37f6c7f 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -700,8 +700,13 @@ int pci_mmconfig_insert(struct device *dev, u16 
seg, u8 start, u8 end,
      if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
          return -ENODEV;

-    if (start > end)
+    if (start > end || !addr) {
+        dev_warn(dev, FW_WARN
+                                 "Invalid address to add MMCONFIG"
+                                 "start %02x end %02x addr %pR\n",
+                                  start, end, addr);
          return -EINVAL;
+    }

      mutex_lock(&pci_mmcfg_lock);
      cfg = pci_mmconfig_lookup(seg, start);
@@ -716,11 +721,6 @@ int pci_mmconfig_insert(struct device *dev, u16 
seg, u8 start, u8 end,
          return -EEXIST;
      }

-    if (!addr) {
-        mutex_unlock(&pci_mmcfg_lock);
-        return -EINVAL;
-    }
-
      rc = -EBUSY;
      cfg = pci_mmconfig_alloc(seg, start, end, addr);
      if (cfg == NULL) {
-- 
1.7.1



--------------040906020807010901030506
Content-Type: text/x-patch;
 name="0001-x86-PCI-MMCONFIG-cleanup-and-add-address-warning-to-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-PCI-MMCONFIG-cleanup-and-add-address-warning-to-.pa";
 filename*1="tch"

>From 4f7337340c8b3b03fcedfa02ca7b0c3ba4379711 Mon Sep 17 00:00:00 2001
From: ethan.zhao <ethan.zhao@oracle.com>
Date: Fri, 26 Jul 2013 16:25:07 -0400
Subject: [PATCH] x86/PCI: MMCONFIG: cleanup and add address warning to pci_mmconfig_insert

Cleanup the -EINVAL return value handling and add warning message for invalid
start,end,addr parameters.

Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
---
 arch/x86/pci/mmconfig-shared.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 082e881..37f6c7f 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -700,8 +700,13 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 	if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
 		return -ENODEV;
 
-	if (start > end)
+	if (start > end || !addr) {
+		dev_warn(dev, FW_WARN
+                                 "Invalid address to add MMCONFIG"
+                                 "start %02x end %02x addr %pR\n",
+                                  start, end, addr);
 		return -EINVAL;
+	}
 
 	mutex_lock(&pci_mmcfg_lock);
 	cfg = pci_mmconfig_lookup(seg, start);
@@ -716,11 +721,6 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 		return -EEXIST;
 	}
 
-	if (!addr) {
-		mutex_unlock(&pci_mmcfg_lock);
-		return -EINVAL;
-	}
-
 	rc = -EBUSY;
 	cfg = pci_mmconfig_alloc(seg, start, end, addr);
 	if (cfg == NULL) {
-- 
1.7.1


--------------040906020807010901030506--
