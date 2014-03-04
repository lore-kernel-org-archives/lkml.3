Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbaCDVcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:32:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbaCDUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Steinar H. Gunderson" <sesse@samfundet.no>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 049/172] gre: add link local route when local addr is any
Date: Tue,  4 Mar 2014 12:02:13 -0800
Message-Id: <20140304200301.302930455@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 08b44656c08c8c2f73cdac2a058be2880e3361f2 ]

This bug was reported by Steinar H. Gunderson and was introduced by commit
f7cb8886335d ("sit/gre6: don't try to add the same route two times").

root@morgental:~# ip tunnel add foo mode gre remote 1.2.3.4 ttl 64
root@morgental:~# ip link set foo up mtu 1468
root@morgental:~# ip -6 route show dev foo
fe80::/64  proto kernel  metric 256

but after the above commit, no such route shows up.

There is no link local route because dev->dev_addr is 0 (because local ipv4
address is 0), hence no link local address is configured.

In this scenario, the link local address is added manually: 'ip -6 addr add
fe80::1 dev foo' and because prefix is /128, no link local route is added by the
kernel.

Even if the right things to do is to add the link local address with a /64
prefix, we need to restore the previous behavior to avoid breaking userpace.

Reported-by: Steinar H. Gunderson <sesse@samfundet.no>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2726,6 +2726,8 @@ static void addrconf_gre_config(struct n
 	ipv6_addr_set(&addr,  htonl(0xFE800000), 0, 0, 0);
 	if (!ipv6_generate_eui64(addr.s6_addr + 8, dev))
 		addrconf_add_linklocal(idev, &addr);
+	else
+		addrconf_prefix_route(&addr, 64, dev, 0, 0);
 }
 #endif
 


