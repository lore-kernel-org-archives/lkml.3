Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaLOO1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:27:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38159 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaLOO1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Panu Matilainen <pmatilai@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 004/168] ipv4: Fix incorrect error code when adding an unreachable route
Date: Mon, 15 Dec 2014 14:24:18 +0000
Message-Id: <1418653622-21105-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Panu Matilainen <pmatilai@redhat.com>

commit 49dd18ba4615eaa72f15c9087dea1c2ab4744cf5 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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

