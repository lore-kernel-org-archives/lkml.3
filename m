Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab3LQSjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:39:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60830 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab3LQSOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Willem de Bruijn <willemb@google.com>, Phil Sutter <phil@nwl.cc>,
        Eric Dumazet <edumazet@google.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 023/103] af_packet: block BH in prb_shutdown_retire_blk_timer()
Date: Tue, 17 Dec 2013 18:12:12 +0000
Message-Id: <1387304012-23805-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

commit ec6f809ff6f19fafba3212f6aff0dda71dfac8e8 upstream.

Currently we're using plain spin_lock() in prb_shutdown_retire_blk_timer(),
however the timer might fire right in the middle and thus try to re-aquire
the same spinlock, leaving us in a endless loop.

To fix that, use the spin_lock_bh() to block it.

Fixes: f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer implementation.")
CC: "David S. Miller" <davem@davemloft.net>
CC: Daniel Borkmann <dborkman@redhat.com>
CC: Willem de Bruijn <willemb@google.com>
CC: Phil Sutter <phil@nwl.cc>
CC: Eric Dumazet <edumazet@google.com>
Reported-by: Jan Stancek <jstancek@redhat.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/packet/af_packet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c2a5a44..8be3ab6 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -504,9 +504,9 @@ static void prb_shutdown_retire_blk_timer(struct packet_sock *po,
 
 	pkc = tx_ring ? &po->tx_ring.prb_bdqc : &po->rx_ring.prb_bdqc;
 
-	spin_lock(&rb_queue->lock);
+	spin_lock_bh(&rb_queue->lock);
 	pkc->delete_blk_timer = 1;
-	spin_unlock(&rb_queue->lock);
+	spin_unlock_bh(&rb_queue->lock);
 
 	prb_del_retire_blk_timer(pkc);
 }
-- 
1.8.3.2

