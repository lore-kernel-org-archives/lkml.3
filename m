Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab3EKANt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab3EKANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:07 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JUmLt0fcgMsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=uwJmJXH8fy8A:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=DYgSS_a1FJ8RdWW7jJ4A:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=NLnjE3mPQ5tHcFVBEPwA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001303.991917922@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:11 -0400
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
Subject: [PATCH 05/18] ftrace, kprobes: Fix a deadlock on ftrace_regex_lock
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-kprobes-Fix-a-deadlock-on-ftrace_regex_lock.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix a deadlock on ftrace_regex_lock which happens when setting
an enable_event trigger on dynamic kprobe event as below.

----
sh-2.05b# echo p vfs_symlink > kprobe_events
sh-2.05b# echo vfs_symlink:enable_event:kprobes:p_vfs_symlink_0 > set_ftrac=
e_filter

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ INFO: possible recursive locking detected ]
3.9.0+ #35 Not tainted
---------------------------------------------
sh/72 is trying to acquire lock:
 (ftrace_regex_lock){+.+.+.}, at: [<ffffffff810ba6c1>] ftrace_set_hash+0x81=
/0x1f0

but task is already holding lock:
 (ftrace_regex_lock){+.+.+.}, at: [<ffffffff810b7cbd>] ftrace_regex_write.i=
sra.29.part.30+0x3d/0x220

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(ftrace_regex_lock);
  lock(ftrace_regex_lock);

 *** DEADLOCK ***
----

To fix that, this introduces a finer regex_lock for each ftrace_ops.
ftrace_regex_lock is too big of a lock which protects all
filter/notrace_hash operations, but it doesn't need to be a global
lock after supporting multiple ftrace_ops because each ftrace_ops
has its own filter/notrace_hash.

