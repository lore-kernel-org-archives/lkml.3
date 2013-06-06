Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab3FFCwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:52:16 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:39694 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab3FFCwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:52:13 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 1/2 v3] SELinux: Reduce overhead of mls_level_isvalid() function call
Date: Wed,  5 Jun 2013 22:51:45 -0400
Message-Id: <1370487105-24325-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2->v3:
  - Remove unused local variables i, node from mls_level_isvalid().

v1->v2:
 - Move the new ebitmap comparison logic from mls_level_isvalid()
   into the ebitmap_contains() helper function.
 - Rerun perf and performance tests on the latest v3.10-rc4 kernel.

While running the high_systime workload of the AIM7 benchmark on
a 2-socket 12-core Westmere x86-64 machine running 3.10-rc4 kernel
(with HT on), it was found that a pretty sizable amount of time was
spent in the SELinux code. Below was the perf trace of the "perf
record -a -s" of a test run at 1500 users:

  5.04%            ls  [kernel.kallsyms]     [k] ebitmap_get_bit
  1.96%            ls  [kernel.kallsyms]     [k] mls_level_isvalid
  1.95%            ls  [kernel.kallsyms]     [k] find_next_bit

The ebitmap_get_bit() was the hottest function in the perf-report
output.  Both the ebitmap_get_bit() and find_next_bit() functions
were, in fact, called by mls_level_isvalid(). As a result, the
mls_level_isvalid() call consumed 8.95% of the total CPU time of
all the 24 virtual CPUs which is quite a lot. The majority of the
mls_level_isvalid() function invocations come from the socket creation
system call.

Looking at the mls_level_isvalid() function, it is checking to see
if all the bits set in one of the ebitmap structure are also set in
another one as well as the highest set bit is no bigger than the one
specified by the given policydb data structure. It is doing it in
a bit-by-bit manner. So if the ebitmap structure has many bits set,
the iteration loop will be done many times.

The current code can be rewritten to use a similar algorithm as the
ebitmap_contains() function with an additional check for the
highest set bit. The ebitmap_contains() function was extended to
cover an optional additional check for the highest set bit, and the
mls_level_isvalid() function was modified to call ebitmap_contains().

With that change, the perf trace showed that the used CPU time drop
down to just 0.08% (ebitmap_contains + mls_level_isvalid) of the
total which is about 100X less than before.

  0.07%            ls  [kernel.kallsyms]     [k] ebitmap_contains
  0.05%            ls  [kernel.kallsyms]     [k] ebitmap_get_bit
  0.01%            ls  [kernel.kallsyms]     [k] mls_level_isvalid
  0.01%            ls  [kernel.kallsyms]     [k] find_next_bit

The remaining ebitmap_get_bit() and find_next_bit() functions calls
are made by other kernel routines as the new mls_level_isvalid()
function will not call them anymore.

This patch also improves the high_systime AIM7 benchmark result,
though the improvement is not as impressive as is suggested by the
reduction in CPU time spent in the ebitmap functions. The table below
shows the performance change on the 2-socket x86-64 system (with HT
on) mentioned above.

+--------------+---------------+----------------+-----------------+
|   Workload   | mean % change | mean % change  | mean % change   |
|              | 10-100 users  | 200-1000 users | 1100-2000 users |
+--------------+---------------+----------------+-----------------+
| high_systime |     +0.1%     |     +0.9%      |     +2.6%       |
+--------------+---------------+----------------+-----------------+

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 security/selinux/ss/ebitmap.c   |   35 ++++++++++++++++++++++++++++++++++-
 security/selinux/ss/ebitmap.h   |    2 +-
 security/selinux/ss/mls.c       |   22 +++++++---------------
 security/selinux/ss/mls_types.h |    2 +-
 4 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/security/selinux/ss/ebitmap.c b/security/selinux/ss/ebitmap.c
index 30f119b..100b3e6 100644
--- a/security/selinux/ss/ebitmap.c
+++ b/security/selinux/ss/ebitmap.c
@@ -213,7 +213,12 @@ netlbl_import_failure:
 }
 #endif /* CONFIG_NETLABEL */
 
