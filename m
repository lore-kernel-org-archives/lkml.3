Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab3CUIXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:23:23 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:65238 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab3CUIXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:23:18 -0400
Subject: [PATCH RFC 5/5] e1000e: make PTP clock optional
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Cochran <richardcochran@gmail.com>
Date: Thu, 21 Mar 2013 12:23:13 +0400
Message-ID: <20130321082313.21557.43970.stgit@zurg>
In-Reply-To: <20130321082256.21557.68351.stgit@zurg>
References: <20130321082256.21557.68351.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As proof of concept for new approach in managing cross-module dependencies this
patch resolves hard depencency between CONFIG_E1000E and CONFIG_PTP_1588_CLOCK.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/intel/Kconfig         |    2 +-
 drivers/net/ethernet/intel/e1000e/Makefile |    3 ++-
 drivers/net/ethernet/intel/e1000e/e1000.h  |    5 +++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 05f7264..4df239b 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -69,7 +69,7 @@ config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
 	depends on PCI && (!SPARC32 || BROKEN)
 	select CRC32
-	select PTP_1588_CLOCK
+	apply PTP_1588_CLOCK
 	---help---
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
 	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
diff --git a/drivers/net/ethernet/intel/e1000e/Makefile b/drivers/net/ethernet/intel/e1000e/Makefile
index c2dcfcc..9c67c05 100644
--- a/drivers/net/ethernet/intel/e1000e/Makefile
+++ b/drivers/net/ethernet/intel/e1000e/Makefile
@@ -34,5 +34,6 @@ obj-$(CONFIG_E1000E) += e1000e.o
 
 e1000e-objs := 82571.o ich8lan.o 80003es2lan.o \
 	       mac.o manage.o nvm.o phy.o \
-	       param.o ethtool.o netdev.o ptp.o
+	       param.o ethtool.o netdev.o
 
+e1000e-$(CONFIG_PTP_1588_CLOCK) := ptp.o
diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index fcc7581..c2819c0 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -510,8 +510,13 @@ extern const struct e1000_info e1000_pch2_info;
 extern const struct e1000_info e1000_pch_lpt_info;
 extern const struct e1000_info e1000_es2_info;
 
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
 extern void e1000e_ptp_init(struct e1000_adapter *adapter);
 extern void e1000e_ptp_remove(struct e1000_adapter *adapter);
+#else
+static inline void e1000e_ptp_init(struct e1000_adapter *adapter) { }
+static inline void e1000e_ptp_remove(struct e1000_adapter *adapter) { }
+#endif
 
 static inline s32 e1000_phy_hw_reset(struct e1000_hw *hw)
 {

