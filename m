Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab3L2C5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:57:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55071 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183Ab3L2CJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Stancek" <jstancek@redhat.com>,
        "Veaceslav Falico" <vfalico@redhat.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Daniel Borkmann" <dborkman@redhat.com>, "Phil Sutter" <phil@nwl.cc>,
        "David S. Miller" <davem@davemloft.net>,
        "Willem de Bruijn" <willemb@google.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.611233044@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 168/185] af_packet: block BH in prb_shutdown_retire_blk_timer()
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit ec6f809ff6f19fafba3212f6aff0dda71dfac8e8 ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/packet/af_packet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 7616c58..4f19bf2 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -505,9 +505,9 @@ static void prb_shutdown_retire_blk_timer(struct packet_sock *po,
 
 	pkc = tx_ring ? &po->tx_ring.prb_bdqc : &po->rx_ring.prb_bdqc;
 
-	spin_lock(&rb_queue->lock);
+	spin_lock_bh(&rb_queue->lock);
 	pkc->delete_blk_timer = 1;
-	spin_unlock(&rb_queue->lock);
+	spin_unlock_bh(&rb_queue->lock);
 
 	prb_del_retire_blk_timer(pkc);
 }

