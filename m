Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaIKNEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:04:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754476AbaIKNEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Christian Evans" <frodox@zoho.com>,
        "Paul Moore" <pmoore@redhat.com>,
        "Casey Schaufler" <casey@schaufler-ca.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.168640272@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 044/131] netlabel: fix a problem when setting bits
 below the previously lowest bit
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit 41c3bd2039e0d7b3dc32313141773f20716ec524 upstream.

The NetLabel category (catmap) functions have a problem in that they
assume categories will be set in an increasing manner, e.g. the next
category set will always be larger than the last.  Unfortunately, this
is not a valid assumption and could result in problems when attempting
to set categories less than the startbit in the lowest catmap node.
In some cases kernel panics and other nasties can result.

This patch corrects the problem by checking for this and allocating a
new catmap node instance and placing it at the front of the list.

Reported-by: Christian Evans <frodox@zoho.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Tested-by: Casey Schaufler <casey@schaufler-ca.com>
[bwh: Backported to 3.2: adjust filename for SMACK]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/netlabel.h       |  8 ++++----
 net/ipv4/cipso_ipv4.c        |  6 +++---
 net/netlabel/netlabel_kapi.c | 26 ++++++++++++++++++--------
 security/smack/smack_lsm.c   |  2 +-
 4 files changed, 26 insertions(+), 16 deletions(-)

--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -395,10 +395,10 @@ int netlbl_secattr_catmap_walk(struct ne
 			       u32 offset);
 int netlbl_secattr_catmap_walk_rng(struct netlbl_lsm_secattr_catmap *catmap,
 				   u32 offset);
-int netlbl_secattr_catmap_setbit(struct netlbl_lsm_secattr_catmap *catmap,
+int netlbl_secattr_catmap_setbit(struct netlbl_lsm_secattr_catmap **catmap,
 				 u32 bit,
 				 gfp_t flags);
-int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap *catmap,
+int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap **catmap,
 				 u32 start,
 				 u32 end,
 				 gfp_t flags);
@@ -506,14 +506,14 @@ static inline int netlbl_secattr_catmap_
 	return -ENOENT;
 }
 static inline int netlbl_secattr_catmap_setbit(
-	                              struct netlbl_lsm_secattr_catmap *catmap,
+				      struct netlbl_lsm_secattr_catmap **catmap,
 				      u32 bit,
 				      gfp_t flags)
 {
 	return 0;
 }
 static inline int netlbl_secattr_catmap_setrng(
-	                              struct netlbl_lsm_secattr_catmap *catmap,
+				      struct netlbl_lsm_secattr_catmap **catmap,
 				      u32 start,
 				      u32 end,
 				      gfp_t flags)
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -974,7 +974,7 @@ static int cipso_v4_map_cat_rbm_ntoh(con
 				return -EPERM;
 			break;
 		}
