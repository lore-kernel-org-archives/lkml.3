Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab3BLU5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:57:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab3BLUgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Ilpo=20J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 55/61] tcp: fix for zero packets_in_flight was too broad
Date: Tue, 12 Feb 2013 12:35:15 -0800
Message-Id: <20130212203425.293033672@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>

[ Upstream commit 6731d2095bd4aef18027c72ef845ab1087c3ba63 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3484,8 +3484,7 @@ static bool tcp_process_frto(struct sock
 	    ((tp->frto_counter >= 2) && (flag & FLAG_RETRANS_DATA_ACKED)))
 		tp->undo_marker = 0;
 
-	if (!before(tp->snd_una, tp->frto_highmark) ||
-	    !tcp_packets_in_flight(tp)) {
+	if (!before(tp->snd_una, tp->frto_highmark)) {
 		tcp_enter_frto_loss(sk, (tp->frto_counter == 1 ? 2 : 3), flag);
 		return true;
 	}
@@ -3505,6 +3504,11 @@ static bool tcp_process_frto(struct sock
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


