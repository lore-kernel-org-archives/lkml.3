Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbbALSbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:31:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbbALSbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 201/216] iwlwifi: make U-APSD default configurable at compile time
Date: Mon, 12 Jan 2015 18:29:39 +0000
Message-Id: <1421087394-2712-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit d6ca18de129fc4dd4374389561930b32820f35ff upstream.

With a significant number of deployed APs, enabling uAPSD leads to the
AP never using aggregation sessions (likely due to the complexities
involved in handling uAPSD in those.) This obviously results in a large
drop in throughput with such APs.

On the other hand, uAPSD can result in some power consumption benefits,
but for now just disable it to get performance with affected APs back
up.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/Kconfig   | 10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-drv.c |  8 +++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 7fd50428b934..9c67e255c689 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -85,6 +85,16 @@ config IWLWIFI_BCAST_FILTERING
 	  If unsure, don't enable this option, as some programs might
 	  expect incoming broadcasts for their normal operations.
 
+config IWLWIFI_UAPSD
+	bool "enable U-APSD by default"
+	depends on IWLMVM
+	help
+	  Say Y here to enable U-APSD by default. This may cause
+	  interoperability problems with some APs, manifesting in lower than
+	  expected throughput due to those APs not enabling aggregation
+
+	  If unsure, say N.
+
 menu "Debugging Options"
 	depends on IWLWIFI
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index f2a5c12269a3..a09ce04c0f63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1243,7 +1243,9 @@ struct iwl_mod_params iwlwifi_mod_params = {
 	.bt_coex_active = true,
 	.power_level = IWL_POWER_INDEX_1,
 	.wd_disable = true,
-	.uapsd_disable = false,
+#ifndef CONFIG_IWLWIFI_UAPSD
+	.uapsd_disable = true,
+#endif /* CONFIG_IWLWIFI_UAPSD */
 	/* the rest are 0 by default */
 };
 IWL_EXPORT_SYMBOL(iwlwifi_mod_params);
@@ -1359,7 +1361,11 @@ MODULE_PARM_DESC(nvm_file, "NVM file name");
 
 module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable,
 		   bool, S_IRUGO);
+#ifdef CONFIG_IWLWIFI_UAPSD
 MODULE_PARM_DESC(uapsd_disable, "disable U-APSD functionality (default: N)");
+#else
+MODULE_PARM_DESC(uapsd_disable, "disable U-APSD functionality (default: Y)");
+#endif
 
 /*
  * set bt_coex_active to true, uCode will do kill/defer
-- 
2.1.4

