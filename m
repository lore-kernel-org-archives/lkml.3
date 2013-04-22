Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3DVF4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:56:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37078 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3DVF4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:56:04 -0400
Date: Mon, 22 Apr 2013 15:55:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: linux-next: manual merge of the ftrace tree with Linus' tree
Message-Id: <20130422155551.0e9891130bb56f374d00e9fc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__22_Apr_2013_15_55_51_+1000_wfXsUwkOXWcFNwO="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Apr_2013_15_55_51_+1000_wfXsUwkOXWcFNwO=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

Today's linux-next merge of the ftrace tree got a conflict in
kernel/trace/ftrace.c between commit b67bfe0d42ca ("hlist: drop the node
parameter from iterators") from Linus' tree and commit f1943977e664
("tracing: Get rid of unneeded key calculation in ftrace_hash_move()")
and e1df4cb682ab ("ftrace: Fix function probe to only enable needed
functions") from the ftrace tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/trace/ftrace.c
index b3fde6d,9b44abb..0000000
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@@ -761,9 -755,10 +754,9 @@@ ftrace_find_profiled_func(struct ftrace
  {
  	struct ftrace_profile *rec;
  	struct hlist_head *hhd;
 -	struct hlist_node *n;
  	unsigned long key;
 =20
- 	key =3D hash_long(ip, ftrace_profile_bits);
+ 	key =3D hash_long(ip, FTRACE_PROFILE_HASH_BITS);
  	hhd =3D &stat->hash[key];
 =20
  	if (hlist_empty(hhd))
@@@ -1371,11 -1354,7 +1363,7 @@@ ftrace_hash_move(struct ftrace_ops *ops
  	size =3D 1 << src->size_bits;
  	for (i =3D 0; i < size; i++) {
  		hhd =3D &src->buckets[i];
 -		hlist_for_each_entry_safe(entry, tp, tn, hhd, hlist) {
 +		hlist_for_each_entry_safe(entry, tn, hhd, hlist) {
- 			if (bits > 0)
- 				key =3D hash_long(entry->ip, bits);
- 			else
- 				key =3D 0;
  			remove_hash_entry(src, entry);
  			__add_hash_entry(new_hash, entry);
  		}
@@@ -3062,8 -3075,13 +3070,13 @@@ static voi
  __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *o=
ps,
  				  void *data, int flags)
  {
+ 	struct ftrace_func_entry *rec_entry;
  	struct ftrace_func_probe *entry;
+ 	struct ftrace_func_probe *p;
+ 	struct ftrace_hash **orig_hash =3D &trace_probe_ops.filter_hash;
+ 	struct list_head free_list;
+ 	struct ftrace_hash *hash;
 -	struct hlist_node *n, *tmp;
 +	struct hlist_node *tmp;
  	char str[KSYM_SYMBOL_LEN];
  	int type =3D MATCH_FULL;
  	int i, len =3D 0;

--Signature=_Mon__22_Apr_2013_15_55_51_+1000_wfXsUwkOXWcFNwO=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRdNDnAAoJEECxmPOUX5FE3KMP/An8WLFnmIbvo2mKvsbnWtY8
vjU48MsoVsYCC3c4PFLCaoKWiBEpRyWS3vJ8mfBgmCyNnqFZ034SXBhCZaKU3BNO
9YKQD0ZU7sUiY8rI5l4yHpwRu/wAAVt1N5Km4YdMCeMBIEPxHkmnWWXqLm1cODsq
ApJatp90wWUXIYnAnW3AAkYH7/Dj9nvcbI+ThvPSZFfmfnO6hg4uJ38WBQX7EFWo
anMjMqa65X88T8Is9DtwQ/uCRtZ+yaJEfPHnfz6lOPCtKsjp6zNHYvi3FUMfaReE
4GGviCBojoZyXGkCWi3wHI/dbPUTFhbM32dMBHr6EL6axbsXe4TAnq7fcu6CdrxQ
2toGEvhg7sXsrGxH0sP0vox7RHslpyMbsUIQL40Pw9zU1CUnmMM7bIul7jVXy+UG
GTHwMYR00RvYYJDK2LpD32ZysWBR6T1PyElf0eS1Z29Hw/qOITyOV+JJRjh60wCY
/cF3voos3JfgFsQE0VUGuFPcLA0syDyCNDkSC8d/hSjjKKEaFlaWET3JvS/bO3cQ
gqyINlahtpvaI0XT0YM18DZDmu86+OT6cRWoXr6HX3jVs2wiq9DUaZUpAPzvcabO
WWejsCxo3SP4I4rjZxQTnz76taWdFeoxRqsNuJTtOVpd/Lshq7FdIkyFLeToBQFm
cjNfcnUzO9yICOTpF8GT
=Kx2k
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Apr_2013_15_55_51_+1000_wfXsUwkOXWcFNwO=--
