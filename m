Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab3DMBFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:05:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab3DMBFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:05:23 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=YVKZjJvMSZMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ZP9kFTNP1vcA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=lnjDsGjtaArq365pIfUA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=KZCNIQ4M42o_z6lkoV4A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130413010521.895741390@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Apr 2013 21:01:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, <stable@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/2] tracing: Fix possible NULL pointer dereferences
References: <20130413010121.658707789@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-possible-NULL-pointer-dereferences.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Namhyung Kim <namhyung.kim@lge.com>

Currently set_ftrace_pid and set_graph_function files use seq_lseek
for their fops.  However seq_open() is called only for FMODE_READ in
the fops->open() so that if an user tries to seek one of those file
when she open it for writing, it sees NULL seq_file and then panic.

It can be easily reproduced with following command:

  $ cd /sys/kernel/debug/tracing
  $ echo 1234 | sudo tee -a set_ftrace_pid

In this example, GNU coreutils' tee opens the file with fopen(, "a")
and then the fopen() internally calls lseek().

Link: http://lkml.kernel.org/r/1365663302-2170-1-git-send-email-namhyung@ke=
rnel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h     |    2 +-
 kernel/trace/ftrace.c      |   10 +++++-----
 kernel/trace/trace_stack.c |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 167abf9..eb3ce32 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -396,7 +396,7 @@ ssize_t ftrace_filter_write(struct file *file, const ch=
ar __user *ubuf,
 			    size_t cnt, loff_t *ppos);
 ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos);
-loff_t ftrace_regex_lseek(struct file *file, loff_t offset, int whence);
+loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
 int ftrace_regex_release(struct inode *inode, struct file *file);
=20
 void __init
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 926ebfb..affc35d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2697,7 +2697,7 @@ ftrace_notrace_open(struct inode *inode, struct file =
*file)
 }
=20
 loff_t
-ftrace_regex_lseek(struct file *file, loff_t offset, int whence)
+ftrace_filter_lseek(struct file *file, loff_t offset, int whence)
 {
 	loff_t ret;
=20
@@ -3570,7 +3570,7 @@ static const struct file_operations ftrace_filter_fop=
s =3D {
 	.open =3D ftrace_filter_open,
 	.read =3D seq_read,
 	.write =3D ftrace_filter_write,
-	.llseek =3D ftrace_regex_lseek,
+	.llseek =3D ftrace_filter_lseek,
 	.release =3D ftrace_regex_release,
 };
=20
@@ -3578,7 +3578,7 @@ static const struct file_operations ftrace_notrace_fo=
ps =3D {
 	.open =3D ftrace_notrace_open,
 	.read =3D seq_read,
 	.write =3D ftrace_notrace_write,
-	.llseek =3D ftrace_regex_lseek,
+	.llseek =3D ftrace_filter_lseek,
 	.release =3D ftrace_regex_release,
 };
=20
@@ -3783,8 +3783,8 @@ static const struct file_operations ftrace_graph_fops=
 =3D {
 	.open		=3D ftrace_graph_open,
 	.read		=3D seq_read,
 	.write		=3D ftrace_graph_write,
+	.llseek		=3D ftrace_filter_lseek,
 	.release	=3D ftrace_graph_release,
-	.llseek		=3D seq_lseek,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
=20
@@ -4439,7 +4439,7 @@ static const struct file_operations ftrace_pid_fops =
=3D {
 	.open		=3D ftrace_pid_open,
 	.write		=3D ftrace_pid_write,
 	.read		=3D seq_read,
-	.llseek		=3D seq_lseek,
+	.llseek		=3D ftrace_filter_lseek,
 	.release	=3D ftrace_pid_release,
 };
=20
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 42ca822..83a8b5b 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -322,7 +322,7 @@ static const struct file_operations stack_trace_filter_=
fops =3D {
 	.open =3D stack_trace_filter_open,
 	.read =3D seq_read,
 	.write =3D ftrace_filter_write,
-	.llseek =3D ftrace_regex_lseek,
+	.llseek =3D ftrace_filter_lseek,
 	.release =3D ftrace_regex_release,
 };
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRaK9RAAoJEOdOSU1xswtMQaAH/0wiu1Ofje6fLSy5ew7z6F1U
AesRIB8ujPWJ3SEm845vzbpH5w6wV+nFGbL7MEd9XzAm1Ku8wf0Hh/Jxfdn1PgnT
ee8tG21o8vGBE9QYAUAQEDamhnUSbu6HPLKAj9OJBHxlKmkdpTMWBRLo2z1VWcL7
wEW/diVcMQCAVzLxv0SiRl0AljvKweTCQtpaKLHTAMK9AG1EeYN2Q9qnuXX1dzoX
V8HF1a0OEjCag94yTDlgR7H97kzcY3A6Rf+wLSNMl09E2sfWWMtY60xr/Ng3Cs7E
+Q1B12BcIc70f8WfDbHlRbpQy4XwEQ5aiLcQD73gTPSAx+uC7ZdbdtcQ+AMG7U4=
=gC/G
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
