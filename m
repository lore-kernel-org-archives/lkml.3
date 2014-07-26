Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaGZTEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:04:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaGZTDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John Greene <jogreene@redhat.com>,
        Dave Ertman <davidx.m.ertman@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Alexander Y. Fomichev" <aleksandr.fomichev@x5.ru>
Subject: [PATCH 3.14 28/87] e1000e: Fix SHRA register access for 82579
Date: Sat, 26 Jul 2014 12:02:02 -0700
Message-Id: <20140726190215.440192469@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ertman <davidx.m.ertman@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/ich8lan.c |    2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1374,7 +1374,7 @@ static void e1000_rar_set_pch2lan(struct
 	/* RAR[1-6] are owned by manageability.  Skip those and program the
 	 * next address into the SHRA register array.
 	 */
-	if (index < (u32)(hw->mac.rar_entry_count - 6)) {
+	if (index < (u32)(hw->mac.rar_entry_count)) {
 		s32 ret_val;
 
 		ret_val = e1000_acquire_swflag_ich8lan(hw);
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -98,7 +98,7 @@
 #define PCIE_ICH8_SNOOP_ALL	PCIE_NO_SNOOP_ALL
 
 #define E1000_ICH_RAR_ENTRIES	7
-#define E1000_PCH2_RAR_ENTRIES	11      /* RAR[0-6], SHRA[0-3] */
+#define E1000_PCH2_RAR_ENTRIES	5	/* RAR[0], SHRA[0-3] */
 #define E1000_PCH_LPT_RAR_ENTRIES	12	/* RAR[0], SHRA[0-10] */
 
 #define PHY_PAGE_SHIFT		5