-int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2)
+/*
+ * Check to see if all the bits set in e2 are also set in e1. Optionally,
+ * if last_e2bit is non-zero, the highest set bit in e2 cannot exceed
+ * last_e2bit.
+ */
+int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2, u32 last_e2bit)
 {
 	struct ebitmap_node *n1, *n2;
 	int i;
@@ -223,6 +228,33 @@ int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2)
 
 	n1 = e1->node;
 	n2 = e2->node;
+	if (last_e2bit) {
+		while (n1 && n2 && (n1->startbit <= n2->startbit)) {
+			int lastsetbit = -1;
+
+			if (n1->startbit < n2->startbit) {
+				n1 = n1->next;
+				continue;
+			}
+			for (i = EBITMAP_UNIT_NUMS - 1; i >= 0; i--) {
+				if (!n2->maps[i])
+					continue;
+				if ((n1->maps[i] & n2->maps[i]) != n2->maps[i])
+					return 0;
+				if (lastsetbit < 0)
+					lastsetbit = n2->startbit +
+						     i * EBITMAP_UNIT_SIZE +
+						     __fls(n2->maps[i]);
+			}
+			if ((lastsetbit >= 0) && (lastsetbit > last_e2bit))
+				return 0;
+
+			n1 = n1->next;
+			n2 = n2->next;
+		}
+		goto done;
+	}
+
 	while (n1 && n2 && (n1->startbit <= n2->startbit)) {
 		if (n1->startbit < n2->startbit) {
 			n1 = n1->next;
@@ -237,6 +269,7 @@ int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2)
 		n2 = n2->next;
 	}
 
+done:
 	if (n2)
 		return 0;
 
diff --git a/security/selinux/ss/ebitmap.h b/security/selinux/ss/ebitmap.h
index 922f8af..e7eb3a9 100644
--- a/security/selinux/ss/ebitmap.h
+++ b/security/selinux/ss/ebitmap.h
@@ -117,7 +117,7 @@ static inline void ebitmap_node_clr_bit(struct ebitmap_node *n,
 
 int ebitmap_cmp(struct ebitmap *e1, struct ebitmap *e2);
 int ebitmap_cpy(struct ebitmap *dst, struct ebitmap *src);
-int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2);
+int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2, u32 last_e2bit);
 int ebitmap_get_bit(struct ebitmap *e, unsigned long bit);
 int ebitmap_set_bit(struct ebitmap *e, unsigned long bit, int value);
 void ebitmap_destroy(struct ebitmap *e);
diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
index 40de8d3..c85bc1e 100644
--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -160,8 +160,6 @@ void mls_sid_to_context(struct context *context,
 int mls_level_isvalid(struct policydb *p, struct mls_level *l)
 {
 	struct level_datum *levdatum;
-	struct ebitmap_node *node;
-	int i;
 
 	if (!l->sens || l->sens > p->p_levels.nprim)
 		return 0;
@@ -170,19 +168,13 @@ int mls_level_isvalid(struct policydb *p, struct mls_level *l)
 	if (!levdatum)
 		return 0;
 
-	ebitmap_for_each_positive_bit(&l->cat, node, i) {
-		if (i > p->p_cats.nprim)
-			return 0;
-		if (!ebitmap_get_bit(&levdatum->level->cat, i)) {
-			/*
-			 * Category may not be associated with
-			 * sensitivity.
-			 */
-			return 0;
-		}
-	}
-
-	return 1;
+	/*
+	 * Return 1 iff all the bits set in l->cat are also be set in
+	 * levdatum->level->cat and no bit in l->cat is larger than
+	 * p->p_cats.nprim.
+	 */
+	return ebitmap_contains(&levdatum->level->cat, &l->cat,
+				p->p_cats.nprim);
 }
 
 int mls_range_isvalid(struct policydb *p, struct mls_range *r)
diff --git a/security/selinux/ss/mls_types.h b/security/selinux/ss/mls_types.h
index 03bed52..e936487 100644
--- a/security/selinux/ss/mls_types.h
+++ b/security/selinux/ss/mls_types.h
@@ -35,7 +35,7 @@ static inline int mls_level_eq(struct mls_level *l1, struct mls_level *l2)
 static inline int mls_level_dom(struct mls_level *l1, struct mls_level *l2)
 {
 	return ((l1->sens >= l2->sens) &&
-		ebitmap_contains(&l1->cat, &l2->cat));
+		ebitmap_contains(&l1->cat, &l2->cat, 0));
 }
 
 #define mls_level_incomp(l1, l2) \
-- 
1.7.1

