Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaLEXxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:53:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaLEWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Panu Matilainen <pmatilai@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 021/122] ipv4: Fix incorrect error code when adding an unreachable route
Date: Fri,  5 Dec 2014 14:43:15 -0800
Message-Id: <20141205223308.610164464@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_rules.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -62,6 +62,10 @@ int __fib_lookup(struct net *net, struct
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


