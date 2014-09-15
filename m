Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbaIOWRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:17:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51027 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaIOWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vignesh Raman <Vignesh_Raman@mentor.com>,
        Vitaly Kuzmichev <Vitaly_Kuzmichev@mentor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 088/187] Bluetooth: Avoid use of session socket after the session gets freed
Date: Mon, 15 Sep 2014 15:08:18 -0700
Message-Id: <1410818997-9432-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Raman <Vignesh_Raman@mentor.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/rfcomm/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index facd8a7..b088651 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1859,10 +1859,13 @@ static struct rfcomm_session *rfcomm_process_rx(struct rfcomm_session *s)
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
1.9.1

