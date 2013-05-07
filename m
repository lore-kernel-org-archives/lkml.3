Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab3EGNk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42163 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab3EGNkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 029/118] atm: update msg_namelen in vcc_recvmsg()
Date: Tue,  7 May 2013 14:37:55 +0100
Message-Id: <1367933964-1564-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 9b3e617f3df53822345a8573b6d358f6b9e5ed87 upstream.

The current code does not fill the msg_name member in case it is set.
It also does not set the msg_namelen member to 0 and therefore makes
net/socket.c leak the local, uninitialized sockaddr_storage variable
to userland -- 128 bytes of kernel stack memory.

Fix that by simply setting msg_namelen to 0 as obviously nobody cared
about vcc_recvmsg() not filling the msg_name in case it was set.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/atm/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/atm/common.c b/net/atm/common.c
index 0c0ad93..f0a9b7e 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -520,6 +520,8 @@ int vcc_recvmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 	struct sk_buff *skb;
 	int copied, error = -EINVAL;
 
+	msg->msg_namelen = 0;
+
 	if (sock->state != SS_CONNECTED)
 		return -ENOTCONN;
 
-- 
1.8.1.2

