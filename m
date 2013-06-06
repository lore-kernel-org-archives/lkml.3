Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3FFWUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:20:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19810 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3FFWTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:19:11 -0400
X-Authority-Analysis: v=2.0 cv=Et5QXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=A-z8g6epODsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QZ4w3rYvwOcA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=2AScbALsEEuzOGVbEEsA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=EF0y-TNDx7jEwRfU7CAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130606221909.577983810@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Jun 2013 18:16:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 2/4] ftrace: Use the rcu _notrace variants for rcu_dereference_raw() and
 friends
References: <20130606221654.698742573@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Use-the-rcu-_notrace-variants-for-rcu_derefer.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="===============7013640560473505300=="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============7013640560473505300==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <rostedt@goodmis.org>

As rcu_dereference_raw() under RCU debug config options can add quite a
bit of checks, and that tracing uses rcu_dereference_raw(), these checks
happen with the function tracer. The function tracer also happens to trace
these debug checks too. This added overhead can livelock the system.

Have the function tracer use the new RCU _notrace equivalents that do
not do the debug checks for RCU.

Link: http://lkml.kernel.org/r/20130528184209.467603904@goodmis.org

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b549b0f..6c508ff 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -120,22 +120,22 @@ static void ftrace_ops_no_ops(unsigned long ip, unsig=
ned long parent_ip);
=20
 /*
  * Traverse the ftrace_global_list, invoking all entries.  The reason that=
 we
- * can use rcu_dereference_raw() is that elements removed from this list
+ * can use rcu_dereference_raw_notrace() is that elements removed from thi=
s list
  * are simply leaked, so there is no need to interact with a grace-period
- * mechanism.  The rcu_dereference_raw() calls are needed to handle
+ * mechanism.  The rcu_dereference_raw_notrace() calls are needed to handle
  * concurrent insertions into the ftrace_global_list.
  *
  * Silly Alpha and silly pointer-speculation compiler optimizations!
  */
 #define do_for_each_ftrace_op(op, list)			\
-	op =3D rcu_dereference_raw(list);			\
+	op =3D rcu_dereference_raw_notrace(list);			\
 	do
=20
 /*
  * Optimized for just a single item in the list (as that is the normal cas=
e).
  */
 #define while_for_each_ftrace_op(op)				\
-	while (likely(op =3D rcu_dereference_raw((op)->next)) &&	\
+	while (likely(op =3D rcu_dereference_raw_notrace((op)->next)) &&	\
 	       unlikely((op) !=3D &ftrace_list_end))
=20
 static inline void ftrace_ops_init(struct ftrace_ops *ops)
@@ -779,7 +779,7 @@ ftrace_find_profiled_func(struct ftrace_profile_stat *s=
tat, unsigned long ip)
 	if (hlist_empty(hhd))
 		return NULL;
=20
-	hlist_for_each_entry_rcu(rec, hhd, node) {
+	hlist_for_each_entry_rcu_notrace(rec, hhd, node) {
 		if (rec->ip =3D=3D ip)
 			return rec;
 	}
@@ -1165,7 +1165,7 @@ ftrace_lookup_ip(struct ftrace_hash *hash, unsigned l=
ong ip)
=20
 	hhd =3D &hash->buckets[key];
=20
-	hlist_for_each_entry_rcu(entry, hhd, hlist) {
+	hlist_for_each_entry_rcu_notrace(entry, hhd, hlist) {
 		if (entry->ip =3D=3D ip)
 			return entry;
 	}
@@ -1422,8 +1422,8 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long=
 ip)
 	struct ftrace_hash *notrace_hash;
 	int ret;
=20
-	filter_hash =3D rcu_dereference_raw(ops->filter_hash);
-	notrace_hash =3D rcu_dereference_raw(ops->notrace_hash);
+	filter_hash =3D rcu_dereference_raw_notrace(ops->filter_hash);
+	notrace_hash =3D rcu_dereference_raw_notrace(ops->notrace_hash);
=20
 	if ((ftrace_hash_empty(filter_hash) ||
 	     ftrace_lookup_ip(filter_hash, ip)) &&
@@ -2920,7 +2920,7 @@ static void function_trace_probe_call(unsigned long i=
p, unsigned long parent_ip,
 	 * on the hash. rcu_read_lock is too dangerous here.
 	 */
 	preempt_disable_notrace();
-	hlist_for_each_entry_rcu(entry, hhd, node) {
+	hlist_for_each_entry_rcu_notrace(entry, hhd, node) {
 		if (entry->ip =3D=3D ip)
 			entry->ops->func(ip, parent_ip, &entry->data);
 	}
--=20
1.7.10.4



--===============7013640560473505300==
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRsQrdAAoJEOdOSU1xswtM7V8H/0XM9cDX81E+TYGK6ZTRmIeK
UPi1RI0+Cl4D1ZzKu1fOy3xDDdBxp72DiJBFZXoYxFobgjY6o9JhxxWeiyB2LiRf
t1KxBlEHw6leFomxRb0f75tI7KBOO6dELfbNbZlXfnpRkLRh2EDxixd5Zrb3lxgM
slUbJF3j81cnyL2sGWFZ8iCI941bliajNRXuGeDslJhWSLZ6nKwqKXigG4L+Pfl0
GKpvLavx9K5cxSFWVbyTqtb/wB5pa3/T8HxVLpQNf+yT8r8C0wGX7Ya3QDTLXSB5
vQolgFsvjxpSwPQMCCYQ/FwwaFd9Fl2j4Au67LJIhDQIqujR3vN98umgqyleVsE=
=Ru1f
-----END PGP SIGNATURE-----

--===============7013640560473505300==--
