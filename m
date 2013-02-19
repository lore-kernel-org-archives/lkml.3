Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab3BSS6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:58:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54501 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441Ab3BSSy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:54:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 68/81] tcp: fix for zero packets_in_flight was too broad
Date: Tue, 19 Feb 2013 15:49:31 -0300
Message-Id: <1361299784-8830-69-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>

commit 6731d2095bd4aef18027c72ef845ab1087c3ba63 upstream.

There are transients during normal FRTO procedure during which
the packets_in_flight can go to zero between write_queue state
updates and firing the resulting segments out. As FRTO processing
occurs during that window the check must be more precise to
not match "spuriously" :-). More specificly, e.g., when
packets_in_flight is zero but FLAG_DATA_ACKED is true the problematic
branch that set cwnd into zero would not be taken and new segments
might be sent out later.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Tested-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/tcp_input.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6affa92..3b14d81 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3695,8 +3695,7 @@ static bool tcp_process_frto(struct sock *sk, int flag)
 	    ((tp->frto_counter >= 2) && (flag & FLAG_RETRANS_DATA_ACKED)))
 		tp->undo_marker = 0;
 
-	if (!before(tp->snd_una, tp->frto_highmark) ||
-	    !tcp_packets_in_flight(tp)) {
+	if (!before(tp->snd_una, tp->frto_highmark)) {
 		tcp_enter_frto_loss(sk, (tp->frto_counter == 1 ? 2 : 3), flag);
 		return true;
 	}
@@ -3716,6 +3715,11 @@ static bool tcp_process_frto(struct sock *sk, int flag)
 		}
 	} else {
 		if (!(flag & FLAG_DATA_ACKED) && (tp->frto_counter == 1)) {
+			if (!tcp_packets_in_flight(tp)) {
+				tcp_enter_frto_loss(sk, 2, flag);
+				return true;
+			}
+
 			/* Prevent sending of new data. */
 			tp->snd_cwnd = min(tp->snd_cwnd,
 					   tcp_packets_in_flight(tp));
-- 
1.7.9.5

