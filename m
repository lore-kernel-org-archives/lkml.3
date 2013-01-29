Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3A2Dfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:35:33 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:34344 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756320Ab3A2Dfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:31 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 01/11] staging/fwserial: Only reset port status for attached peers
Date: Mon, 28 Jan 2013 22:34:35 -0500
Message-Id: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a port has been reserved in an attempt to connect to a peer
but that attempt does not succeed, releasing the port should not
reset the port line status. Although resetting is functionally
harmless, it can appear as if a remote peer dropped carrier to a
port it was not attached to (which can be confusing).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 48523eb..b1482ef 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1774,10 +1774,11 @@ static struct fwtty_port *fwserial_find_port(struct fwtty_peer *peer)
 	return NULL;
 }
 
-static void fwserial_release_port(struct fwtty_port *port)
+static void fwserial_release_port(struct fwtty_port *port, bool reset)
 {
 	/* drop carrier (and all other line status) */
-	fwtty_update_port_status(port, 0);
+	if (reset)
+		fwtty_update_port_status(port, 0);
 
 	spin_lock_bh(&port->lock);
 
@@ -1807,7 +1808,7 @@ static void fwserial_plug_timeout(unsigned long data)
 	spin_unlock_bh(&peer->lock);
 
 	if (port)
-		fwserial_release_port(port);
+		fwserial_release_port(port, false);
 }
 
 /**
@@ -1870,7 +1871,7 @@ cancel_timer:
 	peer_revert_state(peer);
 release_port:
 	spin_unlock_bh(&peer->lock);
-	fwserial_release_port(port);
+	fwserial_release_port(port, false);
 free_pkt:
 	kfree(pkt);
 	return err;
@@ -2148,7 +2149,7 @@ static void fwserial_remove_peer(struct fwtty_peer *peer)
 	spin_unlock_bh(&peer->lock);
 
 	if (port)
-		fwserial_release_port(port);
+		fwserial_release_port(port, true);
 
 	synchronize_rcu();
 	kfree(peer);
@@ -2608,7 +2609,7 @@ static void fwserial_handle_plug_req(struct work_struct *work)
 
 	spin_unlock_bh(&peer->lock);
 	if (port)
-		fwserial_release_port(port);
+		fwserial_release_port(port, false);
 
 	rcode = fwserial_send_mgmt_sync(peer, pkt);
 
@@ -2630,7 +2631,7 @@ static void fwserial_handle_plug_req(struct work_struct *work)
 cleanup:
 	spin_unlock_bh(&peer->lock);
 	if (port)
-		fwserial_release_port(port);
+		fwserial_release_port(port, false);
 	kfree(pkt);
 	return;
 }
@@ -2682,7 +2683,7 @@ static void fwserial_handle_unplug_req(struct work_struct *work)
 cleanup:
 	spin_unlock_bh(&peer->lock);
 	if (port)
-		fwserial_release_port(port);
+		fwserial_release_port(port, true);
 	kfree(pkt);
 	return;
 }
@@ -2693,6 +2694,7 @@ static int fwserial_parse_mgmt_write(struct fwtty_peer *peer,
 				     size_t len)
 {
 	struct fwtty_port *port = NULL;
+	bool reset = false;
 	int rcode;
 
 	if (addr != fwserial_mgmt_addr_handler.offset || len < sizeof(pkt->hdr))
@@ -2768,6 +2770,7 @@ static int fwserial_parse_mgmt_write(struct fwtty_peer *peer,
 			if (be16_to_cpu(pkt->hdr.code) & FWSC_RSP_NACK)
 				fwtty_notice(&peer->unit, "NACK unplug?");
 			port = peer_revert_state(peer);
+			reset = true;
 		}
 		break;
 
@@ -2779,7 +2782,7 @@ static int fwserial_parse_mgmt_write(struct fwtty_peer *peer,
 	spin_unlock_bh(&peer->lock);
 
 	if (port)
-		fwserial_release_port(port);
+		fwserial_release_port(port, reset);
 
 	return rcode;
 }
-- 
1.8.1.1

