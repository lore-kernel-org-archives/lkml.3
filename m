Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaDDVOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 17:14:04 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:61162 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbaDDVN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 17:13:59 -0400
To: bp@alien8.de
Cc: tony.luck@intel.com, hpa@zytor.com, mingo@kernel.org,
        dougthompson@xmission.com, m.chehab@samsung.com,
        mitake@dcl.info.waseda.ac.jp, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <76d9ab5d04d7fa60609aeacd3a6a5dfb02019c86.1396645124.git.jbaron@akamai.com>
In-Reply-To: <cover.1396645124.git.jbaron@akamai.com>
References: <cover.1396645124.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 2/3] x38_edac: make use of lo_hi_readq()
Date: Fri,  4 Apr 2014 21:13:58 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the generic API.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 drivers/edac/x38_edac.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 4891b45..e644b52 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -14,6 +14,8 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/edac.h>
+
+#include <asm-generic/io-64-nonatomic-lo-hi.h>
 #include "edac_core.h"
 
 #define X38_REVISION		"1.1"
@@ -161,11 +163,6 @@ static void x38_clear_error_info(struct mem_ctl_info *mci)
 			 X38_ERRSTS_BITS);
 }
 
-static u64 x38_readq(const void __iomem *addr)
-{
-	return readl(addr) | (((u64)readl(addr + 4)) << 32);
-}
-
 static void x38_get_and_clear_error_info(struct mem_ctl_info *mci,
 				 struct x38_error_info *info)
 {
@@ -183,9 +180,9 @@ static void x38_get_and_clear_error_info(struct mem_ctl_info *mci,
 	if (!(info->errsts & X38_ERRSTS_BITS))
 		return;
 
-	info->eccerrlog[0] = x38_readq(window + X38_C0ECCERRLOG);
+	info->eccerrlog[0] = lo_hi_readq(window + X38_C0ECCERRLOG);
 	if (x38_channel_num == 2)
-		info->eccerrlog[1] = x38_readq(window + X38_C1ECCERRLOG);
+		info->eccerrlog[1] = lo_hi_readq(window + X38_C1ECCERRLOG);
 
 	pci_read_config_word(pdev, X38_ERRSTS, &info->errsts2);
 
@@ -196,10 +193,10 @@ static void x38_get_and_clear_error_info(struct mem_ctl_info *mci,
 	 * should be UE info.
 	 */
 	if ((info->errsts ^ info->errsts2) & X38_ERRSTS_BITS) {
-		info->eccerrlog[0] = x38_readq(window + X38_C0ECCERRLOG);
+		info->eccerrlog[0] = lo_hi_readq(window + X38_C0ECCERRLOG);
 		if (x38_channel_num == 2)
 			info->eccerrlog[1] =
-				x38_readq(window + X38_C1ECCERRLOG);
+				lo_hi_readq(window + X38_C1ECCERRLOG);
 	}
 
 	x38_clear_error_info(mci);
-- 
1.8.2.rc2

