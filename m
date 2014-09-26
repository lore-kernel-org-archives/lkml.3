Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaIZKGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:06:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbaIZJq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vignesh Raman <Vignesh_Raman@mentor.com>,
        Vitaly Kuzmichev <Vitaly_Kuzmichev@mentor.com>,
        Marcel Holtmann <marcel@holtmann.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 092/142] Bluetooth: Avoid use of session socket after the session gets freed
Date: Fri, 26 Sep 2014 11:45:03 +0200
Message-Id: <83035aa2b7435be7cc34d440d809ac053246d12e.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vignesh Raman <Vignesh_Raman@mentor.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 32333edb82fb2009980eefc5518100068147ab82 upstream.

The commits 08c30aca9e698faddebd34f81e1196295f9dc063 "Bluetooth: Remove
RFCOMM session refcnt" and 8ff52f7d04d9cc31f1e81dcf9a2ba6335ed34905
"Bluetooth: Return RFCOMM session ptrs to avoid freed session"
allow rfcomm_recv_ua and rfcomm_session_close to delete the session
(and free the corresponding socket) and propagate NULL session pointer
to the upper callers.

Additional fix is required to terminate the loop in rfcomm_process_rx
function to avoid use of freed 'sk' memory.

The issue is only reproducible with kernel option CONFIG_PAGE_POISONING
enabled making freed memory being changed and filled up with fixed char
value used to unmask use-after-free issues.

Signed-off-by: Vignesh Raman <Vignesh_Raman@mentor.com>
Signed-off-by: Vitaly Kuzmichev <Vitaly_Kuzmichev@mentor.com>
Acked-by: Dean Jenkins <Dean_Jenkins@mentor.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/rfcomm/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index ca957d34b0c8..19ba192e9dbf 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1857,10 +1857,13 @@ static struct rfcomm_session *rfcomm_process_rx(struct rfcomm_session *s)
 	/* Get data directly from socket receive queue without copying it. */
 	while ((skb = skb_dequeue(&sk->sk_receive_queue))) {
 		skb_orphan(skb);
-		if (!skb_linearize(skb))
+		if (!skb_linearize(skb)) {
 			s = rfcomm_recv_frame(s, skb);
-		else
+			if (!s)
+				break;
+		} else {
 			kfree_skb(skb);
+		}
 	}
 
 	if (s && (sk->sk_state == BT_CLOSED))
-- 
2.1.0