Link: http://lkml.kernel.org/r/20130509054417.30398.84254.stgit@mhiramat-M0=
-7522

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
[ Added initialization flag and automate mutex initialization for
  non ftrace.c ftrace_probes. ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    4 +++
 kernel/trace/ftrace.c  |   73 ++++++++++++++++++++++++++++++++++----------=
----
 2 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f83e17a..99d0fbc 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -90,6 +90,8 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned =
long parent_ip,
  *            not set this, then the ftrace infrastructure will add recurs=
ion
  *            protection for the caller.
  * STUB   - The ftrace_ops is just a place holder.
+ * INITIALIZED - The ftrace_ops has already been initialized (first use ti=
me
+ *            register_ftrace_function() is called, it will initialized th=
e ops)
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			=3D 1 << 0,
@@ -100,6 +102,7 @@ enum {
 	FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED	=3D 1 << 5,
 	FTRACE_OPS_FL_RECURSION_SAFE		=3D 1 << 6,
 	FTRACE_OPS_FL_STUB			=3D 1 << 7,
+	FTRACE_OPS_FL_INITIALIZED		=3D 1 << 8,
 };
=20
 struct ftrace_ops {
@@ -110,6 +113,7 @@ struct ftrace_ops {
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
+	struct mutex			regex_lock;
 #endif
 };
=20
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d85a0ad..827f2fe 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -64,6 +64,13 @@
=20
 #define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_CONTR=
OL)
=20
+#ifdef CONFIG_DYNAMIC_FTRACE
+#define INIT_REGEX_LOCK(opsname)	\
+	.regex_lock	=3D __MUTEX_INITIALIZER(opsname.regex_lock),
+#else
+#define INIT_REGEX_LOCK(opsname)
+#endif
+
 static struct ftrace_ops ftrace_list_end __read_mostly =3D {
 	.func		=3D ftrace_stub,
 	.flags		=3D FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_STUB,
@@ -131,6 +138,16 @@ static void ftrace_ops_no_ops(unsigned long ip, unsign=
ed long parent_ip);
 	while (likely(op =3D rcu_dereference_raw((op)->next)) &&	\
 	       unlikely((op) !=3D &ftrace_list_end))
=20
+static inline void ftrace_ops_init(struct ftrace_ops *ops)
+{
+#ifdef CONFIG_DYNAMIC_FTRACE
+	if (!(ops->flags & FTRACE_OPS_FL_INITIALIZED)) {
+		mutex_init(&ops->regex_lock);
+		ops->flags |=3D FTRACE_OPS_FL_INITIALIZED;
+	}
+#endif
+}
+
 /**
  * ftrace_nr_registered_ops - return number of ops registered
  *
@@ -907,7 +924,8 @@ static void unregister_ftrace_profiler(void)
 #else
 static struct ftrace_ops ftrace_profile_ops __read_mostly =3D {
 	.func		=3D function_profile_call,
-	.flags		=3D FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags		=3D FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
+	INIT_REGEX_LOCK(ftrace_profile_ops)
 };
=20
 static int register_ftrace_profiler(void)
@@ -1103,11 +1121,10 @@ static struct ftrace_ops global_ops =3D {
 	.func			=3D ftrace_stub,
 	.notrace_hash		=3D EMPTY_HASH,
 	.filter_hash		=3D EMPTY_HASH,
-	.flags			=3D FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags			=3D FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
+	INIT_REGEX_LOCK(global_ops)
 };
=20
-static DEFINE_MUTEX(ftrace_regex_lock);
-
 struct ftrace_page {
 	struct ftrace_page	*next;
 	struct dyn_ftrace	*records;
@@ -1247,6 +1264,7 @@ static void free_ftrace_hash_rcu(struct ftrace_hash *=
hash)
=20
 void ftrace_free_filter(struct ftrace_ops *ops)
 {
+	ftrace_ops_init(ops);
 	free_ftrace_hash(ops->filter_hash);
 	free_ftrace_hash(ops->notrace_hash);
 }
@@ -2624,6 +2642,8 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 	struct ftrace_hash *hash;
 	int ret =3D 0;
=20
+	ftrace_ops_init(ops);
+
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
=20
@@ -2656,7 +2676,7 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		}
 	}
=20
-	mutex_lock(&ftrace_regex_lock);
+	mutex_lock(&ops->regex_lock);
=20
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
@@ -2677,7 +2697,7 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		}
 	} else
 		file->private_data =3D iter;
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&ops->regex_lock);
=20
 	return ret;
 }
@@ -2910,6 +2930,8 @@ static void function_trace_probe_call(unsigned long i=
p, unsigned long parent_ip,
 static struct ftrace_ops trace_probe_ops __read_mostly =3D
 {
 	.func		=3D function_trace_probe_call,
+	.flags		=3D FTRACE_OPS_FL_INITIALIZED,
+	INIT_REGEX_LOCK(trace_probe_ops)
 };
=20
 static int ftrace_probe_registered;
@@ -3256,18 +3278,18 @@ ftrace_regex_write(struct file *file, const char __=
user *ubuf,
 	if (!cnt)
 		return 0;
=20
-	mutex_lock(&ftrace_regex_lock);
-
-	ret =3D -ENODEV;
-	if (unlikely(ftrace_disabled))
-		goto out_unlock;
-
 	if (file->f_mode & FMODE_READ) {
 		struct seq_file *m =3D file->private_data;
 		iter =3D m->private;
 	} else
 		iter =3D file->private_data;
=20
+	mutex_lock(&iter->ops->regex_lock);
+
+	ret =3D -ENODEV;
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
+
 	parser =3D &iter->parser;
 	read =3D trace_get_user(parser, ubuf, cnt, ppos);
=20
@@ -3282,7 +3304,7 @@ ftrace_regex_write(struct file *file, const char __us=
er *ubuf,
=20
 	ret =3D read;
 out_unlock:
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&iter->ops->regex_lock);
=20
 	return ret;
 }
@@ -3344,7 +3366,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char=
 *buf, int len,
 	if (!hash)
 		return -ENOMEM;
=20
-	mutex_lock(&ftrace_regex_lock);
+	mutex_lock(&ops->regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
 	if (buf && !ftrace_match_records(hash, buf, len)) {
@@ -3366,7 +3388,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char=
 *buf, int len,
 	mutex_unlock(&ftrace_lock);
=20
  out_regex_unlock:
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&ops->regex_lock);
=20
 	free_ftrace_hash(hash);
 	return ret;
@@ -3392,6 +3414,7 @@ ftrace_set_addr(struct ftrace_ops *ops, unsigned long=
 ip, int remove,
 int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 			 int remove, int reset)
 {
+	ftrace_ops_init(ops);
 	return ftrace_set_addr(ops, ip, remove, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
@@ -3416,6 +3439,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned cha=
r *buf, int len,
 int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset)
 {
+	ftrace_ops_init(ops);
 	return ftrace_set_regex(ops, buf, len, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter);
@@ -3434,6 +3458,7 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter);
 int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset)
 {
+	ftrace_ops_init(ops);
 	return ftrace_set_regex(ops, buf, len, reset, 0);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_notrace);
@@ -3524,6 +3549,8 @@ ftrace_set_early_filter(struct ftrace_ops *ops, char =
*buf, int enable)
 {
 	char *func;
=20
+	ftrace_ops_init(ops);
+
 	while (buf) {
 		func =3D strsep(&buf, ",");
 		ftrace_set_regex(ops, func, strlen(func), 0, enable);
@@ -3551,14 +3578,14 @@ int ftrace_regex_release(struct inode *inode, struc=
t file *file)
 	int filter_hash;
 	int ret;
=20
-	mutex_lock(&ftrace_regex_lock);
 	if (file->f_mode & FMODE_READ) {
 		iter =3D m->private;
-
 		seq_release(inode, file);
 	} else
 		iter =3D file->private_data;
=20
+	mutex_lock(&iter->ops->regex_lock);
+
 	parser =3D &iter->parser;
 	if (trace_parser_loaded(parser)) {
 		parser->buffer[parser->idx] =3D 0;
@@ -3587,7 +3614,7 @@ int ftrace_regex_release(struct inode *inode, struct =
file *file)
 	free_ftrace_hash(iter->hash);
 	kfree(iter);
=20
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&iter->ops->regex_lock);
 	return 0;
 }
=20
@@ -4126,7 +4153,8 @@ void __init ftrace_init(void)
=20
 static struct ftrace_ops global_ops =3D {
 	.func			=3D ftrace_stub,
-	.flags			=3D FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags			=3D FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
+	INIT_REGEX_LOCK(global_ops)
 };
=20
 static int __init ftrace_nodyn_init(void)
@@ -4180,8 +4208,9 @@ ftrace_ops_control_func(unsigned long ip, unsigned lo=
ng parent_ip,
 }
=20
 static struct ftrace_ops control_ops =3D {
-	.func =3D ftrace_ops_control_func,
-	.flags =3D FTRACE_OPS_FL_RECURSION_SAFE,
+	.func	=3D ftrace_ops_control_func,
+	.flags	=3D FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
+	INIT_REGEX_LOCK(control_ops)
 };
=20
 static inline void
@@ -4539,6 +4568,8 @@ int register_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret =3D -1;
=20
+	ftrace_ops_init(ops);
+
 	mutex_lock(&ftrace_lock);
=20
 	ret =3D __register_ftrace_function(ops);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0QAAoJEOdOSU1xswtMMJMH/jZR76SceqVfnLT0EZBtwTak
Mws+gvJtG2VQ+CkiTXjhcuLSDdAtraJeLRWkQ/+R3b77gH9f6DTS2v/JDTXd4PVL
o6ys2q+9lNlcGZq6Lo3/6T/Q9vlrhHGmkoRKHKDn0GrpNP9y709hfjYy/ZDyGVcI
7Ka0LaNeW/p6X7wOhAmhLjdNX4bU7Lr3RbwBLOkC4G8lCsV80wemP9KJNKEDfleS
1+yp7QhQvdkMViB5fGQdg/IUqsRBXd+mdoZz3/iW7cCKkzgYXhdA7CcU1tAkwPbI
0NR+6WfMALq3OjPSobhvy3Utj2z8xk6omSr1h10UbP5y6H78sJTd49vBDLfDi1I=
=A8np
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
