Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab3EKANk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab3EKANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:08 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=iNH6TstXJI4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=M2FGH1moP0UA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8 a=ifT7fkunrjl449NR0vQA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=DyuLy3qMzzeDj8h8iWIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001306.342933921@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 16/18] tracing/kprobes: Pass trace_probe directly from dispatcher
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0016-tracing-kprobes-Pass-trace_probe-directly-from-dispa.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Pass the pointer of struct trace_probe directly from probe
dispatcher to handlers. This removes redundant container_of
macro uses. Same thing has already done in trace_uprobe.

Link: http://lkml.kernel.org/r/20130509054441.30398.69112.stgit@mhiramat-M0=
-7522

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 6e86fbb..9ca44fc 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -723,9 +723,9 @@ static __kprobes void store_trace_args(int ent_size, st=
ruct trace_probe *tp,
 }
=20
 /* Kprobe handler */
-static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs =
*regs)
+static __kprobes void
+kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 {
-	struct trace_probe *tp =3D container_of(kp, struct trace_probe, rp.kp);
 	struct kprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
@@ -745,7 +745,7 @@ static __kprobes void kprobe_trace_func(struct kprobe *=
kp, struct pt_regs *regs)
 		return;
=20
 	entry =3D ring_buffer_event_data(event);
-	entry->ip =3D (unsigned long)kp->addr;
+	entry->ip =3D (unsigned long)tp->rp.kp.addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
=20
 	if (!filter_current_check_discard(buffer, call, entry, event))
@@ -754,10 +754,10 @@ static __kprobes void kprobe_trace_func(struct kprobe=
 *kp, struct pt_regs *regs)
 }
=20
 /* Kretprobe handler */
-static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
-					  struct pt_regs *regs)
+static __kprobes void
+kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+		     struct pt_regs *regs)
 {
-	struct trace_probe *tp =3D container_of(ri->rp, struct trace_probe, rp);
 	struct kretprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
@@ -973,10 +973,9 @@ static int set_print_fmt(struct trace_probe *tp)
 #ifdef CONFIG_PERF_EVENTS
=20
 /* Kprobe profile handler */
-static __kprobes void kprobe_perf_func(struct kprobe *kp,
-					 struct pt_regs *regs)
+static __kprobes void
+kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 {
-	struct trace_probe *tp =3D container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call =3D &tp->call;
 	struct kprobe_trace_entry_head *entry;
 	struct hlist_head *head;
@@ -995,7 +994,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *k=
p,
 	if (!entry)
 		return;
=20
-	entry->ip =3D (unsigned long)kp->addr;
+	entry->ip =3D (unsigned long)tp->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
=20
@@ -1005,10 +1004,10 @@ static __kprobes void kprobe_perf_func(struct kprob=
e *kp,
 }
=20
 /* Kretprobe profile handler */
-static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
-					    struct pt_regs *regs)
+static __kprobes void
+kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+		    struct pt_regs *regs)
 {
-	struct trace_probe *tp =3D container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call =3D &tp->call;
 	struct kretprobe_trace_entry_head *entry;
 	struct hlist_head *head;
@@ -1074,10 +1073,10 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_=
regs *regs)
 	tp->nhit++;
=20
 	if (tp->flags & TP_FLAG_TRACE)
-		kprobe_trace_func(kp, regs);
+		kprobe_trace_func(tp, regs);
 #ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
-		kprobe_perf_func(kp, regs);
+		kprobe_perf_func(tp, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
@@ -1090,10 +1089,10 @@ int kretprobe_dispatcher(struct kretprobe_instance =
*ri, struct pt_regs *regs)
 	tp->nhit++;
=20
 	if (tp->flags & TP_FLAG_TRACE)
-		kretprobe_trace_func(ri, regs);
+		kretprobe_trace_func(tp, ri, regs);
 #ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
-		kretprobe_perf_func(ri, regs);
+		kretprobe_perf_func(tp, ri, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0SAAoJEOdOSU1xswtM910H/0UAERTWYJYwNO+7PomTNWnC
TCb/U4cY4D7PCWGonuRC2EXsb9cZxQKCWKQVyW3+cYxK+pWYamita9GTvXGMsNt2
/kRow95Mt7blgG6FFIVKChzCzuoyqkuUlhQ57dCemg+Nt4wMlRQ4KcTc6RrrjBBb
tzmeQ9+aISAU7MHJ1l7IcYlR7gZOmSFhyrzqYU6jRf/ysrIQ8S5JupHFmlwXxD/3
9PPeBw55xyiBqrBhpTbW5kRKuGR/xOENuJ7JqCoRUrvb2fNgpi7yo2kz4zb7xZnL
9nyH98l5+GhpXZu3H0xagDUzu3Q9TY83ZezLt57nePCCK4PGO+qNJRtEDsU9e5I=
=xP48
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
