Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbaE2Esh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:48:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbaE2Eij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Chris Mason <clm@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 58/86] ipv6: fib: fix fib dump restart
Date: Wed, 28 May 2014 21:37:33 -0700
Message-Id: <20140529043521.344415824@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1418,7 +1418,7 @@ static int fib6_walk_continue(struct fib
 
 				if (w->skip) {
 					w->skip--;
-					continue;
+					goto skip;
 				}
 
 				err = w->func(w);
@@ -1428,6 +1428,7 @@ static int fib6_walk_continue(struct fib
 				w->count++;
 				continue;
 			}
+skip:
 			w->state = FWS_U;
 		case FWS_U:
 			if (fn == w->root)


