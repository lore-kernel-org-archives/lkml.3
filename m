Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaABRFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:05:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40167 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaABRF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:05:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Henriksson <andreas@fatal.se>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 03/91] net: Fix "ip rule delete table 256"
Date: Thu,  2 Jan 2014 09:03:38 -0800
Message-Id: <1388682306-30859-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/fib_rules.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 58a4ba2..8c9b04b 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -445,7 +445,8 @@ static int fib_nl_delrule(struct sk_buff *skb, struct nlmsghdr* nlh, void *arg)
 		if (frh->action && (frh->action != rule->action))
 			continue;
 
-		if (frh->table && (frh_get_table(frh, tb) != rule->table))
+		if (frh_get_table(frh, tb) &&
+		    (frh_get_table(frh, tb) != rule->table))
 			continue;
 
 		if (tb[FRA_PRIORITY] &&
-- 
1.8.3.2

