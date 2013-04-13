Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3DMBFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:05:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3DMBFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:05:23 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wk65mRlzAhQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Bhp-1FuhGr8A:10 a=VwQbUJbxAAAA:8 a=3UeHfSxsNViFs_tAKc0A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=iOuhc7qaRq6JXDKHfIAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130413010522.110794313@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Apr 2013 21:01:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 2/2] ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE
 section
References: <20130413010121.658707789@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Move-ftrace_filter_lseek-out-of-CONFIG_DYNAMI.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As ftrace_filter_lseek is now used with ftrace_pid_fops, it needs to
be moved out of the #ifdef CONFIG_DYNAMIC_FTRACE section as the
ftrace_pid_fops is defined when DYNAMIC_FTRACE is not.

Cc: stable@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    3 ++-
 kernel/trace/ftrace.c  |   28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index eb3ce32..52da2a2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -396,7 +396,6 @@ ssize_t ftrace_filter_write(struct file *file, const ch=
ar __user *ubuf,
 			    size_t cnt, loff_t *ppos);
 ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos);
-loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
 int ftrace_regex_release(struct inode *inode, struct file *file);
=20
 void __init
@@ -569,6 +568,8 @@ static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENO=
DEV; }
 #endif /* CONFIG_DYNAMIC_FTRACE */
=20
+loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
+
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
=20
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index affc35d..2461ede 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1052,6 +1052,19 @@ static __init void ftrace_profile_debugfs(struct den=
try *d_tracer)
=20
 static struct pid * const ftrace_swapper_pid =3D &init_struct_pid;
=20
+loff_t
+ftrace_filter_lseek(struct file *file, loff_t offset, int whence)
+{
+	loff_t ret;
+
+	if (file->f_mode & FMODE_READ)
+		ret =3D seq_lseek(file, offset, whence);
+	else
+		file->f_pos =3D ret =3D 1;
+
+	return ret;
+}
+
 #ifdef CONFIG_DYNAMIC_FTRACE
=20
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
@@ -2612,7 +2625,7 @@ static void ftrace_filter_reset(struct ftrace_hash *h=
ash)
  * routine, you can use ftrace_filter_write() for the write
  * routine if @flag has FTRACE_ITER_FILTER set, or
  * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
- * ftrace_regex_lseek() should be used as the lseek routine, and
+ * ftrace_filter_lseek() should be used as the lseek routine, and
  * release must call ftrace_regex_release().
  */
 int
@@ -2696,19 +2709,6 @@ ftrace_notrace_open(struct inode *inode, struct file=
 *file)
 				 inode, file);
 }
=20
-loff_t
-ftrace_filter_lseek(struct file *file, loff_t offset, int whence)
-{
-	loff_t ret;
-
-	if (file->f_mode & FMODE_READ)
-		ret =3D seq_lseek(file, offset, whence);
-	else
-		file->f_pos =3D ret =3D 1;
-
-	return ret;
-}
-
 static int ftrace_match(char *str, char *regex, int len, int type)
 {
 	int matched =3D 0;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRaK9SAAoJEOdOSU1xswtMZ3gH/2aikqBV9w/XDPc2hqdOZvpE
LDUhv42FtA0O1hG1jH/gqy1M3m2Cv8CLU3ZDtE6QKYtfwENInIj0++j/w750lHf7
V0VbGUiKF7rnYvA2796UkJo4i+LagGhAlY1AQ0Jph8i1y/Ef4s3Ki+vzLTvEX45X
SnCv/otKQI4syl/0dHX3giJBHfdHWNoSP5X/9AHXS2yY4fNqTml8l29jHkq9EUTx
EPYrHij1k94GKjAUolqHyR38t1qSTYFmZ/JNnL2WVj7PbOaRKxTy469eiLxA3PEV
fPsa+XHLdYjPRAysubwKCF3h1ocm0sa9RfT8KSv7Q/pLXbS2AeQh2m/I+ENOlw4=
=m6l3
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
