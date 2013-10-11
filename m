Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab3JKUQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:16:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab3JKTk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 013/135] net: fix multiqueue selection
Date: Fri, 11 Oct 2013 12:38:14 -0700
Message-Id: <20131011193946.684090274@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 50d1784ee4683f073c0362ee360bfae7a3333d6c ]

commit 416186fbf8c5b4e4465 ("net: Split core bits of netdev_pick_tx
into __netdev_pick_tx") added a bug that disables caching of queue
index in the socket.

This is the source of packet reorders for TCP flows, and
again this is happening more often when using FQ pacing.

Old code was doing

if (queue_index != old_index)
	sk_tx_queue_set(sk, queue_index);

Alexander renamed the variables but forgot to change sk_tx_queue_set()
2nd parameter.

if (queue_index != new_index)
	sk_tx_queue_set(sk, queue_index);

This means we store -1 over and over in sk->sk_tx_queue_mapping

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Acked-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/flow_dissector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -348,7 +348,7 @@ u16 __netdev_pick_tx(struct net_device *
 
 		if (queue_index != new_index && sk &&
 		    rcu_access_pointer(sk->sk_dst_cache))
-			sk_tx_queue_set(sk, queue_index);
+			sk_tx_queue_set(sk, new_index);
 
 		queue_index = new_index;
 	}


