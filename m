Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaANBD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:03:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaANA1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 34/62] net: llc: fix use after free in llc_ui_recvmsg
Date: Mon, 13 Jan 2014 16:26:59 -0800
Message-Id: <20140114002711.434616897@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/af_llc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -715,7 +715,7 @@ static int llc_ui_recvmsg(struct kiocb *
 	unsigned long cpu_flags;
 	size_t copied = 0;
 	u32 peek_seq = 0;
-	u32 *seq;
+	u32 *seq, skb_len;
 	unsigned long used;
 	int target;	/* Read at least this many bytes */
 	long timeo;
@@ -812,6 +812,7 @@ static int llc_ui_recvmsg(struct kiocb *
 		}
 		continue;
 	found_ok_skb:
+		skb_len = skb->len;
 		/* Ok so how much can we use? */
 		used = skb->len - offset;
 		if (len < used)
@@ -844,7 +845,7 @@ static int llc_ui_recvmsg(struct kiocb *
 		}
 
 		/* Partial read */
-		if (used + offset < skb->len)
+		if (used + offset < skb_len)
 			continue;
 	} while (len > 0);
 


