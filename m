Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaAMOgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:36:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51629 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaAMO1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:27:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 92/96] net: llc: fix use after free in llc_ui_recvmsg
Date: Mon, 13 Jan 2014 14:24:55 +0000
Message-Id: <1389623099-18783-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 4d231b76eef6c4a6bd9c96769e191517765942cb upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/llc/af_llc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index a13c3e2..1895833 100644
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

