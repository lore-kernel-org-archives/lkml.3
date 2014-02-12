Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaBLIgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:36:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50081 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbaBLINu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:50 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
        "Daniel Borkmann" <dborkman@redhat.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.24119970@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 13/79] net: llc: fix use after free in llc_ui_recvmsg
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/llc/af_llc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 99a60d5..f432d7b 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -715,7 +715,7 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct llc_sock *llc = llc_sk(sk);
 	size_t copied = 0;
 	u32 peek_seq = 0;
-	u32 *seq;
+	u32 *seq, skb_len;
 	unsigned long used;
 	int target;	/* Read at least this many bytes */
 	long timeo;
@@ -813,6 +813,7 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 		}
 		continue;
 	found_ok_skb:
+		skb_len = skb->len;
 		/* Ok so how much can we use? */
 		used = skb->len - offset;
 		if (len < used)
@@ -843,7 +844,7 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 		}
 
 		/* Partial read */
-		if (used + offset < skb->len)
+		if (used + offset < skb_len)
 			continue;
 	} while (len > 0);
 

