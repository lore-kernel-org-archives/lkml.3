Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbaBGLwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556AbaBGLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Ertman <davidx.m.ertman@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 207/233] e1000e: fix compiler warnings
Date: Fri,  7 Feb 2014 11:47:06 +0000
Message-Id: <1391773652-25214-208-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ertman <davidx.m.ertman@intel.com>

commit 9e6c3b63399dd424d33a34e08b77f2cab0b84cdc upstream.

This patch is to fix a compiler warning of __bad_udelay due to a value
of >999 being passed as a parameter to udelay() in the function
e1000e_phy_has_link_generic().  This affects the gcc compiler when
it is given a flag of -O3 and the icc compiler.

This patch is also making the change from mdelay() to msleep() in the
same function, since it was determined though code inspection that this
function is never called in atomic context.

Signed-off-by: David Ertman <davidx.m.ertman@intel.com>
Acked-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/phy.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index da2be59..20e71f4 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -1757,19 +1757,23 @@ s32 e1000e_phy_has_link_generic(struct e1000_hw *hw, u32 iterations,
 		 * it across the board.
 		 */
 		ret_val = e1e_rphy(hw, MII_BMSR, &phy_status);
-		if (ret_val)
+		if (ret_val) {
 			/* If the first read fails, another entity may have
 			 * ownership of the resources, wait and try again to
 			 * see if they have relinquished the resources yet.
 			 */
-			udelay(usec_interval);
+			if (usec_interval >= 1000)
+				msleep(usec_interval / 1000);
+			else
+				udelay(usec_interval);
+		}
 		ret_val = e1e_rphy(hw, MII_BMSR, &phy_status);
 		if (ret_val)
 			break;
 		if (phy_status & BMSR_LSTATUS)
 			break;
 		if (usec_interval >= 1000)
-			mdelay(usec_interval / 1000);
+			msleep(usec_interval / 1000);
 		else
 			udelay(usec_interval);
 	}
-- 
1.8.3.2

