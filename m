Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaLNUYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:24:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaLNUWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:22:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Herbert <therbert@google.com>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 29/47] vxlan: Fix boolean flip in VXLAN_F_UDP_ZERO_CSUM6_[TX|RX]
Date: Sun, 14 Dec 2014 12:21:04 -0800
Message-Id: <20141214201819.627823584@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexander.h.duyck@redhat.com>

[ Upstream commit 3dc2b6a8d38cf6c7604ec25f3d50d6ec8da04435 ]

In "vxlan: Call udp_sock_create" there was a logic error that resulted in
the default for IPv6 VXLAN tunnels going from using checksums to not using
checksums.  Since there is currently no support in iproute2 for setting
these values it means that a kernel after the change cannot talk over a IPv6
VXLAN tunnel to a kernel prior the change.

Fixes: 3ee64f3 ("vxlan: Call udp_sock_create")

Cc: Tom Herbert <therbert@google.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@redhat.com>
Acked-by: Tom Herbert <therbert@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2362,9 +2362,9 @@ static struct socket *vxlan_create_sock(
 	if (ipv6) {
 		udp_conf.family = AF_INET6;
 		udp_conf.use_udp6_tx_checksums =
-		    !!(flags & VXLAN_F_UDP_ZERO_CSUM6_TX);
+		    !(flags & VXLAN_F_UDP_ZERO_CSUM6_TX);
 		udp_conf.use_udp6_rx_checksums =
-		    !!(flags & VXLAN_F_UDP_ZERO_CSUM6_RX);
+		    !(flags & VXLAN_F_UDP_ZERO_CSUM6_RX);
 	} else {
 		udp_conf.family = AF_INET;
 		udp_conf.local_ip.s_addr = INADDR_ANY;


