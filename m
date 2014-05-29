Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123AbaE2OFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:05:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59421 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933304AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        Chris Mason <clm@fb.com>, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 076/103] ipv6: fib: fix fib dump restart
Date: Thu, 29 May 2014 15:49:01 +0200
Message-Id: <f0b511cae2f0545e88ecd5cc7fcd0f9d7dac96c6.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Sundararajan <kumar@fb.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 1c2658545816088477e91860c3a645053719cb54 ]

When the ipv6 fib changes during a table dump, the walk is
restarted and the number of nodes dumped are skipped. But the existing
code doesn't advance to the next node after a node is skipped. This can
cause the dump to loop or produce lots of duplicates when the fib
is modified during the dump.

This change advances the walk to the next node if the current node is
skipped after a restart.

Signed-off-by: Kumar Sundararajan <kumar@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/ip6_fib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 5bec666aba61..5e30677953d7 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1418,7 +1418,7 @@ static int fib6_walk_continue(struct fib6_walker_t *w)
 
 				if (w->skip) {
 					w->skip--;
-					continue;
+					goto skip;
 				}
 
 				err = w->func(w);
@@ -1428,6 +1428,7 @@ static int fib6_walk_continue(struct fib6_walker_t *w)
 				w->count++;
 				continue;
 			}
+skip:
 			w->state = FWS_U;
 		case FWS_U:
 			if (fn == w->root)
-- 
1.9.3

