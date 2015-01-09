Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbbAIKi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:38:26 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44596 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757507AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 05/78] rtnetlink: release net refcnt on error in do_setlink()
Date: Fri,  9 Jan 2015 11:31:14 +0100
Message-Id: <6f6204584a51a9c36732d289cc037c256208b20e.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit e0ebde0e131b529fd721b24f62872def5ec3718c ]

rtnl_link_get_net() holds a reference on the 'struct net', we need to release
it in case of error.

CC: Eric W. Biederman <ebiederm@xmission.com>
Fixes: b51642f6d77b ("net: Enable a userns root rtnl calls that are safe for unprivilged users")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/rtnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 93ad6c5b2d77..f3224755b328 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1391,6 +1391,7 @@ static int do_setlink(const struct sk_buff *skb,
 			goto errout;
 		}
 		if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
+			put_net(net);
 			err = -EPERM;
 			goto errout;
 		}
-- 
2.2.1

