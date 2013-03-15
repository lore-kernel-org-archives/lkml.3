Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3COTzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:55:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18130 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab3COTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:25 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qhPimrWd1c4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=lxun94ryACIA:10 a=FwIloPuqqMcaNtEEPS0A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=c8YeWs4QSjEbucCUI4UA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195122.681528384@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 04/20] ftrace: Fix function probe to only enable needed functions
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Fix-function-probe-to-only-enable-needed-func.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently the function probe enables all functions and runs a "hash"
against every function call to see if it should call a probe. This
is extremely wasteful.

Note, a probe is something like:

  echo schedule:traceoff > /debug/tracing/set_ftrace_filter

When schedule is called, the probe will disable tracing. But currently,
it has a call back for *all* functions, and checks to see if the
called function is the probe that is needed.

The probe function has been created before ftrace was rewritten to
allow for more than one "op" to be registered by the function tracer.
When probes were created, it couldn't limit the functions without also
limiting normal function calls. But now we can, it's about time
to update the probe code.

Todo, have separate ops for different entries. That is, assign
a ftrace_ops per probe, instead of one op for all probes. But
as there's not many probes assigned, this may not be that urgent.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   48 +++++++++++++++++++++++++++++++++++++++++++++=
+--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e6effd0..dab031f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2988,18 +2988,20 @@ static void ftrace_free_entry_rcu(struct rcu_head *=
rhp)
 	kfree(entry);
 }
=20
-
 int
 register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 			      void *data)
 {
 	struct ftrace_func_probe *entry;
+	struct ftrace_hash **orig_hash =3D &trace_probe_ops.filter_hash;
+	struct ftrace_hash *hash;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
 	int type, len, not;
 	unsigned long key;
 	int count =3D 0;
 	char *search;
+	int ret;
=20
 	type =3D filter_parse_regex(glob, strlen(glob), &search, &not);
 	len =3D strlen(search);
@@ -3010,8 +3012,16 @@ register_ftrace_function_probe(char *glob, struct ft=
race_probe_ops *ops,
=20
 	mutex_lock(&ftrace_lock);
=20
-	if (unlikely(ftrace_disabled))
+	hash =3D alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+	if (!hash) {
+		count =3D -ENOMEM;
+		goto out_unlock;
+	}
+
+	if (unlikely(ftrace_disabled)) {
+		count =3D -ENODEV;
 		goto out_unlock;
+	}
=20
 	do_for_each_ftrace_rec(pg, rec) {
=20
@@ -3043,6 +3053,13 @@ register_ftrace_function_probe(char *glob, struct ft=
race_probe_ops *ops,
 			}
 		}
=20
+		ret =3D enter_record(hash, rec, 0);
+		if (ret < 0) {
+			kfree(entry);
+			count =3D ret;
+			goto out_unlock;
+		}
+
 		entry->ops =3D ops;
 		entry->ip =3D rec->ip;
=20
@@ -3050,10 +3067,16 @@ register_ftrace_function_probe(char *glob, struct f=
trace_probe_ops *ops,
 		hlist_add_head_rcu(&entry->node, &ftrace_func_hash[key]);
=20
 	} while_for_each_ftrace_rec();
+
+	ret =3D ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
+	if (ret < 0)
+		count =3D ret;
+
 	__enable_ftrace_function_probe();
=20
  out_unlock:
 	mutex_unlock(&ftrace_lock);
+	free_ftrace_hash(hash);
=20
 	return count;
 }
@@ -3067,7 +3090,10 @@ static void
 __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *op=
s,
 				  void *data, int flags)
 {
+	struct ftrace_func_entry *rec_entry;
 	struct ftrace_func_probe *entry;
+	struct ftrace_hash **orig_hash =3D &trace_probe_ops.filter_hash;
+	struct ftrace_hash *hash;
 	struct hlist_node *n, *tmp;
 	char str[KSYM_SYMBOL_LEN];
 	int type =3D MATCH_FULL;
@@ -3088,6 +3114,12 @@ __unregister_ftrace_function_probe(char *glob, struc=
t ftrace_probe_ops *ops,
 	}
=20
 	mutex_lock(&ftrace_lock);
+
+	hash =3D alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+	if (!hash)
+		/* Hmm, should report this somehow */
+		goto out_unlock;
+
 	for (i =3D 0; i < FTRACE_FUNC_HASHSIZE; i++) {
 		struct hlist_head *hhd =3D &ftrace_func_hash[i];
=20
@@ -3108,12 +3140,24 @@ __unregister_ftrace_function_probe(char *glob, stru=
ct ftrace_probe_ops *ops,
 					continue;
 			}
=20
+			rec_entry =3D ftrace_lookup_ip(hash, entry->ip);
+			/* It is possible more than one entry had this ip */
+			if (rec_entry)
+				free_hash_entry(hash, rec_entry);
+
 			hlist_del_rcu(&entry->node);
 			call_rcu_sched(&entry->rcu, ftrace_free_entry_rcu);
 		}
 	}
 	__disable_ftrace_function_probe();
+	/*
+	 * Remove after the disable is called. Otherwise, if the last
+	 * probe is removed, a null hash means *all enabled*.
+	 */
+	ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
+ out_unlock:
 	mutex_unlock(&ftrace_lock);
+	free_ftrace_hash(hash);
 }
=20
 void
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u6AAoJEOdOSU1xswtMO8MH/3OaZkx5xODAOFQjdxLvPP72
zimJaTZkjMO2pmIO83zQsJO4xZGvy+oC+b/zsFkJxOaMRvKxKtu/9D6Yu8u0HvO1
xllY42b4f+6gan7XA/Xfnqmi/q4eCi4OMfd2f/TLNAJMRa8MeZgbPOJATLD8231A
Xst8/LcuZY8OgGVrRmrqEOUYwHJhcZ59DSUUx+yV2MT829vkXz58SkwZg1aJFUy1
ujMB0X5fFBDg7r00xrcm0Pj2fcqqUXkxMNnx+ktSGyXxHhUZ60JWram576T53Ia2
yqqX0WAKX2llSUHVwDkKUCLdRBfUlSvpQ4b7dPrGWOAoxWfeatbRzRVK0TZ6Zhs=
=9kvS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
