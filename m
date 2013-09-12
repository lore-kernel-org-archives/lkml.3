Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3ILSEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:04:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3ILR7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Erik Hugne <erik.hugne@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 34/46] tipc: set sk_err correctly when connection fails
Date: Thu, 12 Sep 2013 10:58:45 -0700
Message-Id: <20130912175724.698023816@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1179,7 +1179,7 @@ static u32 filter_connect(struct tipc_so
 		/* Accept only ACK or NACK message */
 		if (unlikely(msg_errcode(msg))) {
 			sock->state = SS_DISCONNECTING;
-			sk->sk_err = -ECONNREFUSED;
+			sk->sk_err = ECONNREFUSED;
 			retval = TIPC_OK;
 			break;
 		}
@@ -1190,7 +1190,7 @@ static u32 filter_connect(struct tipc_so
 		res = auto_connect(sock, msg);
 		if (res) {
 			sock->state = SS_DISCONNECTING;
-			sk->sk_err = res;
+			sk->sk_err = -res;
 			retval = TIPC_OK;
 			break;
 		}


