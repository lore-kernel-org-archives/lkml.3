Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3COTxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:53:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18130 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab3COTv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:27 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=MAVrf0i2zKgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QZHP1AdjtUwA:10 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=D-kCI3Pid-mGlK6KmnwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=7DSvI1NPTFQA:10 a=sA9wab0uyux7C8yj:21 a=AVJ_VHyoWzXDlgNC:21 a=SgFX7rVqX0xF5XTBfiAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195124.096013444@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 11/20] tracing: Add function probe triggers to enable/disable events
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-Add-function-probe-triggers-to-enable-disabl.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add triggers to function tracer that lets an event get enabled or
disabled when a function is called:

format is:

 <function>:enable_event:<system>:<event>[:<count>]
 <function>:disable_event:<system>:<event>[:<count>]

 echo 'schedule:enable_event:sched:sched_switch' > /debug/tracing/set_ftrac=
e_filter

Every time schedule is called, it will enable the sched_switch event.

 echo 'schedule:disable_event:sched:sched_switch:2' > /debug/tracing/set_ft=
race_filter

The first two times schedule is called while the sched_switch
event is enabled, it will disable it. It will not count for a time
that the event is already disabled (or enabled for enable_event).

[ fixed return without mutex_unlock() - thanks to Dan Carpenter and smatch ]

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |  279 +++++++++++++++++++++++++++++++++++++++=
++++
 1 file changed, 279 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 106640b..c636523 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1798,6 +1798,283 @@ __trace_add_event_dirs(struct trace_array *tr)
 	}
 }
