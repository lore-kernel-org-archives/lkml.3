Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3LRVwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:52:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3LRVMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 3.10 73/78] [PATCH linux-3.10.y] ip6tnl: fix use after free of fb_tnl_dev
Date: Wed, 18 Dec 2013 13:11:41 -0800
Message-Id: <20131218211113.960240003@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------


The upstream commit bb8140947a24 ("ip6tnl: allow to use rtnl ops on fb tunnel")
(backported into linux-3.10.y) left a bug which was fixed upstream by commit
1e9f3d6f1c40 ("ip6tnl: fix use after free of fb_tnl_dev").

The problem is a bit different in linux-3.10.y, because there is no x-netns
support (upstream commit 0bd8762824e7 ("ip6tnl: add x-netns support")).
When ip6_tunnel.ko is unloaded, FB device is deleted by rtnl_link_unregister()
and then we try to delete it again in ip6_tnl_destroy_tunnels().

This patch removes the second deletion.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1711,8 +1711,6 @@ static void __net_exit ip6_tnl_destroy_t
 		}
 	}
 
-	t = rtnl_dereference(ip6n->tnls_wc[0]);
-	unregister_netdevice_queue(t->dev, &list);
 	unregister_netdevice_many(&list);
 }
 


