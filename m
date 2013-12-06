Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161723Ab3LFWWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:22:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205Ab3LFVxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas HICHER <nhicher@avencall.com>,
        Andreas Henriksson <andreas@fatal.se>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 03/58] net: Fix "ip rule delete table 256"
Date: Fri,  6 Dec 2013 13:51:34 -0800
Message-Id: <20131206214845.235906311@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/fib_rules.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -445,7 +445,8 @@ static int fib_nl_delrule(struct sk_buff
 		if (frh->action && (frh->action != rule->action))
 			continue;
 
-		if (frh->table && (frh_get_table(frh, tb) != rule->table))
+		if (frh_get_table(frh, tb) &&
+		    (frh_get_table(frh, tb) != rule->table))
 			continue;
 
 		if (tb[FRA_PRIORITY] &&


