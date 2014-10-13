Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaJMC3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:29:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaJMC3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:29:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 31/55] ip_tunnel: Dont allow to add the same tunnel multiple times.
Date: Mon, 13 Oct 2014 04:24:45 +0200
Message-Id: <20141013022445.098993474@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit d61746b2e71bf612fb397b00242de5df5ba7f29a ]

When we try to add an already existing tunnel, we don't return
an error. Instead we continue and call ip_tunnel_update().
This means that we can change existing tunnels by adding
the same tunnel multiple times. It is even possible to change
the tunnel endpoints of the fallback device.

We fix this by returning an error if we try to add an existing
tunnel.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -764,9 +764,14 @@ int ip_tunnel_ioctl(struct net_device *d
 
 		t = ip_tunnel_find(itn, p, itn->fb_tunnel_dev->type);
 
-		if (!t && (cmd == SIOCADDTUNNEL)) {
-			t = ip_tunnel_create(net, itn, p);
-			err = PTR_ERR_OR_ZERO(t);
+		if (cmd == SIOCADDTUNNEL) {
+			if (!t) {
+				t = ip_tunnel_create(net, itn, p);
+				err = PTR_ERR_OR_ZERO(t);
+				break;
+			}
+
+			err = -EEXIST;
 			break;
 		}
 		if (dev != itn->fb_tunnel_dev && cmd == SIOCCHGTUNNEL) {


