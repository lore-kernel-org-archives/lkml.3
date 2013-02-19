Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab3BSEQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:16:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6032 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab3BSEQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:16:29 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=iL1adxwYTm4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Lxf30LvEQakA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=G9VPskNYu0SCEvPzM8MA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=7J9cklMP6d1Ld0iT:21 a=y_IKELCwyd3jV2Wm:21 a=IRKj3sAhuN4jkqMK_RUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219041627.626424073@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 18 Feb 2013 23:15:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 2/2] ftrace: Call ftrace cleanup module notifier after all other
 notifiers
References: <20130219041554.221170392@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Call-ftrace-cleanup-module-notifier-after-all.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit: c1bf08ac "ftrace: Be first to run code modification on modules"

changed ftrace module notifier's priority to INT_MAX in order to
process the ftrace nops before anything else could touch them
(namely kprobes). This was the correct thing to do.

Unfortunately, the ftrace module notifier also contains the ftrace
clean up code. As opposed to the set up code, this code should be
run *after* all the module notifiers have run in case a module is doing
correct clean-up and unregisters its ftrace hooks. Basically, ftrace
needs to do clean up on module removal, as it needs to know about code
being removed so that it doesn't try to modify that code. But after it
removes the module from its records, if a ftrace user tries to remove
a probe, that removal will fail due as the record of that code segment
no longer exists.

Nothing really bad happens if the probe removal is called after ftrace
did the clean up, but the ftrace removal function will return an error.
Correct code (such as kprobes) will produce a WARN_ON() if it fails
to remove the probe. As people get annoyed by frivolous warnings, it's
best to do the ftrace clean up after everything else.

By splitting the ftrace_module_notifier into two notifiers, one that
does the module load setup that is run at high priority, and the other
that is called for module clean up that is run at low priority, the
problem is solved.

Cc: stable@vger.kernel.org
Reported-by: Frank Ch. Eigler <fche@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ce8c3d6..98ca94a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3996,37 +3996,51 @@ static void ftrace_init_module(struct module *mod,
 	ftrace_process_locs(mod, start, end);
 }
=20
-static int ftrace_module_notify(struct notifier_block *self,
-				unsigned long val, void *data)
+static int ftrace_module_notify_enter(struct notifier_block *self,
+				      unsigned long val, void *data)
 {
 	struct module *mod =3D data;
=20
-	switch (val) {
-	case MODULE_STATE_COMING:
+	if (val =3D=3D MODULE_STATE_COMING)
 		ftrace_init_module(mod, mod->ftrace_callsites,
 				   mod->ftrace_callsites +
 				   mod->num_ftrace_callsites);
-		break;
-	case MODULE_STATE_GOING:
+	return 0;
+}
+
+static int ftrace_module_notify_exit(struct notifier_block *self,
+				     unsigned long val, void *data)
+{
+	struct module *mod =3D data;
+
+	if (val =3D=3D MODULE_STATE_GOING)
 		ftrace_release_mod(mod);
-		break;
-	}
=20
 	return 0;
 }
 #else
-static int ftrace_module_notify(struct notifier_block *self,
-				unsigned long val, void *data)
+static int ftrace_module_notify_enter(struct notifier_block *self,
+				      unsigned long val, void *data)
+{
+	return 0;
+}
+static int ftrace_module_notify_exit(struct notifier_block *self,
+				     unsigned long val, void *data)
 {
 	return 0;
 }
 #endif /* CONFIG_MODULES */
=20
-struct notifier_block ftrace_module_nb =3D {
-	.notifier_call =3D ftrace_module_notify,
+struct notifier_block ftrace_module_enter_nb =3D {
+	.notifier_call =3D ftrace_module_notify_enter,
 	.priority =3D INT_MAX,	/* Run before anything that can use kprobes */
 };
=20
+struct notifier_block ftrace_module_exit_nb =3D {
+	.notifier_call =3D ftrace_module_notify_exit,
+	.priority =3D INT_MIN,	/* Run after anything that can remove kprobes */
+};
+
 extern unsigned long __start_mcount_loc[];
 extern unsigned long __stop_mcount_loc[];
=20
@@ -4058,9 +4072,13 @@ void __init ftrace_init(void)
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
=20
-	ret =3D register_module_notifier(&ftrace_module_nb);
+	ret =3D register_module_notifier(&ftrace_module_enter_nb);
+	if (ret)
+		pr_warning("Failed to register trace ftrace module enter notifier\n");
+
+	ret =3D register_module_notifier(&ftrace_module_exit_nb);
 	if (ret)
-		pr_warning("Failed to register trace ftrace module notifier\n");
+		pr_warning("Failed to register trace ftrace module exit notifier\n");
=20
 	set_ftrace_early_filters();
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRIvybAAoJEOdOSU1xswtM3jQIAKil+A4dOczsshuVkeG8j9bZ
qDS42BJ9U4yVZErtfP/RgAgK6vvhIW9L1lhOC8jfdMAL/kJuKHvy2OwF3IyxeM+o
g1phxSvvyX00w1kkl303jRv6fN0TvRsDZIfrAUxVigdbCjyCwQpLe5YANoSmWHmk
UMN28kd1/a+C/RCtYmxEYMI1RSnmX/DsrurhyatMIHnPpH8LRNmW7gLx5KhX8OWX
OTpaB4/ZjVPbqFsLFUTrOt0M6pQYHU591N/GAWhTFOD5jTNxYnab6vhkOPrFSI4j
nzwPmGaoqF1BobOdhfRQTP+oBozdcbGLbliEYctN/Rr0j4H9ZCmx7wG/rWZOVdA=
=q/9z
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
