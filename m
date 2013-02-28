Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab3B1Oxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:53:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42563 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156Ab3B1OvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 132/139] sock_diag: Fix out-of-bounds access to sock_diag_handlers[]
Date: Thu, 28 Feb 2013 14:44:42 +0000
Message-Id: <1362062689-2567-133-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 6e601a53566d84e1ffd25e7b6fe0b6894ffd79c0 upstream.

Userland can send a netlink message requesting SOCK_DIAG_BY_FAMILY
with a family greater or equal then AF_MAX -- the array size of
sock_diag_handlers[]. The current code does not test for this
condition therefore is vulnerable to an out-of-bound access opening
doors for a privilege escalation.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/sock_diag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index 5fd1467..964a92c 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -126,6 +126,9 @@ static int __sock_diag_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if (nlmsg_len(nlh) < sizeof(*req))
 		return -EINVAL;
 
+	if (req->sdiag_family >= AF_MAX)
+		return -EINVAL;
+
 	hndl = sock_diag_lock_handler(req->sdiag_family);
 	if (hndl == NULL)
 		err = -ENOENT;
-- 
1.8.1.2

