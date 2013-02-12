Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3BLUfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:35:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3BLUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ketan Kulkarni <ketkulka@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Jerry Chu <hkchu@google.com>,
        Yuchung Cheng <ycheng@google.com>, Dave Taht <dave.taht@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 20/61] tcp: fix a panic on UP machines in reqsk_fastopen_remove
Date: Tue, 12 Feb 2013 12:34:40 -0800
Message-Id: <20130212203421.130195025@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cce894bb824429fd312706c7012acae43e725865 ]

spin_is_locked() on a non !SMP build is kind of useless.

BUG_ON(!spin_is_locked(xx)) is guaranteed to crash.

Just remove this check in reqsk_fastopen_remove() as
the callers do hold the socket lock.

Reported-by: Ketan Kulkarni <ketkulka@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jerry Chu <hkchu@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Dave Taht <dave.taht@gmail.com>
Acked-by: H.K. Jerry Chu <hkchu@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/request_sock.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/core/request_sock.c
+++ b/net/core/request_sock.c
@@ -186,8 +186,6 @@ void reqsk_fastopen_remove(struct sock *
 	struct fastopen_queue *fastopenq =
 	    inet_csk(lsk)->icsk_accept_queue.fastopenq;
 
-	BUG_ON(!spin_is_locked(&sk->sk_lock.slock) && !sock_owned_by_user(sk));
-
 	tcp_sk(sk)->fastopen_rsk = NULL;
 	spin_lock_bh(&fastopenq->lock);
 	fastopenq->qlen--;


