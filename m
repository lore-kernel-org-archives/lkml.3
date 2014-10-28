Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaJ1Dk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:40:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbaJ1DkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:40:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.17 104/146] Bluetooth: 6lowpan: Set the peer IPv6 address correctly
Date: Tue, 28 Oct 2014 11:34:06 +0800
Message-Id: <20141028033347.970555894@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jukka Rissanen <jukka.rissanen@linux.intel.com>

commit b2799cec22812f5f1aaaa57133df51876f685d84 upstream.

The peer IPv6 address contained wrong U/L bit in the EUI-64 part.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/6lowpan.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -671,6 +671,14 @@ static struct l2cap_chan *chan_open(stru
 	return chan;
 }
 
+static void set_ip_addr_bits(u8 addr_type, u8 *addr)
+{
+	if (addr_type == BDADDR_LE_PUBLIC)
+		*addr |= 0x02;
+	else
+		*addr &= ~0x02;
+}
+
 static struct l2cap_chan *add_peer_chan(struct l2cap_chan *chan,
 					struct lowpan_dev *dev)
 {
@@ -693,6 +701,11 @@ static struct l2cap_chan *add_peer_chan(
 	memcpy(&peer->eui64_addr, (u8 *)&peer->peer_addr.s6_addr + 8,
 	       EUI64_ADDR_LEN);
 
+	/* IPv6 address needs to have the U/L bit set properly so toggle
+	 * it back here.
+	 */
+	set_ip_addr_bits(chan->dst_type, (u8 *)&peer->peer_addr.s6_addr + 8);
+
 	write_lock_irqsave(&devices_lock, flags);
 	INIT_LIST_HEAD(&peer->list);
 	peer_add(dev, peer);


