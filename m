Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3LQSN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:13:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3LQSNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:13:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Henriksson <andreas@fatal.se>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 002/103] net: Fix "ip rule delete table 256"
Date: Tue, 17 Dec 2013 18:11:51 +0000
Message-Id: <1387304012-23805-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Henriksson <andreas@fatal.se>

commit 13eb2ab2d33c57ebddc57437a7d341995fc9138c upstream.

When trying to delete a table >= 256 using iproute2 the local table
will be deleted.
The table id is specified as a netlink attribute when it needs more then
8 bits and iproute2 then sets the table field to RT_TABLE_UNSPEC (0).
Preconditions to matching the table id in the rule delete code
doesn't seem to take the "table id in netlink attribute" into condition
so the frh_get_table helper function never gets to do its job when
matching against current rule.
Use the helper function twice instead of peaking at the table value directly.

Originally reported at: http://bugs.debian.org/724783

Reported-by: Nicolas HICHER <nhicher@avencall.com>
Signed-off-by: Andreas Henriksson <andreas@fatal.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/fib_rules.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 72cceb7..d660ad4 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -443,7 +443,8 @@ static int fib_nl_delrule(struct sk_buff *skb, struct nlmsghdr* nlh, void *arg)
 		if (frh->action && (frh->action != rule->action))
 			continue;
 
-		if (frh->table && (frh_get_table(frh, tb) != rule->table))
+		if (frh_get_table(frh, tb) &&
+		    (frh_get_table(frh, tb) != rule->table))
 			continue;
 
 		if (tb[FRA_PRIORITY] &&
-- 
1.8.3.2

