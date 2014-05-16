Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbaEPWxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:53:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbaEPWwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:52:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Thomas Graf <tgraf@suug.ch>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.4 6/9] netfilter: Cant fail and free after table replacement
Date: Fri, 16 May 2014 15:55:29 -0700
Message-Id: <20140516225458.834116074@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140516225458.512693003@linuxfoundation.org>
References: <20140516225458.512693003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bridge/netfilter/ebtables.c |    5 ++---
 net/ipv4/netfilter/arp_tables.c |    6 ++++--
 net/ipv4/netfilter/ip_tables.c  |    6 ++++--
 net/ipv6/netfilter/ip6_tables.c |    6 ++++--
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
@@ -1236,8 +1236,10 @@ __do_replace(struct net *net, const char
 
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


