Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab3COTva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:51:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3COTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:25 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=4Xg1Fp5m0AAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=th7kLXwM-fwA:10 a=VnNF1IyMAAAA:8 a=g-aJanIbZVBLxqaGmZwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=KuWbMhO05WK8Gym5YtsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195123.675141137@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 09/20] ftrace: Use manual free after synchronize_sched() not
 call_rcu_sched()
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-Use-manual-free-after-synchronize_sched-not-c.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The entries to the probe hash must be freed after a synchronize_sched()
after the entry has been removed from the hash.

As the entries are registered with ops that may have their own callbacks,
and these callbacks may sleep, we can not use call_rcu_sched() because
the rcu callbacks registered with that are called from a softirq context.

Instead of using call_rcu_sched(), manually save the entries on a free_list
and at the end of the loop that removes the entries, do a synchronize_sched=
()
and then go through the free_list, freeing the entries.

Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ff0ef41..2577082 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1068,7 +1068,7 @@ struct ftrace_func_probe {
 	unsigned long		flags;
 	unsigned long		ip;
 	void			*data;
-	struct rcu_head		rcu;
+	struct list_head	free_list;
 };
=20
 struct ftrace_func_entry {
@@ -2978,11 +2978,8 @@ static void __disable_ftrace_function_probe(void)
 }
=20
=20
-static void ftrace_free_entry_rcu(struct rcu_head *rhp)
+static void ftrace_free_entry(struct ftrace_func_probe *entry)
 {
-	struct ftrace_func_probe *entry =3D
-		container_of(rhp, struct ftrace_func_probe, rcu);
-
 	if (entry->ops->free)
 		entry->ops->free(entry->ops, entry->ip, &entry->data);
 	kfree(entry);
@@ -3092,7 +3089,9 @@ __unregister_ftrace_function_probe(char *glob, struct=
 ftrace_probe_ops *ops,
 {
 	struct ftrace_func_entry *rec_entry;
 	struct ftrace_func_probe *entry;
+	struct ftrace_func_probe *p;
 	struct ftrace_hash **orig_hash =3D &trace_probe_ops.filter_hash;
+	struct list_head free_list;
 	struct ftrace_hash *hash;
 	struct hlist_node *n, *tmp;
 	char str[KSYM_SYMBOL_LEN];
@@ -3120,6 +3119,8 @@ __unregister_ftrace_function_probe(char *glob, struct=
 ftrace_probe_ops *ops,
 		/* Hmm, should report this somehow */
 		goto out_unlock;
=20
+	INIT_LIST_HEAD(&free_list);
+
 	for (i =3D 0; i < FTRACE_FUNC_HASHSIZE; i++) {
 		struct hlist_head *hhd =3D &ftrace_func_hash[i];
=20
@@ -3146,7 +3147,7 @@ __unregister_ftrace_function_probe(char *glob, struct=
 ftrace_probe_ops *ops,
 				free_hash_entry(hash, rec_entry);
=20
 			hlist_del_rcu(&entry->node);
-			call_rcu_sched(&entry->rcu, ftrace_free_entry_rcu);
+			list_add(&entry->free_list, &free_list);
 		}
 	}
 	__disable_ftrace_function_probe();
@@ -3155,6 +3156,12 @@ __unregister_ftrace_function_probe(char *glob, struc=
t ftrace_probe_ops *ops,
 	 * probe is removed, a null hash means *all enabled*.
 	 */
 	ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
+	synchronize_sched();
+	list_for_each_entry_safe(entry, p, &free_list, free_list) {
+		list_del(&entry->free_list);
+		ftrace_free_entry(entry);
+	}
+=09=09
  out_unlock:
 	mutex_unlock(&ftrace_lock);
 	free_ftrace_hash(hash);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u7AAoJEOdOSU1xswtMxwcH/iyfBSnD8MzKeZDXPOsw5rd2
MP72+b5dXJz1LzLXR2H7roup54jGgSUqtaVDkjg9Qi2JBmgd5poxnlqqTXfHBJbF
gjPsL3HKyziz2MvSSLyrSR5SJ9/8syElr2kDbm093XZvhMMcbAEbdoz+sxG5E1jd
ifB54ae/7LJLPI0FE0aZhswNoL8+0Djw4Yn7bUoqppvMq1AgQPNLbtLYVJLdIued
czSKbRQMjqKoAnLxaMgKuICNRNsImuwjtGkYEeyIVdTfC4jSQ35Lw952neGkyHqW
qSqJ4eMtGMaqdGo5bS2Vvp1r1uG9xtCfOrSOOrhxafZq5FnEdFTtcPvfq7Oz9v8=
=j8ib
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
