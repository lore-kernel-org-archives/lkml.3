Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaANAuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:50:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaANA2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 08/77] macvtap: Do not double-count received packets
Date: Mon, 13 Jan 2014 16:27:29 -0800
Message-Id: <20140114002752.738781371@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 006da7b07bc4d3a7ffabad17cf639eec6849c9dc ]

Currently macvlan will count received packets after calling each
vlans receive handler.   Macvtap attempts to count the packet
yet again when the user reads the packet from the tap socket.
This code doesn't do this consistently either.  Remove the
counting from macvtap and let only macvlan count received
packets.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvtap.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -767,7 +767,6 @@ static ssize_t macvtap_put_user(struct m
 				const struct sk_buff *skb,
 				const struct iovec *iv, int len)
 {
-	struct macvlan_dev *vlan;
 	int ret;
 	int vnet_hdr_len = 0;
 	int vlan_offset = 0;
@@ -821,15 +820,6 @@ static ssize_t macvtap_put_user(struct m
 	copied += len;
 
 done:
-	rcu_read_lock();
-	vlan = rcu_dereference(q->vlan);
-	if (vlan) {
-		preempt_disable();
-		macvlan_count_rx(vlan, copied - vnet_hdr_len, ret == 0, 0);
-		preempt_enable();
-	}
-	rcu_read_unlock();
-
 	return ret ? ret : copied;
 }
 


