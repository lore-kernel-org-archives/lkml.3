Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab3COTzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:55:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab3COTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:26 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JP022jk4P9cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=0WPqNNFPD2kA:10 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=-X0QEFTSqc3jGzQ7ngcA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=7DSvI1NPTFQA:10 a=MVqWu5Xp-pxdh7hSTyUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195123.872190653@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 10/20] tracing: Add a way to soft disable trace events
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Add-a-way-to-soft-disable-trace-events.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In order to let triggers enable or disable events, we need a 'soft'
method for doing so. For example, if a function probe is added that
lets a user enable or disable events when a function is called, that
change must be done without taking locks or a mutex, and definitely
it can't sleep. But the full enabling of a tracepoint is expensive.

By adding a 'SOFT_DISABLE' flag, and converting the flags to be updated
without the protection of a mutex (using set/clear_bit()), this soft
disable flag can be used to allow critical sections to enable or disable
events from being traced (after the event has been placed into "SOFT_MODE").

Some caveats though: The comm recorder (to map pids with a comm) can not
be soft disabled (yet). If you disable an event with with a "soft"
disable and wait a while before reading the trace, the comm cache may be
replaced and you'll get a bunch of <...> for comms in the trace.

Reading the "enable" file for an event that is disabled will now give
you "0*" where the '*' denotes that the tracepoint is still active but
the event itself is "disabled".

[ fixed _BIT used in & operation : thanks to Dan Carpenter and smatch ]

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |   20 +++++++----
 include/trace/ftrace.h       |    8 +++++
 kernel/trace/trace_events.c  |   75 ++++++++++++++++++++++++++++++++++----=
----
 3 files changed, 84 insertions(+), 19 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4cb6cd8..4e28b01 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -251,16 +251,23 @@ struct ftrace_subsystem_dir;
 enum {
 	FTRACE_EVENT_FL_ENABLED_BIT,
 	FTRACE_EVENT_FL_RECORDED_CMD_BIT,
+	FTRACE_EVENT_FL_SOFT_MODE_BIT,
+	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
 };
=20
 /*
  * Ftrace event file flags:
  *  ENABLED	  - The event is enabled
  *  RECORDED_CMD  - The comms should be recorded at sched_switch
+ *  SOFT_MODE     - The event is enabled/disabled by SOFT_DISABLED
+ *  SOFT_DISABLED - When set, do not trace the event (even though its
+ *                   tracepoint may be enabled)
  */
 enum {
 	FTRACE_EVENT_FL_ENABLED		=3D (1 << FTRACE_EVENT_FL_ENABLED_BIT),
 	FTRACE_EVENT_FL_RECORDED_CMD	=3D (1 << FTRACE_EVENT_FL_RECORDED_CMD_BIT),
+	FTRACE_EVENT_FL_SOFT_MODE	=3D (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
+	FTRACE_EVENT_FL_SOFT_DISABLED	=3D (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT=
),
 };
=20
 struct ftrace_event_file {
@@ -274,17 +281,18 @@ struct ftrace_event_file {
 	 * 32 bit flags:
 	 *   bit 0:		enabled
 	 *   bit 1:		enabled cmd record
+	 *   bit 2:		enable/disable with the soft disable bit
+	 *   bit 3:		soft disabled
 	 *
-	 * Changes to flags must hold the event_mutex.
-	 *
-	 * Note: Reads of flags do not hold the event_mutex since
-	 * they occur in critical sections. But the way flags
+	 * Note: The bits must be set atomically to prevent races
+	 * from other writers. Reads of flags do not need to be in
+	 * sync as they occur in critical sections. But the way flags
 	 * is currently used, these changes do not affect the code
 	 * except that when a change is made, it may have a slight
 	 * delay in propagating the changes to other CPUs due to
-	 * caching and such.
+	 * caching and such. Which is mostly OK ;-)
 	 */
-	unsigned int		flags;
+	unsigned long		flags;
 };
=20
 #define __TRACE_EVENT_FLAGS(name, value)				\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index bbf09c2..4bda044 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -413,6 +413,10 @@ static inline notrace int ftrace_get_offsets_##call(		=
	\
  *	int __data_size;
  *	int pc;
  *
+ *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+ *		     &ftrace_file->flags))
+ *		return;
+ *
  *	local_save_flags(irq_flags);
  *	pc =3D preempt_count();
  *
@@ -518,6 +522,10 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	int __data_size;						\
 	int pc;								\
 									\
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
+		     &ftrace_file->flags))				\
+		return;							\
+									\
 	local_save_flags(irq_flags);					\
 	pc =3D preempt_count();						\
 									\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 38b54c5..106640b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -205,37 +205,77 @@ void trace_event_enable_cmd_record(bool enable)
=20
 		if (enable) {
 			tracing_start_cmdline_record();
-			file->flags |=3D FTRACE_EVENT_FL_RECORDED_CMD;
+			set_bit(FTRACE_EVENT_FL_RECORDED_CMD_BIT, &file->flags);
 		} else {
 			tracing_stop_cmdline_record();
-			file->flags &=3D ~FTRACE_EVENT_FL_RECORDED_CMD;
+			clear_bit(FTRACE_EVENT_FL_RECORDED_CMD_BIT, &file->flags);
 		}
 	} while_for_each_event_file();
 	mutex_unlock(&event_mutex);
 }
