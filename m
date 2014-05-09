Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaEIFgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 01:36:15 -0400
Received: from mail1.windriver.com ([147.11.146.13]:38952 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaEIFgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 01:36:14 -0400
From: Xufeng Zhang <xufeng.zhang@windriver.com>
To: <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] af_key: return error when meet errors on sendmsg() syscall
Date: Fri, 9 May 2014 13:47:35 +0800
Message-ID: <1399614455-10551-1-git-send-email-xufeng.zhang@windriver.com>
X-Mailer: git-send-email 1.7.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation for pfkey_sendmsg() always return success
no matter whether or not error happens during this syscall,
this is incompatible with the general send()/sendmsg() API:
  man send
    RETURN VALUE
      On success, these calls return the number of characters sent.
      On error, -1 is returned, and errno is set appropriately.

One side effect this problem introduces is that we can't determine
when to resend the message when the previous send() fails because
it was interrupted by signals.
We detect such a problem when racoon is sending SADBADD message to
add SAD entry in the kernel, but sometimes kernel is responding with
"Interrupted system call"(-EINTR) error.

Check the send implementation of strongswan, it has below logic:
  pfkey_send_socket()
  {
  	...
  	while (TRUE)
  	{
        	len = send(socket, in, in_len, 0);

  		if (len != in_len)
  		{
  			case EINTR:
  				/* interrupted, try again */
  				continue;
  			...
  		}
  	}
  	...
}
So it makes sense to return errors for send() syscall.      

Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
---
 net/key/af_key.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index f3c8307..9e4bc8c 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -335,7 +335,7 @@ static int pfkey_error(const struct sadb_msg *orig, int err, struct sock *sk)
 
 	pfkey_broadcast(skb, GFP_KERNEL, BROADCAST_ONE, sk, sock_net(sk));
 
-	return 0;
+	return -err;
 }
 
 static const u8 sadb_ext_min_len[] = {
@@ -3644,8 +3644,8 @@ static int pfkey_sendmsg(struct kiocb *kiocb,
 	mutex_unlock(&net->xfrm.xfrm_cfg_mutex);
 
 out:
-	if (err && hdr && pfkey_error(hdr, err, sk) == 0)
-		err = 0;
+	if (err && hdr)
+		err = pfkey_error(hdr, err, sk);
 	kfree_skb(skb);
 
 	return err ? : len;
-- 
1.7.0.2

