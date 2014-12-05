Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaLEWrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:47:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaLEWqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vladislav Yasevich <vyasevic@redhat.com>,
        Emil Tantilov <emil.s.tantilov@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 102/122] ixgbe: Correctly disable VLAN filter in promiscuous mode
Date: Fri,  5 Dec 2014 14:44:36 -0800
Message-Id: <20141205223321.315361724@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4059,8 +4059,8 @@ void ixgbe_set_rx_mode(struct net_device
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


