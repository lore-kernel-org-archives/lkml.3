Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab3LFVwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:52:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab3LFVwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Willem de Bruijn <willemb@google.com>, Phil Sutter <phil@nwl.cc>,
        Eric Dumazet <edumazet@google.com>, Jan Stancek <jstancek@redhat.com>,
        Veaceslav Falico <vfalico@redhat.com>
Subject: [PATCH 3.12 45/83] af_packet: block BH in prb_shutdown_retire_blk_timer()
Date: Fri,  6 Dec 2013 13:51:35 -0800
Message-Id: <20131206214644.247675207@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -439,9 +439,9 @@ static void prb_shutdown_retire_blk_time
 
 	pkc = tx_ring ? &po->tx_ring.prb_bdqc : &po->rx_ring.prb_bdqc;
 
-	spin_lock(&rb_queue->lock);
+	spin_lock_bh(&rb_queue->lock);
 	pkc->delete_blk_timer = 1;
-	spin_unlock(&rb_queue->lock);
+	spin_unlock_bh(&rb_queue->lock);
 
 	prb_del_retire_blk_timer(pkc);
 }


