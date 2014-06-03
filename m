Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbaFCLux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:50:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbaFCLmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kumar Sundararajan <kumar@fb.com>, Chris Mason <clm@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 113/138] ipv6: fib: fix fib dump restart
Date: Tue,  3 Jun 2014 12:39:19 +0100
Message-Id: <1401795584-22664-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Sundararajan <kumar@fb.com>

commit 1c2658545816088477e91860c3a645053719cb54 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_fib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 7fa5cb609e7b..64c99f8d62ac 100644
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
1.9.1

