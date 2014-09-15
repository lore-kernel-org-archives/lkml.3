Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaIOTcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:32:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbaIOT1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vignesh Raman <Vignesh_Raman@mentor.com>,
        Vitaly Kuzmichev <Vitaly_Kuzmichev@mentor.com>,
        Dean Jenkins <Dean_Jenkins@mentor.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.16 121/158] Bluetooth: Avoid use of session socket after the session gets freed
Date: Mon, 15 Sep 2014 12:26:00 -0700
Message-Id: <20140915192546.514000581@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/rfcomm/core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1909,10 +1909,13 @@ static struct rfcomm_session *rfcomm_pro
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


