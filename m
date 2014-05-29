Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090AbaE2OBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:01:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59449 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933358AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 024/103] netfilter: Can't fail and free after table replacement
Date: Thu, 29 May 2014 15:48:09 +0200
Message-Id: <f34728610b2a8c7b9864f9404f2884c17f6fca5c.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bridge/netfilter/ebtables.c | 5 ++---
 net/ipv4/netfilter/arp_tables.c | 6 ++++--
 net/ipv4/netfilter/ip_tables.c  | 6 ++++--
 net/ipv6/netfilter/ip6_tables.c | 6 ++++--
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ac7802428384..b166fc2ec4b9 100644
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
index 85a4f21aac1a..c8abe31961ed 100644
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
index d23118d95ff9..651c10774d58 100644
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
index 44400c216dc6..89a4e4ddd8bb 100644
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
1.9.3

