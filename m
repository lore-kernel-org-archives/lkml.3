Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbaELB4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:56:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34681 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbaELBnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:06 -0400
Message-Id: <20140512003203.668707502@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andreas Henriksson <andreas@fatal.se>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 073/143] net: Fix "ip rule delete table 256"
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Henriksson <andreas@fatal.se>

[ Upstream commit 13eb2ab2d33c57ebddc57437a7d341995fc9138c ]

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/fib_rules.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index bd30938..de9eac9 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -381,7 +381,8 @@ static int fib_nl_delrule(struct sk_buff *skb, struct nlmsghdr* nlh, void *arg)
 		if (frh->action && (frh->action != rule->action))
 			continue;
 
-		if (frh->table && (frh_get_table(frh, tb) != rule->table))
+		if (frh_get_table(frh, tb) &&
+		    (frh_get_table(frh, tb) != rule->table))
 			continue;
 
 		if (tb[FRA_PRIORITY] &&
-- 
1.7.12.2.21.g234cd45.dirty



