Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3KAWH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:07:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3KAWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:07:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Veaceslav Falico <vfalico@redhat.com>
Subject: [PATCH 3.11 13/66] sit: amend "allow to use rtnl ops on fb tunnel"
Date: Fri,  1 Nov 2013 15:06:49 -0700
Message-Id: <20131101220638.466018482@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

Amend backport to 3.11.y of

 [ Upstream commit 205983c43700ac3a81e7625273a3fa83cd2759b5 ]

The discussion thread in the upstream commit mentions that in
backports to stable-* branches, the line

  - unregister_netdevice_queue(sitn->fb_tunnel_dev, &list);

must be omitted if that branch does not have commit 5e6700b3bf98
("sit: add support of x-netns"). This line has correctly been omitted
in the backport to 3.10, which indeed does not have that commit.

It was also removed in the backport to 3.11.y, which does have that
commit.

This causes the following steps to hit a BUG at net/core/dev.c:5039:

  `modprobe sit; rmmod sit`

The bug demonstrates that it causes a device to be unregistered twice.
The simple fix is to apply the one line in the upstream commit that
was dropped in the backport to 3.11 (3783100374653e2e7fbdf68c710f5).
This brings the logic in line with upstream linux, net and net-next
branches.

Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1708,7 +1708,6 @@ static void __net_exit sit_exit_net(stru
 
 	rtnl_lock();
 	sit_destroy_tunnels(sitn, &list);
-	unregister_netdevice_queue(sitn->fb_tunnel_dev, &list);
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
 }