=20
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+/* Avoid typos */
+#define ENABLE_EVENT_STR	"enable_event"
+#define DISABLE_EVENT_STR	"disable_event"
+
+struct event_probe_data {
+	struct ftrace_event_file	*file;
+	unsigned long			count;
+	int				ref;
+	bool				enable;
+};
+
+static struct ftrace_event_file *
+find_event_file(struct trace_array *tr, const char *system,  const char *e=
vent)
+{
+	struct ftrace_event_file *file;
+	struct ftrace_event_call *call;
+
+	list_for_each_entry(file, &tr->events, list) {
+
+		call =3D file->event_call;
+
+		if (!call->name || !call->class || !call->class->reg)
+			continue;
+
+		if (call->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
+			continue;
+
+		if (strcmp(event, call->name) =3D=3D 0 &&
+		    strcmp(system, call->class->system) =3D=3D 0)
+			return file;
+	}
+	return NULL;
+}
+
+static void
+event_enable_probe(unsigned long ip, unsigned long parent_ip, void **_data)
+{
+	struct event_probe_data **pdata =3D (struct event_probe_data **)_data;
+	struct event_probe_data *data =3D *pdata;
+
+	if (!data)
+		return;
+
+	if (data->enable)
+		clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &data->file->flags);
+	else
+		set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &data->file->flags);
+}
+
+static void
+event_enable_count_probe(unsigned long ip, unsigned long parent_ip, void *=
*_data)
+{
+	struct event_probe_data **pdata =3D (struct event_probe_data **)_data;
+	struct event_probe_data *data =3D *pdata;
+
+	if (!data)
+		return;
+
+	if (!data->count)
+		return;
+
+	/* Skip if the event is in a state we want to switch to */
+	if (data->enable =3D=3D !(data->file->flags & FTRACE_EVENT_FL_SOFT_DISABL=
ED))
+		return;
+
+	if (data->count !=3D -1)
+		(data->count)--;
+
+	event_enable_probe(ip, parent_ip, _data);
+}
+
+static int
+event_enable_print(struct seq_file *m, unsigned long ip,
+		      struct ftrace_probe_ops *ops, void *_data)
+{
+	struct event_probe_data *data =3D _data;
+
+	seq_printf(m, "%ps:", (void *)ip);
+
+	seq_printf(m, "%s:%s:%s",
+		   data->enable ? ENABLE_EVENT_STR : DISABLE_EVENT_STR,
+		   data->file->event_call->class->system,
+		   data->file->event_call->name);
+
+	if (data->count =3D=3D -1)
+		seq_printf(m, ":unlimited\n");
+	else
+		seq_printf(m, ":count=3D%ld\n", data->count);
+
+	return 0;
+}
+
+static int
+event_enable_init(struct ftrace_probe_ops *ops, unsigned long ip,
+		  void **_data)
+{
+	struct event_probe_data **pdata =3D (struct event_probe_data **)_data;
+	struct event_probe_data *data =3D *pdata;
+
+	data->ref++;
+	return 0;
+}
+
+static void
+event_enable_free(struct ftrace_probe_ops *ops, unsigned long ip,
+		  void **_data)
+{
+	struct event_probe_data **pdata =3D (struct event_probe_data **)_data;
+	struct event_probe_data *data =3D *pdata;
+
+	if (WARN_ON_ONCE(data->ref <=3D 0))
+		return;
+
+	data->ref--;
+	if (!data->ref) {
+		/* Remove the SOFT_MODE flag */
+		__ftrace_event_enable_disable(data->file, 0, 1);
+		module_put(data->file->event_call->mod);
+		kfree(data);
+	}
+	*pdata =3D NULL;
+}
+
+static struct ftrace_probe_ops event_enable_probe_ops =3D {
+	.func			=3D event_enable_probe,
+	.print			=3D event_enable_print,
+	.init			=3D event_enable_init,
+	.free			=3D event_enable_free,
+};
+
+static struct ftrace_probe_ops event_enable_count_probe_ops =3D {
+	.func			=3D event_enable_count_probe,
+	.print			=3D event_enable_print,
+	.init			=3D event_enable_init,
+	.free			=3D event_enable_free,
+};
+
+static struct ftrace_probe_ops event_disable_probe_ops =3D {
+	.func			=3D event_enable_probe,
+	.print			=3D event_enable_print,
+	.init			=3D event_enable_init,
+	.free			=3D event_enable_free,
+};
+
+static struct ftrace_probe_ops event_disable_count_probe_ops =3D {
+	.func			=3D event_enable_count_probe,
+	.print			=3D event_enable_print,
+	.init			=3D event_enable_init,
+	.free			=3D event_enable_free,
+};
+
+static int
+event_enable_func(struct ftrace_hash *hash,
+		  char *glob, char *cmd, char *param, int enabled)
+{
+	struct trace_array *tr =3D top_trace_array();
+	struct ftrace_event_file *file;
+	struct ftrace_probe_ops *ops;
+	struct event_probe_data *data;
+	const char *system;
+	const char *event;
+	char *number;
+	bool enable;
+	int ret;
+
+	/* hash funcs only work with set_ftrace_filter */
+	if (!enabled)
+		return -EINVAL;
+
+	if (!param)
+		return -EINVAL;
+
+	system =3D strsep(&param, ":");
+	if (!param)
+		return -EINVAL;
+
+	event =3D strsep(&param, ":");
+
+	mutex_lock(&event_mutex);
+
+	ret =3D -EINVAL;
+	file =3D find_event_file(tr, system, event);
+	if (!file)
+		goto out;
+
+	enable =3D strcmp(cmd, ENABLE_EVENT_STR) =3D=3D 0;
+
+	if (enable)
+		ops =3D param ? &event_enable_count_probe_ops : &event_enable_probe_ops;
+	else
+		ops =3D param ? &event_disable_count_probe_ops : &event_disable_probe_op=
s;
+
+	if (glob[0] =3D=3D '!') {
+		unregister_ftrace_function_probe_func(glob+1, ops);
+		ret =3D 0;
+		goto out;
+	}
+
+	ret =3D -ENOMEM;
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto out;
+
+	data->enable =3D enable;
+	data->count =3D -1;
+	data->file =3D file;
+
+	if (!param)
+		goto out_reg;
+
+	number =3D strsep(&param, ":");
+
+	ret =3D -EINVAL;
+	if (!strlen(number))
+		goto out_free;
+
+	/*
+	 * We use the callback data field (which is a pointer)
+	 * as our counter.
+	 */
+	ret =3D kstrtoul(number, 0, &data->count);
+	if (ret)
+		goto out_free;
+
+ out_reg:
+	/* Don't let event modules unload while probe registered */
+	ret =3D try_module_get(file->event_call->mod);
+	if (!ret)
+		goto out_free;
+
+	ret =3D __ftrace_event_enable_disable(file, 1, 1);
+	if (ret < 0)
+		goto out_put;
+	ret =3D register_ftrace_function_probe(glob, ops, data);
+	if (!ret)
+		goto out_disable;
+ out:
+	mutex_unlock(&event_mutex);
+	return ret;
+
+ out_disable:
+	__ftrace_event_enable_disable(file, 0, 1);
+ out_put:
+	module_put(file->event_call->mod);
+ out_free:
+	kfree(data);
+	goto out;
+}
+
+static struct ftrace_func_command event_enable_cmd =3D {
+	.name			=3D ENABLE_EVENT_STR,
+	.func			=3D event_enable_func,
+};
+
+static struct ftrace_func_command event_disable_cmd =3D {
+	.name			=3D DISABLE_EVENT_STR,
+	.func			=3D event_enable_func,
+};
+
+static __init int register_event_cmds(void)
+{
+	int ret;
+
+	ret =3D register_ftrace_command(&event_enable_cmd);
+	if (WARN_ON(ret < 0))
+		return ret;
+	ret =3D register_ftrace_command(&event_disable_cmd);
+	if (WARN_ON(ret < 0))
+		unregister_ftrace_command(&event_enable_cmd);
+	return ret;
+}
+#else
+static inline int register_event_cmds(void) { return 0; }
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
 /*
  * The top level array has already had its ftrace_event_file
  * descriptors created in order to allow for early events to
@@ -2058,6 +2335,8 @@ static __init int event_trace_enable(void)
=20
 	trace_printk_start_comm();
=20
+	register_event_cmds();
+
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

iQEcBAABAgAGBQJRQ3u8AAoJEOdOSU1xswtMBPAH/2gClc0oG05dzf0Eyk38//yl
n56F36OsYekAd3jKtXQ0EB3S4YuibMTMttDxcFbRgvSsgqPqTbMV+p9j+nwWGl/o
+ZrOUj1ckRAnqkHLzJC1D1jcOTvRa5OkpNAGszQk8RfQYoo6ve+Ppsf+fRG3SJ3h
uWwci/fBUuvo/uAY2NNOyq89MmODAYtA7flweLcBCtIMmG54j0EqKP7jfD5YB9ES
ZzcF8H4/BCSAbAG3OHdvabaBEfHf5mbHTHLCgzPDNqMEVikM/LXM2KtEjSZt6OBI
p9GKfCmJlAd68Bzqvq5cv6+PCRPFt4N0oEFR2t5GnKpKkuZAeJLfyGiam7M5YDY=
=fQPh
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