=20
-static int ftrace_event_enable_disable(struct ftrace_event_file *file,
-				       int enable)
+static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
+					 int enable, int soft_disable)
 {
 	struct ftrace_event_call *call =3D file->event_call;
 	int ret =3D 0;
+	int disable;
=20
 	switch (enable) {
 	case 0:
-		if (file->flags & FTRACE_EVENT_FL_ENABLED) {
-			file->flags &=3D ~FTRACE_EVENT_FL_ENABLED;
+		/*
+		 * When soft_disable is set and enable is cleared, we want
+		 * to clear the SOFT_DISABLED flag but leave the event in the
+		 * state that it was. That is, if the event was enabled and
+		 * SOFT_DISABLED isn't set, then do nothing. But if SOFT_DISABLED
+		 * is set we do not want the event to be enabled before we
+		 * clear the bit.
+		 *
+		 * When soft_disable is not set but the SOFT_MODE flag is,
+		 * we do nothing. Do not disable the tracepoint, otherwise
+		 * "soft enable"s (clearing the SOFT_DISABLED bit) wont work.
+		 */
+		if (soft_disable) {
+			disable =3D file->flags & FTRACE_EVENT_FL_SOFT_DISABLED;
+			clear_bit(FTRACE_EVENT_FL_SOFT_MODE_BIT, &file->flags);
+		} else
+			disable =3D !(file->flags & FTRACE_EVENT_FL_SOFT_MODE);
+
+		if (disable && (file->flags & FTRACE_EVENT_FL_ENABLED)) {
+			clear_bit(FTRACE_EVENT_FL_ENABLED_BIT, &file->flags);
 			if (file->flags & FTRACE_EVENT_FL_RECORDED_CMD) {
 				tracing_stop_cmdline_record();
-				file->flags &=3D ~FTRACE_EVENT_FL_RECORDED_CMD;
+				clear_bit(FTRACE_EVENT_FL_RECORDED_CMD_BIT, &file->flags);
 			}
 			call->class->reg(call, TRACE_REG_UNREGISTER, file);
 		}
+		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT */
+		if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
+			set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
 		break;
 	case 1:
+		/*
+		 * When soft_disable is set and enable is set, we want to
+		 * register the tracepoint for the event, but leave the event
+		 * as is. That means, if the event was already enabled, we do
+		 * nothing (but set SOFT_MODE). If the event is disabled, we
+		 * set SOFT_DISABLED before enabling the event tracepoint, so
+		 * it still seems to be disabled.
+		 */
+		if (!soft_disable)
+			clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
+		else
+			set_bit(FTRACE_EVENT_FL_SOFT_MODE_BIT, &file->flags);
+
 		if (!(file->flags & FTRACE_EVENT_FL_ENABLED)) {
+
+			/* Keep the event disabled, when going to SOFT_MODE. */
+			if (soft_disable)
+				set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
+
 			if (trace_flags & TRACE_ITER_RECORD_CMD) {
 				tracing_start_cmdline_record();
-				file->flags |=3D FTRACE_EVENT_FL_RECORDED_CMD;
+				set_bit(FTRACE_EVENT_FL_RECORDED_CMD_BIT, &file->flags);
 			}
 			ret =3D call->class->reg(call, TRACE_REG_REGISTER, file);
 			if (ret) {
@@ -244,7 +284,7 @@ static int ftrace_event_enable_disable(struct ftrace_ev=
ent_file *file,
 					"%s\n", call->name);
 				break;
 			}
-			file->flags |=3D FTRACE_EVENT_FL_ENABLED;
+			set_bit(FTRACE_EVENT_FL_ENABLED_BIT, &file->flags);
=20
 			/* WAS_ENABLED gets set but never cleared. */
 			call->flags |=3D TRACE_EVENT_FL_WAS_ENABLED;
@@ -255,6 +295,12 @@ static int ftrace_event_enable_disable(struct ftrace_e=
vent_file *file,
 	return ret;
 }
=20
+static int ftrace_event_enable_disable(struct ftrace_event_file *file,
+				       int enable)
+{
+	return __ftrace_event_enable_disable(file, enable, 0);
+}
+
 static void ftrace_clear_events(struct trace_array *tr)
 {
 	struct ftrace_event_file *file;
@@ -547,12 +593,15 @@ event_enable_read(struct file *filp, char __user *ubu=
f, size_t cnt,
 	struct ftrace_event_file *file =3D filp->private_data;
 	char *buf;
=20
-	if (file->flags & FTRACE_EVENT_FL_ENABLED)
-		buf =3D "1\n";
-	else
+	if (file->flags & FTRACE_EVENT_FL_ENABLED) {
+		if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED)
+			buf =3D "0*\n";
+		else
+			buf =3D "1\n";
+	} else
 		buf =3D "0\n";
=20
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, strlen(buf));
 }
=20
 static ssize_t
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u7AAoJEOdOSU1xswtMtysIAKo/3h2R05MR1D03D4y6QTV6
Bud9C5AwmFeFWlLo4eprD1myAU2HojYKSGDRTEajPoCW7PHXjzjj/SZMIlgAtOx/
Gn7dj/tOyZY4yftiRnNJD5ngTdrWchpf5jqmque8SSGmMwDsvXil9j1f4cOmKNiu
iJscvSOpeGFZTRNT9afe+qEEDcB5YT75cTXMItyHsq3omvwTHDcX50hE73ocH40V
Ybv7GjLNH0V9nb2a+0WXigZnv0cpHHQ2m8x6jUbKRP1fw4Fj9kPfu+If2nVkVvE5
1dylNSMi+014Ub8A6yv/M5f85deidI5FxbsEn8G5WqVMKJCWPcLpV/4ht76rlcg=
=17kb
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
