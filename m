Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaHTMDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:03:10 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58945 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Christoph Paasch <christoph.paasch@uclouvain.be>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Doug Leith <doug.leith@nuim.ie>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 037/104] tcp: Fix integer-overflow in TCP vegas
Date: Wed, 20 Aug 2014 13:43:00 +0200
Message-Id: <3ef99737f145fce80734b1e868b77422676489d7.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Paasch <christoph.paasch@uclouvain.be>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 1f74e613ded11517db90b2bd57e9464d9e0fb161 ]

In vegas we do a multiplication of the cwnd and the rtt. This
may overflow and thus their result is stored in a u64. However, we first
need to cast the cwnd so that actually 64-bit arithmetic is done.

Then, we need to do do_div to allow this to be used on 32-bit arches.

Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Doug Leith <doug.leith@nuim.ie>
Fixes: 8d3a564da34e (tcp: tcp_vegas cong avoid fix)
Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/tcp_vegas.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_vegas.c b/net/ipv4/tcp_vegas.c
index 80fa2bfd7ede..c042e529a11e 100644
--- a/net/ipv4/tcp_vegas.c
+++ b/net/ipv4/tcp_vegas.c
@@ -218,7 +218,8 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 in_flight)
 			 * This is:
 			 *     (actual rate in segments) * baseRTT
 			 */
-			target_cwnd = tp->snd_cwnd * vegas->baseRTT / rtt;
+			target_cwnd = (u64)tp->snd_cwnd * vegas->baseRTT;
+			do_div(target_cwnd, rtt);
 
 			/* Calculate the difference between the window we had,
 			 * and the window we would like to have. This quantity
-- 
2.0.4

