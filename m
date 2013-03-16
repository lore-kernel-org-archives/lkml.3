Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab3CPDcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:32:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3CPDbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:31:45 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1P36UJWDmIkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=p7yrIiBiWhUA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=aC7ebmpEPab3e4CML2AA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=wudEcauMuK7Qg8RuvvUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130316033142.800679553@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 23:24:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 4/9] tracing: Move find_event_field() into trace_events.c
References: <20130316032412.416651612@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Move-find_event_field-into-trace_events.c.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

By moving find_event_field() and trace_find_field() into trace_events.c,
the ftrace_common_fields list and trace_get_fields() can become local to
the trace_events.c file.

find_event_field() is renamed to trace_find_event_field() to conform to
the tracing global function names.

Link: http://lkml.kernel.org/r/513D8426.9070109@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
[ rostedt: Modified trace_find_field() to trace_find_event_field() ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |    6 ++----
 kernel/trace/trace_events.c        |   31 +++++++++++++++++++++++++++++--
 kernel/trace/trace_events_filter.c |   29 +----------------------------
 3 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5cc5236..9e01458 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -995,8 +995,6 @@ struct filter_pred {
 	unsigned short		right;
 };
=20
-extern struct list_head ftrace_common_fields;
-
 extern enum regex_type
 filter_parse_regex(char *buff, int len, char **search, int *not);
 extern void print_event_filter(struct ftrace_event_call *call,
@@ -1009,8 +1007,8 @@ extern void print_subsystem_event_filter(struct event=
_subsystem *system,
 					 struct trace_seq *s);
 extern int filter_assign_type(const char *type);
=20
-struct list_head *
-trace_get_fields(struct ftrace_event_call *event_call);
+struct ftrace_event_field *
+trace_find_event_field(struct ftrace_event_call *call, char *name);
=20
 static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c636523..ba523d7 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -34,7 +34,7 @@ char event_storage[EVENT_STORAGE_SIZE];
 EXPORT_SYMBOL_GPL(event_storage);
=20
 LIST_HEAD(ftrace_events);
-LIST_HEAD(ftrace_common_fields);
+static LIST_HEAD(ftrace_common_fields);
=20
 #define GFP_TRACE (GFP_KERNEL | __GFP_ZERO)
=20
@@ -54,7 +54,7 @@ static struct kmem_cache *file_cachep;
 #define while_for_each_event_file()		\
 	}
=20
-struct list_head *
+static struct list_head *
 trace_get_fields(struct ftrace_event_call *event_call)
 {
 	if (!event_call->class->get_fields)
@@ -62,6 +62,33 @@ trace_get_fields(struct ftrace_event_call *event_call)
 	return event_call->class->get_fields(event_call);
 }
=20
+static struct ftrace_event_field *
+__find_event_field(struct list_head *head, char *name)
+{
+	struct ftrace_event_field *field;
+
+	list_for_each_entry(field, head, link) {
+		if (!strcmp(field->name, name))
+			return field;
+	}
+
+	return NULL;
+}
+
+struct ftrace_event_field *
+trace_find_event_field(struct ftrace_event_call *call, char *name)
+{
+	struct ftrace_event_field *field;
+	struct list_head *head;
+
+	field =3D __find_event_field(&ftrace_common_fields, name);
+	if (field)
+		return field;
+
+	head =3D trace_get_fields(call);
+	return __find_event_field(head, name);
+}
+
 static int __trace_define_field(struct list_head *head, const char *type,
 				const char *name, int offset, int size,
 				int is_signed, int filter_type)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 2a22a17..a636117 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -658,33 +658,6 @@ void print_subsystem_event_filter(struct event_subsyst=
em *system,
 	mutex_unlock(&event_mutex);
 }
=20
-static struct ftrace_event_field *
-__find_event_field(struct list_head *head, char *name)
-{
-	struct ftrace_event_field *field;
-
-	list_for_each_entry(field, head, link) {
-		if (!strcmp(field->name, name))
-			return field;
-	}
-
-	return NULL;
-}
-
-static struct ftrace_event_field *
-find_event_field(struct ftrace_event_call *call, char *name)
-{
-	struct ftrace_event_field *field;
-	struct list_head *head;
-
-	field =3D __find_event_field(&ftrace_common_fields, name);
-	if (field)
-		return field;
-
-	head =3D trace_get_fields(call);
-	return __find_event_field(head, name);
-}
-
 static int __alloc_pred_stack(struct pred_stack *stack, int n_preds)
 {
 	stack->preds =3D kcalloc(n_preds + 1, sizeof(*stack->preds), GFP_KERNEL);
@@ -1337,7 +1310,7 @@ static struct filter_pred *create_pred(struct filter_=
parse_state *ps,
 		return NULL;
 	}
=20
-	field =3D find_event_field(call, operand1);
+	field =3D trace_find_event_field(call, operand1);
 	if (!field) {
 		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
 		return NULL;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ+eeAAoJEOdOSU1xswtMD48IAMJPhPDOJY5sSK9Z/si+EkJ6
sGnsAH2dCGus1lB0h8eqIDFmTC6TukMpH+1PY00kEDxPV5V/OsgEoppn2bw9JmoN
6FP9h1/J8vfJW7RHqwcVRXCP+nRA8pq6+XI/nePKHLoCcyhWxoUNhqbNZ2EZ6kgS
KWEfMrB2GyJMN+9WaI1vt2b2AsvP9ZunEkU/RfZG1DJxBN8b+esCxQ4xQk4ztMPA
ulShoQGcb1UrT//2e1Lo2M1/GueXfgRfBQeoe2KoKHhAQwb/zguyy3zCSKAaMxQ3
WvbfplGLZ1kcrwizoM6Fiv5EKVD4V6Lzr/LbxZrCfKaHbyQzopiW13Xe9eML/yg=
=Ox8W
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
