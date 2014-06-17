Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbaFQQ11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:27:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51102 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823AbaFQQ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:27:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kumar Sundararajan <kumar@fb.com>, Chris Mason <clm@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 063/121] ipv6: fib: fix fib dump restart
Date: Tue, 17 Jun 2014 09:17:21 -0700
Message-Id: <1403021899-16708-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Sundararajan <kumar@fb.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_fib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index b3adb7f..e85fdd7 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1420,7 +1420,7 @@ static int fib6_walk_continue(struct fib6_walker_t *w)
 
 				if (w->skip) {
 					w->skip--;
-					continue;
+					goto skip;
 				}
 
 				err = w->func(w);
@@ -1430,6 +1430,7 @@ static int fib6_walk_continue(struct fib6_walker_t *w)
 				w->count++;
 				continue;
 			}
+skip:
 			w->state = FWS_U;
 		case FWS_U:
 			if (fn == w->root)
-- 
1.9.1