-		ret_val = netlbl_secattr_catmap_setbit(secattr->attr.mls.cat,
+		ret_val = netlbl_secattr_catmap_setbit(&secattr->attr.mls.cat,
 						       host_spot,
 						       GFP_ATOMIC);
 		if (ret_val != 0)
@@ -1076,7 +1076,7 @@ static int cipso_v4_map_cat_enum_ntoh(co
 	u32 iter;
 
 	for (iter = 0; iter < net_cat_len; iter += 2) {
-		ret_val = netlbl_secattr_catmap_setbit(secattr->attr.mls.cat,
+		ret_val = netlbl_secattr_catmap_setbit(&secattr->attr.mls.cat,
 				get_unaligned_be16(&net_cat[iter]),
 				GFP_ATOMIC);
 		if (ret_val != 0)
@@ -1218,7 +1218,7 @@ static int cipso_v4_map_cat_rng_ntoh(con
 		else
 			cat_low = 0;
 
-		ret_val = netlbl_secattr_catmap_setrng(secattr->attr.mls.cat,
+		ret_val = netlbl_secattr_catmap_setrng(&secattr->attr.mls.cat,
 						       cat_low,
 						       cat_high,
 						       GFP_ATOMIC);
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -523,7 +523,7 @@ int netlbl_secattr_catmap_walk_rng(struc
 
 /**
  * netlbl_secattr_catmap_setbit - Set a bit in a LSM secattr catmap
- * @catmap: the category bitmap
+ * @catmap: pointer to the category bitmap
  * @bit: the bit to set
  * @flags: memory allocation flags
  *
@@ -532,18 +532,25 @@ int netlbl_secattr_catmap_walk_rng(struc
  * negative values on failure.
  *
  */
-int netlbl_secattr_catmap_setbit(struct netlbl_lsm_secattr_catmap *catmap,
+int netlbl_secattr_catmap_setbit(struct netlbl_lsm_secattr_catmap **catmap,
 				 u32 bit,
 				 gfp_t flags)
 {
-	struct netlbl_lsm_secattr_catmap *iter = catmap;
+	struct netlbl_lsm_secattr_catmap *iter = *catmap;
 	u32 node_bit;
 	u32 node_idx;
 
 	while (iter->next != NULL &&
 	       bit >= (iter->startbit + NETLBL_CATMAP_SIZE))
 		iter = iter->next;
-	if (bit >= (iter->startbit + NETLBL_CATMAP_SIZE)) {
+	if (bit < iter->startbit) {
+		iter = netlbl_secattr_catmap_alloc(flags);
+		if (iter == NULL)
+			return -ENOMEM;
+		iter->next = *catmap;
+		iter->startbit = bit & ~(NETLBL_CATMAP_SIZE - 1);
+		*catmap = iter;
+	} else if (bit >= (iter->startbit + NETLBL_CATMAP_SIZE)) {
 		iter->next = netlbl_secattr_catmap_alloc(flags);
 		if (iter->next == NULL)
 			return -ENOMEM;
@@ -561,7 +568,7 @@ int netlbl_secattr_catmap_setbit(struct
 
 /**
  * netlbl_secattr_catmap_setrng - Set a range of bits in a LSM secattr catmap
- * @catmap: the category bitmap
+ * @catmap: pointer to the category bitmap
  * @start: the starting bit
  * @end: the last bit in the string
  * @flags: memory allocation flags
@@ -571,15 +578,16 @@ int netlbl_secattr_catmap_setbit(struct
  * on success, negative values on failure.
  *
  */
-int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap *catmap,
+int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap **catmap,
 				 u32 start,
 				 u32 end,
 				 gfp_t flags)
 {
 	int ret_val = 0;
-	struct netlbl_lsm_secattr_catmap *iter = catmap;
+	struct netlbl_lsm_secattr_catmap *iter = *catmap;
 	u32 iter_max_spot;
 	u32 spot;
+	u32 orig_spot = iter->startbit;
 
 	/* XXX - This could probably be made a bit faster by combining writes
 	 * to the catmap instead of setting a single bit each time, but for
@@ -597,7 +605,9 @@ int netlbl_secattr_catmap_setrng(struct
 			iter = iter->next;
 			iter_max_spot = iter->startbit + NETLBL_CATMAP_SIZE;
 		}
-		ret_val = netlbl_secattr_catmap_setbit(iter, spot, flags);
+		ret_val = netlbl_secattr_catmap_setbit(&iter, spot, flags);
+		if (iter->startbit < orig_spot)
+			*catmap = iter;
 	}
 
 	return ret_val;
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1842,7 +1842,7 @@ static void smack_set_catset(char *catse
 		for (m = 0x80; m != 0; m >>= 1, cat++) {
 			if ((m & *cp) == 0)
 				continue;
-			rc = netlbl_secattr_catmap_setbit(sap->attr.mls.cat,
+			rc = netlbl_secattr_catmap_setbit(&sap->attr.mls.cat,
 							  cat, GFP_ATOMIC);
 		}
 }

