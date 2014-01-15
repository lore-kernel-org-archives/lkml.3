Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaAOVy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:54:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40789 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaAOVyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:22 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 164/166] net: llc: fix use after free in llc_ui_recvmsg
Date: Wed, 15 Jan 2014 13:52:58 -0800
Message-Id: <1389822780-4729-165-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 4d231b76eef6c4a6bd9c96769e191517765942cb ]

While commit 30a584d944fb fixes datagram interface in LLC, a use
after free bug has been introduced for SOCK_STREAM sockets that do
not make use of MSG_PEEK.

The flow is as follow ...

  if (!(flags & MSG_PEEK)) {
    ...
    sk_eat_skb(sk, skb, false);
    ...
  }
  ...
  if (used + offset < skb->len)
    continue;

... where sk_eat_skb() calls __kfree_skb(). Therefore, cache
original length and work on skb_len to check partial reads.

Fixes: 30a584d944fb ("[LLX]: SOCK_DGRAM interface fixes")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/llc/af_llc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 8870988..c3ee805 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -715,7 +715,7 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 	unsigned long cpu_flags;
 	size_t copied = 0;
 	u32 peek_seq = 0;
-	u32 *seq;
+	u32 *seq, skb_len;
 	unsigned long used;
 	int target;	/* Read at least this many bytes */
 	long timeo;
@@ -812,6 +812,7 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 		}
 		continue;
 	found_ok_skb:
+		skb_len = skb->len;
 		/* Ok so how much can we use? */
 		used = skb->len - offset;
 		if (len < used)
@@ -844,7 +845,7 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 		}
 
 		/* Partial read */
-		if (used + offset < skb->len)
+		if (used + offset < skb_len)
 			continue;
 	} while (len > 0);
 
-- 
1.8.3.2

