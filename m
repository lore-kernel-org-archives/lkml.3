Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab3COTy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:54:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab3COTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:26 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ivcsaHrcuZUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3Scp1yBpibIA:10 a=DR8ZsZ700gcnf5cLPPwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=3oVokvLHZYAyUJ6Rd5YA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195123.491404225@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 08/20] ftrace: Clean up function probe methods
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-Clean-up-function-probe-methods.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When a function probe is created, each function that the probe is
attached to, a "callback" method is called. On release of the probe,
each function entry calls the "free" method.

First, "callback" is a confusing name and does not really match what
it does. Callback sounds like it will be called when the probe
triggers. But that's not the case. This is really an "init" function,
so lets rename it as such.

Secondly, both "init" and "free" do not pass enough information back
to the handlers. Pass back the ops, ip and data for each time the
method is called. We have the information, might as well use it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    6 ++++--
 kernel/trace/ftrace.c  |    6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e5ca8ef..832422d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -259,8 +259,10 @@ struct ftrace_probe_ops {
 	void			(*func)(unsigned long ip,
 					unsigned long parent_ip,
 					void **data);
-	int			(*callback)(unsigned long ip, void **data);
-	void			(*free)(void **data);
+	int			(*init)(struct ftrace_probe_ops *ops,
+					unsigned long ip, void **data);
+	void			(*free)(struct ftrace_probe_ops *ops,
+					unsigned long ip, void **data);
 	int			(*print)(struct seq_file *m,
 					 unsigned long ip,
 					 struct ftrace_probe_ops *ops,
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dab031f..ff0ef41 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2984,7 +2984,7 @@ static void ftrace_free_entry_rcu(struct rcu_head *rh=
p)
 		container_of(rhp, struct ftrace_func_probe, rcu);
=20
 	if (entry->ops->free)
-		entry->ops->free(&entry->data);
+		entry->ops->free(entry->ops, entry->ip, &entry->data);
 	kfree(entry);
 }
=20
@@ -3045,8 +3045,8 @@ register_ftrace_function_probe(char *glob, struct ftr=
ace_probe_ops *ops,
 		 * for each function we find. We call the callback
 		 * to give the caller an opportunity to do so.
 		 */
-		if (ops->callback) {
-			if (ops->callback(rec->ip, &entry->data) < 0) {
+		if (ops->init) {
+			if (ops->init(ops, rec->ip, &entry->data) < 0) {
 				/* caller does not like this func */
 				kfree(entry);
 				continue;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u7AAoJEOdOSU1xswtMmGkH/juKUHLFoIjXhkm88Ecf95mg
UwLZyWc9fWYkPRlN1NoVmJveQCakKOm2ID4x4gUgRgTKGKvDaZs2u50Q2ZINHEy2
QdFGgGFyWyvn7d+XYKP99rtomxkLrPPI5TRHop0qi98jRihd7P6iWTPQ25yI497Y
vqGP1HjciCCHvqaqPAW0P7dG0vjpNPMUV+1F0HbBOsoQWnIGx78r7yzt0PeWlGha
zw/20fs+1i7SsD/cBKwIowb6cavp6eZEAu32K0kT8lDCyqHW5cXb42+fwkogV8Vo
Z82oU7gJlRrxBrzG76OpWSb2WBAzwYwta/rY/vHncIzx834gD2GSfnXmulfI1e8=
=IcOv
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
