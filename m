Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3C1Mxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:53:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3C1Mwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:52:34 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=vZbpXfqucBYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=jgXaAB5ElGEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=i0EeH86SAAAA:8 a=SX7KCL8M5pl2nbLml1YA:9 a=QEXdDO2ut3YA:10 a=A3l3GTx6g5AA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=hPjdaMEvmhQA:10 a=8ICCrjR7cQo0XMRI:21 a=g7MzRLwiNyq7MIc6:21 a=RkM3CRNPIHkfQ77RnA4A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130328125232.760699684@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 28 Mar 2013 08:52:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        WANG Chao <chaowang@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 3/3] ftrace: Do not call stub functions in control loop
References: <20130328125214.132479321@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Do-not-call-stub-functions-in-control-loop.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The function tracing control loop used by perf spits out a warning
if the called function is not a control function. This is because
the control function references a per cpu allocated data structure
on struct ftrace_ops that is not allocated for other types of
functions.

commit 0a016409e42 "ftrace: Optimize the function tracer list loop"

Had an optimization done to all function tracing loops to optimize
for a single registered ops. Unfortunately, this allows for a slight
race when tracing starts or ends, where the stub function might be
called after the current registered ops is removed. In this case we
get the following dump:

root# perf stat -e ftrace:function sleep 1
[   74.339105] WARNING: at include/linux/ftrace.h:209 ftrace_ops_control_fu=
nc+0xde/0xf0()
[   74.349522] Hardware name: PRIMERGY RX200 S6
[   74.357149] Modules linked in: sg igb iTCO_wdt ptp pps_core iTCO_vendor_=
support i7core_edac dca lpc_ich i2c_i801 coretemp edac_core crc32c_intel mf=
d_core ghash_clmulni_intel dm_multipath acpi_power_meter pcspk
r microcode vhost_net tun macvtap macvlan nfsd kvm_intel kvm auth_rpcgss nf=
s_acl lockd sunrpc uinput xfs libcrc32c sd_mod crc_t10dif sr_mod cdrom mgag=
200 i2c_algo_bit drm_kms_helper ttm qla2xxx mptsas ahci drm li
bahci scsi_transport_sas mptscsih libata scsi_transport_fc i2c_core mptbase=
 scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
[   74.446233] Pid: 1377, comm: perf Tainted: G        W    3.9.0-rc1 #1
[   74.453458] Call Trace:
[   74.456233]  [<ffffffff81062e3f>] warn_slowpath_common+0x7f/0xc0
[   74.462997]  [<ffffffff810fbc60>] ? rcu_note_context_switch+0xa0/0xa0
[   74.470272]  [<ffffffff811041a2>] ? __unregister_ftrace_function+0xa2/0x=
1a0
[   74.478117]  [<ffffffff81062e9a>] warn_slowpath_null+0x1a/0x20
[   74.484681]  [<ffffffff81102ede>] ftrace_ops_control_func+0xde/0xf0
[   74.491760]  [<ffffffff8162f400>] ftrace_call+0x5/0x2f
[   74.497511]  [<ffffffff8162f400>] ? ftrace_call+0x5/0x2f
[   74.503486]  [<ffffffff8162f400>] ? ftrace_call+0x5/0x2f
[   74.509500]  [<ffffffff810fbc65>] ? synchronize_sched+0x5/0x50
[   74.516088]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
[   74.522268]  [<ffffffff810fbc65>] ? synchronize_sched+0x5/0x50
[   74.528837]  [<ffffffff811041a2>] ? __unregister_ftrace_function+0xa2/0x=
1a0
[   74.536696]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
[   74.542878]  [<ffffffff8162402d>] ? mutex_lock+0x1d/0x50
[   74.548869]  [<ffffffff81105c67>] unregister_ftrace_function+0x27/0x50
[   74.556243]  [<ffffffff8111eadf>] perf_ftrace_event_register+0x9f/0x140
[   74.563709]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
[   74.569887]  [<ffffffff8162402d>] ? mutex_lock+0x1d/0x50
[   74.575898]  [<ffffffff8111e94e>] perf_trace_destroy+0x2e/0x50
[   74.582505]  [<ffffffff81127ba9>] tp_perf_event_destroy+0x9/0x10
[   74.589298]  [<ffffffff811295d0>] free_event+0x70/0x1a0
[   74.595208]  [<ffffffff8112a579>] perf_event_release_kernel+0x69/0xa0
[   74.602460]  [<ffffffff816254d5>] ? _cond_resched+0x5/0x40
[   74.608667]  [<ffffffff8112a640>] put_event+0x90/0xc0
[   74.614373]  [<ffffffff8112a740>] perf_release+0x10/0x20
[   74.620367]  [<ffffffff811a3044>] __fput+0xf4/0x280
[   74.625894]  [<ffffffff811a31de>] ____fput+0xe/0x10
[   74.631387]  [<ffffffff81083697>] task_work_run+0xa7/0xe0
[   74.637452]  [<ffffffff81014981>] do_notify_resume+0x71/0xb0
[   74.643843]  [<ffffffff8162fa92>] int_signal+0x12/0x17

