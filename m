Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423104Ab3BANQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:16:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:45887 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422651Ab3BANQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:16:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Feng Gao <gfree.wind@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 82/89] netfilter: xt_hashlimit: fix race that results in duplicated entries
Date: Fri,  1 Feb 2013 14:08:37 +0100
Message-Id: <20130201130213.388508268@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 09181842b000344b1205801df3aa5b726c03cc62 upstream.

Two packets may race to create the same entry in the hashtable,
double check if this packet lost race. This double checking only
happens in the path of the packet that creates the hashtable for
first time.

Note that, with this patch, no packet drops occur if the race happens.

Reported-by: Feng Gao <gfree.wind@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_hashlimit.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -157,11 +157,22 @@ dsthash_find(const struct xt_hashlimit_h
 /* allocate dsthash_ent, initialize dst, put in htable and lock it */
 static struct dsthash_ent *
 dsthash_alloc_init(struct xt_hashlimit_htable *ht,
-		   const struct dsthash_dst *dst)
+		   const struct dsthash_dst *dst, bool *race)
 {
 	struct dsthash_ent *ent;
 
 	spin_lock(&ht->lock);
+
+	/* Two or more packets may race to create the same entry in the
+	 * hashtable, double check if this packet lost race.
+	 */
+	ent = dsthash_find(ht, dst);
+	if (ent != NULL) {
+		spin_unlock(&ht->lock);
+		*race = true;
+		return ent;
+	}
+
 	/* initialize hash with random val at the time we allocate
 	 * the first hashtable entry */
 	if (unlikely(!ht->rnd_initialized)) {
@@ -588,6 +599,7 @@ hashlimit_mt(const struct sk_buff *skb,
 	unsigned long now = jiffies;
 	struct dsthash_ent *dh;
 	struct dsthash_dst dst;
+	bool race = false;
 	u32 cost;
 
 	if (hashlimit_init_dst(hinfo, &dst, skb, par->thoff) < 0)
@@ -596,13 +608,18 @@ hashlimit_mt(const struct sk_buff *skb,
 	rcu_read_lock_bh();
 	dh = dsthash_find(hinfo, &dst);
 	if (dh == NULL) {
-		dh = dsthash_alloc_init(hinfo, &dst);
+		dh = dsthash_alloc_init(hinfo, &dst, &race);
 		if (dh == NULL) {
 			rcu_read_unlock_bh();
 			goto hotdrop;
+		} else if (race) {
+			/* Already got an entry, update expiration timeout */
+			dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
+			rateinfo_recalc(dh, now, hinfo->cfg.mode);
+		} else {
+			dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
+			rateinfo_init(dh, hinfo);
 		}
-		dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
-		rateinfo_init(dh, hinfo);
 	} else {
 		/* update expiration timeout */
 		dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);


