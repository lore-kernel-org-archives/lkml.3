Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbaBDVI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:08:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933787AbaBDVIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Ertman <davidx.m.ertman@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 3.12 006/133] e1000e: fix compiler warnings
Date: Tue,  4 Feb 2014 13:06:47 -0800
Message-Id: <20140204210737.204219911@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/phy.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -1757,19 +1757,23 @@ s32 e1000e_phy_has_link_generic(struct e
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


