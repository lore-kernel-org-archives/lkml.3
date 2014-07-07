Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaGHAuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:50:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaGGXyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.15 115/122] netfilter: ctnetlink: fix dumping of dying/unconfirmed conntracks
Date: Mon,  7 Jul 2014 16:57:57 -0700
Message-Id: <20140707235737.686700808@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 266155b2de8fb721ae353688529b2f8bcdde2f90 upstream.

The dumping prematurely stops, it seems the callback argument that
indicates that all entries have been dumped is set after iterating
on the first cpu list. The dumping also may stop before the entire
per-cpu list content is also dumped.

With this patch, conntrack -L dying now shows the dying list content
again.

Fixes: b7779d06 ("netfilter: conntrack: spinlock per cpu to protect special lists.")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_netlink.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1163,9 +1163,6 @@ ctnetlink_dump_list(struct sk_buff *skb,
 	if (cb->args[2])
 		return 0;
 
-	if (cb->args[0] == nr_cpu_ids)
-		return 0;
-
 	for (cpu = cb->args[0]; cpu < nr_cpu_ids; cpu++) {
 		struct ct_pcpu *pcpu;
 
@@ -1194,6 +1191,7 @@ restart:
 			rcu_read_unlock();
 			if (res < 0) {
 				nf_conntrack_get(&ct->ct_general);
+				cb->args[0] = cpu;
 				cb->args[1] = (unsigned long)ct;
 				spin_unlock_bh(&pcpu->lock);
 				goto out;
@@ -1202,10 +1200,10 @@ restart:
 		if (cb->args[1]) {
 			cb->args[1] = 0;
 			goto restart;
-		} else
-			cb->args[2] = 1;
+		}
 		spin_unlock_bh(&pcpu->lock);
 	}
+	cb->args[2] = 1;
 out:
 	if (last)
 		nf_ct_put(last);


