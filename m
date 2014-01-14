Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaANAvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:51:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaANA2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Vlad Yasevich <vyasevich@gmail.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 07/77] tun: unbreak truncated packet signalling
Date: Mon, 13 Jan 2014 16:27:28 -0800
Message-Id: <20140114002752.710463983@linuxfoundation.org>
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

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit e6fd07c899cd719bb5517bc7f32ce03a62220351 ]

Commit 6680ec68eff47d36f67b4351bc9836fd6cba9532
(tuntap: hardware vlan tx support) breaks the truncated packet signal by nev
return a length greater than iov length in tun_put_user(). This patch fixes
by always return the length of packet plus possible vlan header. Caller can
detect the truncated packet by comparing the return value and the size of io
length.

Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1184,7 +1184,7 @@ static ssize_t tun_put_user(struct tun_s
 {
 	struct tun_pi pi = { 0, skb->protocol };
 	ssize_t total = 0;
-	int vlan_offset = 0;
+	int vlan_offset = 0, copied;
 
 	if (!(tun->flags & TUN_NO_PI)) {
 		if ((len -= sizeof(pi)) < 0)
@@ -1248,6 +1248,8 @@ static ssize_t tun_put_user(struct tun_s
 		total += tun->vnet_hdr_sz;
 	}
 
+	copied = total;
+	total += skb->len;
 	if (!vlan_tx_tag_present(skb)) {
 		len = min_t(int, skb->len, len);
 	} else {
@@ -1262,24 +1264,24 @@ static ssize_t tun_put_user(struct tun_s
 
 		vlan_offset = offsetof(struct vlan_ethhdr, h_vlan_proto);
 		len = min_t(int, skb->len + VLAN_HLEN, len);
+		total += VLAN_HLEN;
 
 		copy = min_t(int, vlan_offset, len);
-		ret = skb_copy_datagram_const_iovec(skb, 0, iv, total, copy);
+		ret = skb_copy_datagram_const_iovec(skb, 0, iv, copied, copy);
 		len -= copy;
-		total += copy;
+		copied += copy;
 		if (ret || !len)
 			goto done;
 
 		copy = min_t(int, sizeof(veth), len);
-		ret = memcpy_toiovecend(iv, (void *)&veth, total, copy);
+		ret = memcpy_toiovecend(iv, (void *)&veth, copied, copy);
 		len -= copy;
-		total += copy;
+		copied += copy;
 		if (ret || !len)
 			goto done;
 	}
 
-	skb_copy_datagram_const_iovec(skb, vlan_offset, iv, total, len);
-	total += len;
+	skb_copy_datagram_const_iovec(skb, vlan_offset, iv, copied, len);
 
 done:
 	tun->dev->stats.tx_packets++;


