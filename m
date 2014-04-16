Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaDPKdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:33:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbaDPKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:33:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, Thomas Graf <tgraf@suug.ch>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 45/46] netfilter: Can't fail and free after table replacement
Date: Wed, 16 Apr 2014 11:32:01 +0100
Message-Id: <1397644322-13905-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

commit c58dd2dd443c26d856a168db108a0cd11c285bf3 upstream.

All xtables variants suffer from the defect that the copy_to_user()
to copy the counters to user memory may fail after the table has
already been exchanged and thus exposed. Return an error at this
point will result in freeing the already exposed table. Any
subsequent packet processing will result in a kernel panic.

We can't copy the counters before exposing the new tables as we
want provide the counter state after the old table has been
unhooked. Therefore convert this into a silent error.

Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bridge/netfilter/ebtables.c | 5 ++---
 net/ipv4/netfilter/arp_tables.c | 6 ++++--
 net/ipv4/netfilter/ip_tables.c  | 6 ++++--
 net/ipv6/netfilter/ip6_tables.c | 6 ++++--
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ac78024..b166fc2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1044,10 +1044,9 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	if (repl->num_counters &&
 	   copy_to_user(repl->counters, counterstmp,
 	   repl->num_counters * sizeof(struct ebt_counter))) {
-		ret = -EFAULT;
+		/* Silent error, can't fail, new table is already in place */
+		net_warn_ratelimited("ebtables: counters copy to user failed while replacing table\n");
 	}
-	else
-		ret = 0;
 
 	/* decrease module count and free resources */
 	EBT_ENTRY_ITERATE(table->entries, table->entries_size,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 85a4f21..c8abe31 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1039,8 +1039,10 @@ static int __do_replace(struct net *net, const char *name,
 
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
-			 sizeof(struct xt_counters) * num_counters) != 0)
-		ret = -EFAULT;
+			 sizeof(struct xt_counters) * num_counters) != 0) {
+		/* Silent error, can't fail, new table is already in place */
+		net_warn_ratelimited("arptables: counters copy to user failed while replacing table\n");
+	}
 	vfree(counters);
 	xt_table_unlock(t);
 	return ret;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index d23118d..651c107 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1226,8 +1226,10 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
-			 sizeof(struct xt_counters) * num_counters) != 0)
-		ret = -EFAULT;
+			 sizeof(struct xt_counters) * num_counters) != 0) {
+		/* Silent error, can't fail, new table is already in place */
+		net_warn_ratelimited("iptables: counters copy to user failed while replacing table\n");
+	}
 	vfree(counters);
 	xt_table_unlock(t);
 	return ret;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 44400c2..89a4e4d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1236,8 +1236,10 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
-			 sizeof(struct xt_counters) * num_counters) != 0)
-		ret = -EFAULT;
+			 sizeof(struct xt_counters) * num_counters) != 0) {
+		/* Silent error, can't fail, new table is already in place */
+		net_warn_ratelimited("ip6tables: counters copy to user failed while replacing table\n");
+	}
 	vfree(counters);
 	xt_table_unlock(t);
 	return ret;
-- 
1.9.1

