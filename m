Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbaEEMx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:53:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41002 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932296AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Ertman <davidx.m.ertman@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 12/50] e1000e: Fix no connectivity when driver loaded with cable out
Date: Mon,  5 May 2014 14:42:54 +0200
Message-Id: <ee16a58677a12cd4b17e76ba8565117e435f5e1f.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ertman <davidx.m.ertman@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b20a774495671f037e7160ea2ce8789af6b61533 upstream.

In commit da1e2046e5, the flow for enabling/disabling an Si errata
workaround (e1000_lv_jumbo_workaround_ich8lan) was changed to fix a problem
with iAMT connections dropping on interface down with jumbo frames set.
Part of this change was to move the function call disabling the workaround
to e1000e_down() from the e1000_setup_rctl() function.  The mechanic for
disabling of this workaround involves writing several MAC and PHY registers
back to hardware defaults.

After this commit, when the driver is loaded with the cable out, the PHY
registers are not programmed with the correct default values.  This causes
the device to be capable of transmitting packets, but is unable to recieve
them until this workaround is called.

The flow of e1000e's open code relies upon calling the above workaround to
expicitly program these registers either with jumbo frame appropriate settings
or h/w defaults on 82579 and newer hardware.

Fix this issue by adding logic to e1000_setup_rctl() that not only calls
e1000_lv_jumbo_workaround_ich8lan() when jumbo frames are set, to enable the
workaround, but also calls this function to explicitly disable the workaround
in the case that jumbo frames are not set.

Signed-off-by: Dave Ertman <davidx.m.ertman@intel.com>
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 4ef786775acb..9cb400c4cbaa 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -2976,11 +2976,21 @@ static void e1000_setup_rctl(struct e1000_adapter *adapter)
 	u32 rctl, rfctl;
 	u32 pages = 0;
 
-	/* Workaround Si errata on PCHx - configure jumbo frame flow */
-	if ((hw->mac.type >= e1000_pch2lan) &&
-	    (adapter->netdev->mtu > ETH_DATA_LEN) &&
-	    e1000_lv_jumbo_workaround_ich8lan(hw, true))
-		e_dbg("failed to enable jumbo frame workaround mode\n");
+	/* Workaround Si errata on PCHx - configure jumbo frame flow.
+	 * If jumbo frames not set, program related MAC/PHY registers
+	 * to h/w defaults
+	 */
+	if (hw->mac.type >= e1000_pch2lan) {
+		s32 ret_val;
+
+		if (adapter->netdev->mtu > ETH_DATA_LEN)
+			ret_val = e1000_lv_jumbo_workaround_ich8lan(hw, true);
+		else
+			ret_val = e1000_lv_jumbo_workaround_ich8lan(hw, false);
+
+		if (ret_val)
+			e_dbg("failed to enable|disable jumbo frame workaround mode\n");
+	}
 
 	/* Program MC offset vector base */
 	rctl = er32(RCTL);
-- 
1.9.2

