Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbaKSU4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:56:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbaKSUyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anish Bhatt <anish@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 111/141] cxgb4 : Handle dcb enable correctly
Date: Wed, 19 Nov 2014 12:52:14 -0800
Message-Id: <20141119205154.270966486@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anish Bhatt <anish@chelsio.com>

commit 3bb062613b1ecbd0c388106f61344d699f7859ec upstream.

Disabling DCBx in firmware automatically enables DCBx for control via host
lldp agents. Wait for an explicit setstate call from an lldp agents to enable
 DCBx instead.

Fixes: 76bcb31efc06 ("cxgb4 : Add DCBx support codebase and dcbnl_ops")

Signed-off-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c  |    7 ++++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |    6 +++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
@@ -80,7 +80,6 @@ void cxgb4_dcb_state_fsm(struct net_devi
 			/* we're going to use Host DCB */
 			dcb->state = CXGB4_DCB_STATE_HOST;
 			dcb->supported = CXGB4_DCBX_HOST_SUPPORT;
-			dcb->enabled = 1;
 			break;
 		}
 
@@ -349,6 +348,12 @@ static u8 cxgb4_setstate(struct net_devi
 {
 	struct port_info *pi = netdev2pinfo(dev);
 
+	/* If DCBx is host-managed, dcb is enabled by outside lldp agents */
+	if (pi->dcb.state == CXGB4_DCB_STATE_HOST) {
+		pi->dcb.enabled = enabled;
+		return 0;
+	}
+
 	/* Firmware doesn't provide any mechanism to control the DCB state.
 	 */
 	if (enabled != (pi->dcb.state == CXGB4_DCB_STATE_FW_ALLSYNCED))
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -688,7 +688,11 @@ int cxgb4_dcb_enabled(const struct net_d
 #ifdef CONFIG_CHELSIO_T4_DCB
 	struct port_info *pi = netdev_priv(dev);
 
-	return pi->dcb.state == CXGB4_DCB_STATE_FW_ALLSYNCED;
+	if (!pi->dcb.enabled)
+		return 0;
+
+	return ((pi->dcb.state == CXGB4_DCB_STATE_FW_ALLSYNCED) ||
+		(pi->dcb.state == CXGB4_DCB_STATE_HOST));
 #else
 	return 0;
 #endif