To fix this a new ftrace_ops flag is added that denotes the ftrace_list_end
ftrace_ops stub as just that, a stub. This flag is now checked in the
control loop and the function is not called if the flag is set.

Thanks to Jovi for not just reporting the bug, but also pointing out
where the bug was in the code.

Link: http://lkml.kernel.org/r/514A8855.7090402@redhat.com
Link: http://lkml.kernel.org/r/1364377499-1900-15-git-send-email-jovi.zhang=
wei@huawei.com

Reported-by: WANG Chao <chaowang@redhat.com>
Reported-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    2 ++
 kernel/trace/ftrace.c  |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e5ca8ef..167abf9 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -89,6 +89,7 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned =
long parent_ip,
  *            that the call back has its own recursion protection. If it d=
oes
  *            not set this, then the ftrace infrastructure will add recurs=
ion
  *            protection for the caller.
+ * STUB   - The ftrace_ops is just a place holder.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			=3D 1 << 0,
@@ -98,6 +99,7 @@ enum {
 	FTRACE_OPS_FL_SAVE_REGS			=3D 1 << 4,
 	FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED	=3D 1 << 5,
 	FTRACE_OPS_FL_RECURSION_SAFE		=3D 1 << 6,
+	FTRACE_OPS_FL_STUB			=3D 1 << 7,
 };
=20
 struct ftrace_ops {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cc4943c..7e89710 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -66,7 +66,7 @@
=20
 static struct ftrace_ops ftrace_list_end __read_mostly =3D {
 	.func		=3D ftrace_stub,
-	.flags		=3D FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags		=3D FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_STUB,
 };
=20
 /* ftrace_enabled is a method to turn ftrace on or off */
@@ -4131,7 +4131,8 @@ ftrace_ops_control_func(unsigned long ip, unsigned lo=
ng parent_ip,
 	preempt_disable_notrace();
 	trace_recursion_set(TRACE_CONTROL_BIT);
 	do_for_each_ftrace_op(op, ftrace_control_list) {
-		if (!ftrace_function_local_disabled(op) &&
+		if (!(op->flags & FTRACE_OPS_FL_STUB) &&
+		    !ftrace_function_local_disabled(op) &&
 		    ftrace_ops_test(op, ip))
 			op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRVD0QAAoJEOdOSU1xswtM6OYIAKP+4WcMJnPCxMcMkLtoRXfh
Op7PrYbPzhILj5xFMcgzppGNkjYykI03aK87J8f6Ka5Uc1j3keZOveIw2vsqsG/L
bSa+DlRERapZsoqGtYxt+Vx9yAUEWy799hXKrUYcm/83/5c5pY2Upw9KLLYHA/F5
HbKmTTtt1o0LZqDke/UaxCWZgVDPWv7MO5GzIZOe46nGRj2EUu+5U1+YtQnshNKx
d2dhDCtWXIoLNpRpF0YIipFIi7nIxc2ymtfuO5lFuip5wp0JXDo62aRBKtEEb73v
5zH3/0VdX3AEe8iAnLRFmrtEztmQ+YfH879wH6EzfOFx+8223lLeoUgZxogDTow=
=U0zq
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
