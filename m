Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaLOOsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:48:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaLOO2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jacob Keller <jacob.e.keller@intel.com>,
        Vladislav Yasevich <vyasevic@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 098/168] ixgbe: Correctly disable VLAN filter in promiscuous mode
Date: Mon, 15 Dec 2014 14:25:52 +0000
Message-Id: <1418653622-21105-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

commit 4556dc591691fca743518edb24f15fbc83b5c8ef upstream.

IXGBE adapter seems to require that VLAN filtering be enabled if
VMDQ or SRIOV are enabled.  When those functions are disabled,
VLAN filtering may be disabled in promiscuous mode.

Prior to commit a9b8943ee129 ("ixgbe: remove vlan_filter_disable
and enable functions")

The logic was correct.  However, after the commit the logic
got reversed and VLAN filtered in now turned on when VMDQ/SRIOV
is disabled.

This patch changes the condition to enable hw vlan filtered
when VMDQ or SRIOV is enabled.

Fixes: a9b8943ee129 ("ixgbe: remove vlan_filter_disable and enable functions")
CC: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Acked-by: Emil Tantilov <emil.s.tantilov@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index f5aa3311ea28..889005922c33 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4065,8 +4065,8 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 		 * if SR-IOV and VMDQ are disabled - otherwise ensure
 		 * that hardware VLAN filters remain enabled.
 		 */
-		if (!(adapter->flags & (IXGBE_FLAG_VMDQ_ENABLED |
-					IXGBE_FLAG_SRIOV_ENABLED)))
+		if (adapter->flags & (IXGBE_FLAG_VMDQ_ENABLED |
+				      IXGBE_FLAG_SRIOV_ENABLED))
 			vlnctrl |= (IXGBE_VLNCTRL_VFE | IXGBE_VLNCTRL_CFIEN);
 	} else {
 		if (netdev->flags & IFF_ALLMULTI) {
-- 
2.1.3

