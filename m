Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3EKANh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3EKANG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:06 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6ItXu9fk00gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=nP0WxYSnRpcA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=XUiTGkfo7A5uvOEMmh4A:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=U4LtojowmETmYyebIQgA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001304.214878967@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Subject: [PATCH 06/18] ftrace: Cleanup regex_lock and ftrace_lock around hash updating
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Cleanup-regex_lock-and-ftrace_lock-around-has.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Cleanup regex_lock and ftrace_lock locking points around
ftrace_ops hash update code.

The new rule is that regex_lock protects ops->*_hash
read-update-write code for each ftrace_ops. Usually,
hash update is done by following sequence.

1. allocate a new local hash and copy the original hash.
2. update the local hash.
3. move(actually, copy) back the local hash to ftrace_ops.
4. update ftrace entries if needed.
5. release the local hash.

This makes regex_lock protect #1-#4, and ftrace_lock
to protect #3, #4 and adding and removing ftrace_ops from the
ftrace_ops_list. The ftrace_lock protects #3 as well because
the move functions update the entries too.

Link: http://lkml.kernel.org/r/20130509054421.30398.83411.stgit@mhiramat-M0=
-7522

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   59 +++++++++++++++++++++++++++------------------=
----
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 827f2fe..cacf085 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2656,28 +2656,26 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		return -ENOMEM;
 	}
=20
+	iter->ops =3D ops;
+	iter->flags =3D flag;
+
+	mutex_lock(&ops->regex_lock);
+
 	if (flag & FTRACE_ITER_NOTRACE)
 		hash =3D ops->notrace_hash;
 	else
 		hash =3D ops->filter_hash;
=20
-	iter->ops =3D ops;
-	iter->flags =3D flag;
-
 	if (file->f_mode & FMODE_WRITE) {
-		mutex_lock(&ftrace_lock);
 		iter->hash =3D alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, hash=
);
-		mutex_unlock(&ftrace_lock);
-
 		if (!iter->hash) {
 			trace_parser_put(&iter->parser);
 			kfree(iter);
-			return -ENOMEM;
+			ret =3D -ENOMEM;
+			goto out_unlock;
 		}
 	}
=20
-	mutex_lock(&ops->regex_lock);
-
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
 		ftrace_filter_reset(iter->hash);
@@ -2697,6 +2695,8 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		}
 	} else
 		file->private_data =3D iter;
+
+ out_unlock:
 	mutex_unlock(&ops->regex_lock);
=20
 	return ret;
@@ -3012,7 +3012,7 @@ register_ftrace_function_probe(char *glob, struct ftr=
ace_probe_ops *ops,
 	if (WARN_ON(not))
 		return -EINVAL;
=20
-	mutex_lock(&ftrace_lock);
+	mutex_lock(&trace_probe_ops.regex_lock);
=20
 	hash =3D alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
 	if (!hash) {
@@ -3070,14 +3070,16 @@ register_ftrace_function_probe(char *glob, struct f=
trace_probe_ops *ops,
=20
 	} while_for_each_ftrace_rec();
=20
+	mutex_lock(&ftrace_lock);
 	ret =3D ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
 	if (ret < 0)
 		count =3D ret;
=20
 	__enable_ftrace_function_probe();
+	mutex_unlock(&ftrace_lock);
=20
  out_unlock:
-	mutex_unlock(&ftrace_lock);
+	mutex_unlock(&trace_probe_ops.regex_lock);
 	free_ftrace_hash(hash);
=20
 	return count;
@@ -3117,7 +3119,7 @@ __unregister_ftrace_function_probe(char *glob, struct=
 ftrace_probe_ops *ops,
 			return;
 	}
=20
-	mutex_lock(&ftrace_lock);
+	mutex_lock(&trace_probe_ops.regex_lock);
=20
 	hash =3D alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
 	if (!hash)
@@ -3155,6 +3157,7 @@ __unregister_ftrace_function_probe(char *glob, struct=
 ftrace_probe_ops *ops,
 			list_add(&entry->free_list, &free_list);
 		}
 	}
+	mutex_lock(&ftrace_lock);
 	__disable_ftrace_function_probe();
 	/*
 	 * Remove after the disable is called. Otherwise, if the last
@@ -3166,9 +3169,10 @@ __unregister_ftrace_function_probe(char *glob, struc=
t ftrace_probe_ops *ops,
 		list_del(&entry->free_list);
 		ftrace_free_entry(entry);
 	}
+	mutex_unlock(&ftrace_lock);
=20=09=09
  out_unlock:
-	mutex_unlock(&ftrace_lock);
+	mutex_unlock(&trace_probe_ops.regex_lock);
 	free_ftrace_hash(hash);
 }
=20
@@ -3284,11 +3288,10 @@ ftrace_regex_write(struct file *file, const char __=
user *ubuf,
 	} else
 		iter =3D file->private_data;
=20
-	mutex_lock(&iter->ops->regex_lock);
-
-	ret =3D -ENODEV;
 	if (unlikely(ftrace_disabled))
-		goto out_unlock;
+		return -ENODEV;
+
+	/* iter->hash is a local copy, so we don't need regex_lock */
=20
 	parser =3D &iter->parser;
 	read =3D trace_get_user(parser, ubuf, cnt, ppos);
@@ -3299,13 +3302,11 @@ ftrace_regex_write(struct file *file, const char __=
user *ubuf,
 					   parser->idx, enable);
 		trace_parser_clear(parser);
 		if (ret < 0)
-			goto out_unlock;
+			goto out;
 	}
