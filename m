Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaLOT3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:29:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40720 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaLOT25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:28:57 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Panu Matilainen <pmatilai@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 30/96] ipv4: Fix incorrect error code when adding an unreachable route
Date: Mon, 15 Dec 2014 11:25:50 -0800
Message-Id: <1418671616-25482-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Panu Matilainen <pmatilai@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/fib_rules.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index f2e1573..8f7bd56 100644
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
1.9.1

