Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab3JJQKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:10:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab3JJPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Erik Hugne <erik.hugne@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 022/104] tipc: set sk_err correctly when connection fails
Date: Thu, 10 Oct 2013 08:41:10 -0700
Message-Id: <1381419752-29733-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Hugne <erik.hugne@ericsson.com>

[ Upstream commit 2c8d85182348021fc0a1bed193a4be4161dc8364 ]

Should a connect fail, if the publication/server is unavailable or
due to some other error, a positive value will be returned and errno
is never set. If the application code checks for an explicit zero
return from connect (success) or a negative return (failure), it
will not catch the error and subsequent send() calls will fail as
shown from the strace snippet below.

socket(0x1e /* PF_??? */, SOCK_SEQPACKET, 0) = 3
connect(3, {sa_family=0x1e /* AF_??? */, sa_data="\2\1\322\4\0\0\322\4\0\0\0\0\0\0"}, 16) = 111
sendto(3, "test", 4, 0, NULL, 0)        = -1 EPIPE (Broken pipe)

The reason for this behaviour is that TIPC wrongly inverts error
codes set in sk_err.

Signed-off-by: Erik Hugne <erik.hugne@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/tipc/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index fc906d9..f6a8b59 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1223,7 +1223,7 @@ static u32 filter_connect(struct tipc_sock *tsock, struct sk_buff **buf)
 		/* Accept only ACK or NACK message */
 		if (unlikely(msg_errcode(msg))) {
 			sock->state = SS_DISCONNECTING;
-			sk->sk_err = -ECONNREFUSED;
+			sk->sk_err = ECONNREFUSED;
 			retval = TIPC_OK;
 			break;
 		}
@@ -1234,7 +1234,7 @@ static u32 filter_connect(struct tipc_sock *tsock, struct sk_buff **buf)
 		res = auto_connect(sock, msg);
 		if (res) {
 			sock->state = SS_DISCONNECTING;
-			sk->sk_err = res;
+			sk->sk_err = -res;
 			retval = TIPC_OK;
 			break;
 		}
-- 
1.8.1.2

