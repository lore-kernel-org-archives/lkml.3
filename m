Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaLCLh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:37:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaLCL1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:43 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Panu Matilainen <pmatilai@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 091/101] ipv4: Fix incorrect error code when adding an unreachable route
Date: Wed,  3 Dec 2014 12:26:53 +0100
Message-Id: <8cdc2cb0cfeeeac2fe600431fe7f41847c61f6f9.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Panu Matilainen <pmatilai@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 49dd18ba4615eaa72f15c9087dea1c2ab4744cf5 ]

Trying to add an unreachable route incorrectly returns -ESRCH if
if custom FIB rules are present:

[root@localhost ~]# ip route add 74.125.31.199 dev eth0 via 1.2.3.4
RTNETLINK answers: Network is unreachable
[root@localhost ~]# ip rule add to 55.66.77.88 table 200
[root@localhost ~]# ip route add 74.125.31.199 dev eth0 via 1.2.3.4
RTNETLINK answers: No such process
[root@localhost ~]#

Commit 83886b6b636173b206f475929e58fac75c6f2446 ("[NET]: Change "not found"
return value for rule lookup") changed fib_rules_lookup()
to use -ESRCH as a "not found" code internally, but for user space it
should be translated into -ENETUNREACH. Handle the translation centrally in
ipv4-specific fib_lookup(), leaving the DECnet case alone.

On a related note, commit b7a71b51ee37d919e4098cd961d59a883fd272d8
("ipv4: removed redundant conditional") removed a similar translation from
ip_route_input_slow() prematurely AIUI.

Fixes: b7a71b51ee37 ("ipv4: removed redundant conditional")
Signed-off-by: Panu Matilainen <pmatilai@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/fib_rules.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index f2e15738534d..8f7bd56955b0 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -62,6 +62,10 @@ int __fib_lookup(struct net *net, struct flowi4 *flp, struct fib_result *res)
 	else
 		res->tclassid = 0;
 #endif
+
+	if (err == -ESRCH)
+		err = -ENETUNREACH;
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(__fib_lookup);
-- 
2.1.3

