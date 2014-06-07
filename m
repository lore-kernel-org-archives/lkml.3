Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaFGBr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:47:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35940 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Florian Westphal" <fw@strlen.de>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Thomas Graf" <tgraf@suug.ch>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.588127546@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 05/92] netfilter: Can't fail and free after table
 replacement
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/netfilter/ebtables.c | 5 ++---
 net/ipv4/netfilter/arp_tables.c | 6 ++++--
 net/ipv4/netfilter/ip_tables.c  | 6 ++++--
 net/ipv6/netfilter/ip6_tables.c | 6 ++++--
 4 files changed, 14 insertions(+), 9 deletions(-)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1044,10 +1044,9 @@ static int do_replace_finish(struct net
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
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1039,8 +1039,10 @@ static int __do_replace(struct net *net,
 
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
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1227,8 +1227,10 @@ __do_replace(struct net *net, const char
 
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
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1249,8 +1249,10 @@ __do_replace(struct net *net, const char
 
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

