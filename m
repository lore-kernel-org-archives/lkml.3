Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab3BLU5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:57:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3BLUgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Pasi=20K=E4rkk=E4inen?= <pasik@iki.fi>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?q?Ilpo=20J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 54/61] tcp: frto should not set snd_cwnd to 0
Date: Tue, 12 Feb 2013 12:35:14 -0800
Message-Id: <20130212203425.128284447@linuxfoundation.org>
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


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2e5f421211ff76c17130b4597bc06df4eeead24f ]

Commit 9dc274151a548 (tcp: fix ABC in tcp_slow_start())
uncovered a bug in FRTO code :
tcp_process_frto() is setting snd_cwnd to 0 if the number
of in flight packets is 0.

As Neal pointed out, if no packet is in flight we lost our
chance to disambiguate whether a loss timeout was spurious.

We should assume it was a proper loss.

Reported-by: Pasi Kärkkäinen <pasik@iki.fi>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Cc: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3484,7 +3484,8 @@ static bool tcp_process_frto(struct sock
 	    ((tp->frto_counter >= 2) && (flag & FLAG_RETRANS_DATA_ACKED)))
 		tp->undo_marker = 0;
 
-	if (!before(tp->snd_una, tp->frto_highmark)) {
+	if (!before(tp->snd_una, tp->frto_highmark) ||
+	    !tcp_packets_in_flight(tp)) {
 		tcp_enter_frto_loss(sk, (tp->frto_counter == 1 ? 2 : 3), flag);
 		return true;
 	}


