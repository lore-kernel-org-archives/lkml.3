Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3IKEaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3IKE3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:04 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=FimGvo4joy8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=U013quMCeBUA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042858.736772187@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [039/251] x25: Fix broken locking in ioctl error paths.
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0039-x25-Fix-broken-locking-in-ioctl-error-paths.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

[ Upstream commit 4ccb93ce7439b63c31bc7597bfffd13567fa483d ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/x25/af_x25.c |   15 ++++++++-------
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
1.7.10.4


