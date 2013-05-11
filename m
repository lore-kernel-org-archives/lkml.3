Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3EKANn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab3EKANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:08 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ELTCBBmTTAUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KxIaNyeQzdYA:10 a=S7UMQHTi64V0ODw8fqIA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=bgPr4fBqn2ms_cata0kA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001305.698613784@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 13/18] ftrace: Fix function probe when more than one probe is added
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0013-ftrace-Fix-function-probe-when-more-than-one-probe-i.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When the first function probe is added and the function tracer
is updated the functions are modified to call the probe.
But when a second function is added, it updates the function
records to have the second function also update, but it fails
to update the actual function itself.

This prevents the second (or third or forth and so on) probes
from having their functions called.

  # echo vfs_symlink:enable_event:sched:sched_switch > set_ftrace_filter
  # echo vfs_unlink:enable_event:sched:sched_switch > set_ftrace_filter
  # cat trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 0/0   #P:4
 #
 #                              _-----=3D> irqs-off
 #                             / _----=3D> need-resched
 #                            | / _---=3D> hardirq/softirq
 #                            || / _--=3D> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
  # touch /tmp/a
  # rm /tmp/a
  # cat trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 0/0   #P:4
 #
 #                              _-----=3D> irqs-off
 #                             / _----=3D> need-resched
 #                            | / _---=3D> hardirq/softirq
 #                            || / _--=3D> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
  # ln -s /tmp/a
  # cat trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 414/414   #P:4
 #
 #                              _-----=3D> irqs-off
 #                             / _----=3D> need-resched
 #                            | / _---=3D> hardirq/softirq
 #                            || / _--=3D> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
           <idle>-0     [000] d..3  2847.923031: sched_switch: prev_comm=3D=
swapper/0 prev_pid=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=3Db=
ash next_pid=3D2786 next_prio=3D120
            <...>-3114  [001] d..4  2847.923035: sched_switch: prev_comm=3D=
ln prev_pid=3D3114 prev_prio=3D120 prev_state=3Dx =3D=3D> next_comm=3Dswapp=
er/1 next_pid=3D0 next_prio=3D120
             bash-2786  [000] d..3  2847.923535: sched_switch: prev_comm=3D=
bash prev_pid=3D2786 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=3Dkwo=
rker/0:1 next_pid=3D34 next_prio=3D120
      kworker/0:1-34    [000] d..3  2847.923552: sched_switch: prev_comm=3D=
kworker/0:1 prev_pid=3D34 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=
=3Dswapper/0 next_pid=3D0 next_prio=3D120
           <idle>-0     [002] d..3  2847.923554: sched_switch: prev_comm=3D=
swapper/2 prev_pid=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=3Ds=
shd next_pid=3D2783 next_prio=3D120
             sshd-2783  [002] d..3  2847.923660: sched_switch: prev_comm=3D=
sshd prev_pid=3D2783 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=3Dswa=
pper/2 next_pid=3D0 next_prio=3D120

Still need to update the functions even though the probe itself
does not need to be registered again when added a new probe.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dcca9fa..b549b0f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2941,8 +2941,12 @@ static void __enable_ftrace_function_probe(void)
 	int ret;
 	int i;
=20
-	if (ftrace_probe_registered)
+	if (ftrace_probe_registered) {
+		/* still need to update the function call sites */
+		if (ftrace_enabled)
+			ftrace_run_update_code(FTRACE_UPDATE_CALLS);
 		return;
+	}
=20
 	for (i =3D 0; i < FTRACE_FUNC_HASHSIZE; i++) {
 		struct hlist_head *hhd =3D &ftrace_func_hash[i];
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0RAAoJEOdOSU1xswtM9N0H/R6O8ILdAJn35eOyZIyjHoH2
rUMbnNbW1k1OftiO6RQOKJvvqNP7rBWVmhFJfYGH/gcVuP5fWVKndZ20vlQSA2kX
F5SOjxARggv+u8jHIWCV67AYcZMtVmUjf9i1YNsrDIQPZLDhB9yYtjYVVKZUgaP/
y4X49/+WLhgtSr+rrTP1IV1sTXAFI/Iu4Zca8JP5wWoHpdCErPBL0gN74EBDugfQ
u0Zcj6jvgQ927eEl+wr9AHc6HXgleTX2qhW6dIDeUOC1hagu43FRi9MIUxjFPzHo
T4tZiWQbpkabWwCfh5pMVuWIaoTjuk/MDA2UxQf0ISDY98UVO1xdqcaITyoyZs8=
=2bAr
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