=20
 	ret =3D read;
-out_unlock:
-	mutex_unlock(&iter->ops->regex_lock);
-
+ out:
 	return ret;
 }
=20
@@ -3357,16 +3358,19 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned ch=
ar *buf, int len,
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
=20
+	mutex_lock(&ops->regex_lock);
+
 	if (enable)
 		orig_hash =3D &ops->filter_hash;
 	else
 		orig_hash =3D &ops->notrace_hash;
=20
 	hash =3D alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
-	if (!hash)
-		return -ENOMEM;
+	if (!hash) {
+		ret =3D -ENOMEM;
+		goto out_regex_unlock;
+	}
=20
-	mutex_lock(&ops->regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
 	if (buf && !ftrace_match_records(hash, buf, len)) {
@@ -3584,8 +3588,6 @@ int ftrace_regex_release(struct inode *inode, struct =
file *file)
 	} else
 		iter =3D file->private_data;
=20
-	mutex_lock(&iter->ops->regex_lock);
-
 	parser =3D &iter->parser;
 	if (trace_parser_loaded(parser)) {
 		parser->buffer[parser->idx] =3D 0;
@@ -3594,6 +3596,8 @@ int ftrace_regex_release(struct inode *inode, struct =
file *file)
=20
 	trace_parser_put(parser);
=20
+	mutex_lock(&iter->ops->regex_lock);
+
 	if (file->f_mode & FMODE_WRITE) {
 		filter_hash =3D !!(iter->flags & FTRACE_ITER_FILTER);
=20
@@ -3611,10 +3615,11 @@ int ftrace_regex_release(struct inode *inode, struc=
t file *file)
=20
 		mutex_unlock(&ftrace_lock);
 	}
+
+	mutex_unlock(&iter->ops->regex_lock);
 	free_ftrace_hash(iter->hash);
 	kfree(iter);
=20
-	mutex_unlock(&iter->ops->regex_lock);
 	return 0;
 }
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0QAAoJEOdOSU1xswtM9A0IALJh9DJ1omu/zuCg6MVZidBC
3KIr42QZg0g5JaHAzmTyvo+kR7Y7LFE8gF9R7Y77Y0pONMNLnWy5V9ajphItYFg2
w9iUlkWJJPLJ/4ZNh4NtYoZhvyT0exjN5q9ssn5COpRlTZYksDAaAXtp1TskkzED
nKcKLn8U6C9I/eHv/l3lHpwgEUejePptplZs4UznoxMyTt+82A+JvhWgmOaxhNvh
btWMZDADdvCNvy0ER1eeuLS19FzI1JvWQHD47/clUSRpxop8oPgWN7cVftitBBR1
Z4BHsuKEAOjAHQlGdJLPJs5oyyAnE8YA1qrQ5XHAxk3FBrKOw9PPr158XwA0qBE=
=dy2o
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
