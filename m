Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaG3Mkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:40:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36665 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792AbaG3MP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Ertman <davidx.m.ertman@intel.com>,
        John Greene <jogreene@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Alexander Y. Fomichev" <aleksandr.fomichev@x5.ru>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 30/94] e1000e: Fix SHRA register access for 82579
Date: Wed, 30 Jul 2014 14:14:19 +0200
Message-Id: <b0d711510509931f482d791abb5bb706d7f97a9c.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ertman <davidx.m.ertman@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 96dee024ca4799d6d21588951240035c21ba1c67 upstream.

Previous commit c3a0dce35af0 fixed an overrun for the RAR on i218 devices.
This commit also attempted to homogenize the RAR/SHRA access for all parts
accessed by the e1000e driver.  This change introduced an error for
assigning MAC addresses to guest OS's for 82579 devices.

Only RAR[0] is accessible to the driver for 82579 parts, and additional
addresses must be placed into the SHRA[L|H] registers.  The rar_entry_count
was changed in the previous commit to an inaccurate value that accounted
for all RAR and SHRA registers, not just the ones usable by the driver.

This patch fixes the count to the correct value and adjusts the
e1000_rar_set_pch2lan() function to user the correct index.

Cc: John Greene <jogreene@redhat.com>
Signed-off-by: Dave Ertman <davidx.m.ertman@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "Alexander Y. Fomichev" <aleksandr.fomichev@x5.ru>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 42f0f6717511..70e16f71f574 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1374,7 +1374,7 @@ static void e1000_rar_set_pch2lan(struct e1000_hw *hw, u8 *addr, u32 index)
 	/* RAR[1-6] are owned by manageability.  Skip those and program the
 	 * next address into the SHRA register array.
 	 */
-	if (index < (u32)(hw->mac.rar_entry_count - 6)) {
+	if (index < (u32)(hw->mac.rar_entry_count)) {
 		s32 ret_val;
 
 		ret_val = e1000_acquire_swflag_ich8lan(hw);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 217090df33e7..59865695b282 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -98,7 +98,7 @@
 #define PCIE_ICH8_SNOOP_ALL	PCIE_NO_SNOOP_ALL
 
 #define E1000_ICH_RAR_ENTRIES	7
-#define E1000_PCH2_RAR_ENTRIES	11      /* RAR[0-6], SHRA[0-3] */
+#define E1000_PCH2_RAR_ENTRIES	5	/* RAR[0], SHRA[0-3] */
 #define E1000_PCH_LPT_RAR_ENTRIES	12	/* RAR[0], SHRA[0-10] */
 
 #define PHY_PAGE_SHIFT		5
-- 
2.0.1

