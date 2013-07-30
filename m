Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab3G3Jtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:49:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53145 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab3G3JdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 049/106] x25: Fix broken locking in ioctl error paths.
Date: Tue, 30 Jul 2013 10:31:08 +0100
Message-Id: <1375176725-5825-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

commit 4ccb93ce7439b63c31bc7597bfffd13567fa483d upstream.

Two of the x25 ioctl cases have error paths that break out of the function without
unlocking the socket, leading to this warning:

================================================
[ BUG: lock held when returning to user space! ]
3.10.0-rc7+ #36 Not tainted
------------------------------------------------
trinity-child2/31407 is leaving the kernel with locks still held!
1 lock held by trinity-child2/31407:
 #0:  (sk_lock-AF_X25){+.+.+.}, at: [<ffffffffa024b6da>] x25_ioctl+0x8a/0x740 [x25]

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/x25/af_x25.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index a306bc6..b943e3e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1586,11 +1586,11 @@ out_cud_release:
 	case SIOCX25CALLACCPTAPPRV: {
 		rc = -EINVAL;
 		lock_sock(sk);
-		if (sk->sk_state != TCP_CLOSE)
-			break;
-		clear_bit(X25_ACCPT_APPRV_FLAG, &x25->flags);
+		if (sk->sk_state == TCP_CLOSE) {
+			clear_bit(X25_ACCPT_APPRV_FLAG, &x25->flags);
+			rc = 0;
+		}
 		release_sock(sk);
-		rc = 0;
 		break;
 	}
 
@@ -1598,14 +1598,15 @@ out_cud_release:
 		rc = -EINVAL;
 		lock_sock(sk);
 		if (sk->sk_state != TCP_ESTABLISHED)
-			break;
+			goto out_sendcallaccpt_release;
 		/* must call accptapprv above */
 		if (test_bit(X25_ACCPT_APPRV_FLAG, &x25->flags))
-			break;
+			goto out_sendcallaccpt_release;
 		x25_write_internal(sk, X25_CALL_ACCEPTED);
 		x25->state = X25_STATE_3;
-		release_sock(sk);
 		rc = 0;
+out_sendcallaccpt_release:
+		release_sock(sk);
 		break;
 	}
 
-- 
1.8.3.2

