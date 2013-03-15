Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3COTyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:54:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab3COTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:26 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=guyCOh2Yuq4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PbW-_u9AgwYA:10 a=QkVQ0ZFHCCHtdhyH1GIA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Rhe1xRMX558Nhtpn:21 a=xpD5dui0MVuGsmnu:21 a=18UkYpfgWqeSIxeOdmoA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195123.090834565@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 06/20] tracing: Add snapshot trigger to function probes
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Add-snapshot-trigger-to-function-probes.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

 echo 'schedule:snapshot:1' > /debug/tracing/set_ftrace_filter

This will cause the scheduler to trigger a snapshot the next time
it's called (you can use any function that's not called by NMI).

Even though it triggers only once, you still need to remove it with:

 echo '!schedule:snapshot:0' > /debug/tracing/set_ftrace_filter

The :1 can be left off for the first command:

 echo 'schedule:snapshot' > /debug/tracing/set_ftrace_filter

But this will cause all calls to schedule to trigger a snapshot.
This must be removed without the ':0'

 echo '!schedule:snapshot' > /debug/tracing/set_ftrace_filter

As adding a "count" is a different operation (internally).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |  111 ++++++++++++++++++++++++++++++++++++++++++++++=
+++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 906049c..c5b8446 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5086,7 +5086,114 @@ static const struct file_operations tracing_dyn_inf=
o_fops =3D {
 	.read		=3D tracing_read_dyn_info,
 	.llseek		=3D generic_file_llseek,
 };
-#endif
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
+#if defined(CONFIG_TRACER_SNAPSHOT) && defined(CONFIG_DYNAMIC_FTRACE)
+static void
+ftrace_snapshot(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	tracing_snapshot();
+}
+
+static void
+ftrace_count_snapshot(unsigned long ip, unsigned long parent_ip, void **da=
ta)
+{
+	unsigned long *count =3D (long *)data;
+
+	if (!*count)
+		return;
+
+	if (*count !=3D -1)
+		(*count)--;
+
+	tracing_snapshot();
+}
+
+static int
+ftrace_snapshot_print(struct seq_file *m, unsigned long ip,
+		      struct ftrace_probe_ops *ops, void *data)
+{
+	long count =3D (long)data;
+
+	seq_printf(m, "%ps:", (void *)ip);
+
+	seq_printf(m, "snapshot");
+
+	if (count =3D=3D -1)
+		seq_printf(m, ":unlimited\n");
+	else
+		seq_printf(m, ":count=3D%ld\n", count);
+
+	return 0;
+}
+
+static struct ftrace_probe_ops snapshot_probe_ops =3D {
+	.func			=3D ftrace_snapshot,
+	.print			=3D ftrace_snapshot_print,
+};
+
+static struct ftrace_probe_ops snapshot_count_probe_ops =3D {
+	.func			=3D ftrace_count_snapshot,
+	.print			=3D ftrace_snapshot_print,
+};
+
+static int
+ftrace_trace_snapshot_callback(struct ftrace_hash *hash,
+			       char *glob, char *cmd, char *param, int enable)
+{
+	struct ftrace_probe_ops *ops;
+	void *count =3D (void *)-1;
+	char *number;
+	int ret;
+
+	/* hash funcs only work with set_ftrace_filter */
+	if (!enable)
+		return -EINVAL;
+
+	ops =3D param ? &snapshot_count_probe_ops :  &snapshot_probe_ops;
+
+	if (glob[0] =3D=3D '!') {
+		unregister_ftrace_function_probe_func(glob+1, ops);
+		return 0;
+	}
+
+	if (!param)
+		goto out_reg;
+
+	number =3D strsep(&param, ":");
+
+	if (!strlen(number))
+		goto out_reg;
+
+	/*
+	 * We use the callback data field (which is a pointer)
+	 * as our counter.
+	 */
+	ret =3D kstrtoul(number, 0, (unsigned long *)&count);
+	if (ret)
+		return ret;
+
+ out_reg:
+	ret =3D register_ftrace_function_probe(glob, ops, count);
+
+	if (ret >=3D 0)
+		alloc_snapshot(&global_trace);
+
+	return ret < 0 ? ret : 0;
+}
+
+static struct ftrace_func_command ftrace_snapshot_cmd =3D {
+	.name			=3D "snapshot",
+	.func			=3D ftrace_trace_snapshot_callback,
+};
+
+static int register_snapshot_cmd(void)
+{
+	return register_ftrace_command(&ftrace_snapshot_cmd);
+}
+#else
+static inline int register_snapshot_cmd(void) { return 0; }
+#endif /* defined(CONFIG_TRACER_SNAPSHOT) && defined(CONFIG_DYNAMIC_FTRACE=
) */
=20
 struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
 {
@@ -6076,6 +6183,8 @@ __init static int tracer_alloc_buffers(void)
 		trace_set_options(&global_trace, option);
 	}
=20
+	register_snapshot_cmd();
+
 	return 0;
=20
 out_free_cpumask:
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u7AAoJEOdOSU1xswtMXBkH/1yuqabTrF02HhrgUtfugRyv
xFii2HdJ0IsDT+axls4grsXPoWD8demRxz9TjRodhvQhsgbGbKbxp4Ih7MTP8yHZ
Q0RhQ/nOIU3d0XlAoC/uN6v5QRouN0CEqrXO85/Lrnd4EQnlhiSe9lER9aIc1i9G
+GZO3s7xFrRQEhM3VHEPI1RLZgvi8gTT00UDHfaXOMNPomlrtQDqeFOPm9l6od7u
w3HsLxd5JKqagkNyBjgQfSsyaTtfwUPEYDODx+kGmwYqE+z6Kyi3+uCiRc8TmO7t
q+a4yIdOQvFZ95rHdn0NrKoy2gYBR7gSWI2en5i8MTB/pLYHbRVzRB4HI8h7nUw=
=oqFS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
