Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbaBEVMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:12:25 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47942 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbaBEUDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 031/213] atm: update msg_namelen in vcc_recvmsg()
Date: Wed, 5 Feb 2014 14:59:46 -0500
Message-ID: <1391630568-49251-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9b3e617f3df53822345a8573b6d358f6b9e5ed87 upstream.

The current code does not fill the msg_name member in case it is set.
It also does not set the msg_namelen member to 0 and therefore makes
net/socket.c leak the local, uninitialized sockaddr_storage variable
to userland -- 128 bytes of kernel stack memory.

Fix that by simply setting msg_namelen to 0 as obviously nobody cared
about vcc_recvmsg() not filling the msg_name in case it was set.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/atm/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/atm/common.c b/net/atm/common.c
index ec2cb8f3c8d9..4ccc872209f0 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -475,6 +475,8 @@ int vcc_recvmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 	struct sk_buff *skb;
 	int copied, error = -EINVAL;
 
+	msg->msg_namelen = 0;
+
 	if (sock->state != SS_CONNECTED)
 		return -ENOTCONN;
 	if (flags & ~MSG_DONTWAIT)		/* only handle MSG_DONTWAIT */
-- 
1.8.5.2

