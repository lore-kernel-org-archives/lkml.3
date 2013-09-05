Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3IERdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:33:40 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:7941 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3IERdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:33:38 -0400
Message-ID: <5228C062.7030106@hp.com>
Date: Thu, 05 Sep 2013 13:33:22 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
References: <20130830204852.GE13318@ZenIV.linux.org.uk> <52214EBC.90100@hp.com> <20130831023516.GI13318@ZenIV.linux.org.uk> <20130831024233.GJ13318@ZenIV.linux.org.uk> <5224E647.80303@hp.com> <20130903060130.GD16261@gmail.com> <5225FCEE.7030901@hp.com> <CA+55aFyNmLt9GeR5XyxOs7aGLwH3EBCB+K9D6uGBef3FziP2-A@mail.gmail.com> <CA+55aFw0jme+qK5b_VJVqoVD6cZuSjVsm-Sgjf_YkPXgMToqUA@mail.gmail.com> <52274943.1040005@hp.com> <20130905133123.GA24351@gmail.com>
In-Reply-To: <20130905133123.GA24351@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090800070700070809040406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090800070700070809040406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/05/2013 09:31 AM, Ingo Molnar wrote:
> * Waiman Long<waiman.long@hp.com>  wrote:
>
>
>> The latest tty patches did work. The tty related spinlock contention
>> is now completely gone. The short workload can now reach over 8M JPM
>> which is the highest I have ever seen.
>>
>> The perf profile was:
>>
>> 5.85%     reaim  reaim                 [.] mul_short
>> 4.87%     reaim  [kernel.kallsyms]     [k] ebitmap_get_bit
>> 4.72%     reaim  reaim                 [.] mul_int
>> 4.71%     reaim  reaim                 [.] mul_long
>> 2.67%     reaim  libc-2.12.so          [.] __random_r
>> 2.64%     reaim  [kernel.kallsyms]     [k] lockref_get_not_zero
>> 1.58%     reaim  [kernel.kallsyms]     [k] copy_user_generic_string
>> 1.48%     reaim  [kernel.kallsyms]     [k] mls_level_isvalid
>> 1.35%     reaim  [kernel.kallsyms]     [k] find_next_bit
> 6%+ spent in ebitmap_get_bit() and mls_level_isvalid() looks like
> something worth optimizing.
>
> Is that called very often, or is it perhaps cache-bouncing for some
> reason?

The high cycle count is due more to inefficient algorithm in the 
mls_level_isvalid() function than cacheline contention in the code. The 
attached patch should address this problem. It is in linux-next and 
hopefully will be merged in 3.12.

-Longman

--------------090800070700070809040406
Content-Type: text/plain;
 name="0001-SELinux-Reduce-overhead-of-mls_level_isvalid-functio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-SELinux-Reduce-overhead-of-mls_level_isvalid-functio.pa";
 filename*1="tch"

>From 232a29fd04d5345d6af3330f48710cd48a345c10 Mon Sep 17 00:00:00 2001
From: Waiman Long <Waiman.Long@hp.com>
Date: Mon, 10 Jun 2013 13:52:36 -0400
Subject: [PATCH 1/2 v5] SELinux: Reduce overhead of mls_level_isvalid() function call
To: Stephen Smalley <sds@tycho.nsa.gov>,
    James Morris <james.l.morris@oracle.com>,
    Eric Paris <eparis@parisplace.org>
Cc: linux-security-module@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    "Chandramouleeswaran, Aswin" <aswin@hp.com>,
    "Norton, Scott J" <scott.norton@hp.com>

v4->v5:
  - Fix scripts/checkpatch.pl warning.

v3->v4:
  - Merge the 2 separate while loops in ebitmap_contains() into
    a single one.

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
 security/selinux/ss/ebitmap.c   |   20 ++++++++++++++++++--
 security/selinux/ss/ebitmap.h   |    2 +-
 security/selinux/ss/mls.c       |   22 +++++++---------------
 security/selinux/ss/mls_types.h |    2 +-
 4 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/security/selinux/ss/ebitmap.c b/security/selinux/ss/ebitmap.c
index 30f119b..820313a 100644
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
@@ -223,14 +228,25 @@ int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2)
 
 	n1 = e1->node;
 	n2 = e2->node;
+
 	while (n1 && n2 && (n1->startbit <= n2->startbit)) {
 		if (n1->startbit < n2->startbit) {
 			n1 = n1->next;
 			continue;
 		}
-		for (i = 0; i < EBITMAP_UNIT_NUMS; i++) {
+		for (i = EBITMAP_UNIT_NUMS - 1; (i >= 0) && !n2->maps[i]; )
+			i--;	/* Skip trailing NULL map entries */
+		if (last_e2bit && (i >= 0)) {
+			u32 lastsetbit = n2->startbit + i * EBITMAP_UNIT_SIZE +
+					 __fls(n2->maps[i]);
+			if (lastsetbit > last_e2bit)
+				return 0;
+		}
+
+		while (i >= 0) {
 			if ((n1->maps[i] & n2->maps[i]) != n2->maps[i])
 				return 0;
+			i--;
 		}
 
 		n1 = n1->next;
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


--------------090800070700070809040406--
