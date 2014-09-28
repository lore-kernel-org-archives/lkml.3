Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaI1OFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 10:05:51 -0400
Received: from domu-toccata.ens-lyon.fr ([140.77.166.138]:39589 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbaI1OFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 10:05:49 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2014 10:05:48 EDT
Date: Sun, 28 Sep 2014 15:55:45 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] Fix getsockopt(SO_PEERNAME) buffer size against potential
 future buffer overflow
Message-ID: <20140928135545.GA23220@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In net/core/sock.c's sock_getsockopt, the address buffer size is
hardcoded to 128. It happens that sizeof(struct sockaddr_storage) is
indeed 128, but that is just luck and would probably not get updated
whenever sockaddr_storage would grow. This patch makes it simply use
sockaddr_storage instead.

Signed-off-by:  Samuel Thibault <samuel.thibault@ens-lyon.org>

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1155,13 +1155,13 @@ int sock_getsockopt(struct socket *sock,
 
 	case SO_PEERNAME:
 	{
-		char address[128];
+		struct sockaddr_storage address;
 
-		if (sock->ops->getname(sock, (struct sockaddr *)address, &lv, 2))
+		if (sock->ops->getname(sock, (struct sockaddr *)&address, &lv, 2))
 			return -ENOTCONN;
 		if (lv < len)
 			return -EINVAL;
-		if (copy_to_user(optval, address, len))
+		if (copy_to_user(optval, &address, len))
 			return -EFAULT;
 		goto lenout;
 	}
