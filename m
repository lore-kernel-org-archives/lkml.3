Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3AVDXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:23:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14436 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3AVDX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:23:29 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Mm8Plurcn3wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=RrjXrWizF48A:10 a=6zb38KopAAAA:8 a=BrdBRmpAAAAA:8 a=K-ynY7izSh-etmQf95gA:9 a=PUjeQqilurYA:10 a=D-PNlr3aaKoA:10 a=jeBq3FmKZ4MA:10 a=_nrB4aULUHVNFIkN:21 a=OVZeZHkmQR7SXxcC:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358825006.21576.47.camel@gandalf.local.home>
Subject: [PATCH] powerpc/pasemi: Fix crash on reboot
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>
Date: Mon, 21 Jan 2013 22:23:26 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f96972f2dc "kernel/sys.c: call disable_nonboot_cpus() in
kernel_restart()"

added a call to disable_nonboot_cpus() on kernel_restart(), which tries
to shutdown all the CPUs except the first one. The issue with the PA
Semi, is that it does not support CPU hotplug.

When the call is made to __cpu_down(), it calls the notifiers
CPU_DOWN_PREPARE, and then tries to take the CPU down.

One of the notifiers to the CPU hotplug code, is the cpufreq. The
DOWN_PREPARE will call __cpufreq_remove_dev() which calls
cpufreq_driver->exit. The PA Semi exit handler unmaps regions of I/O
that is used by an interrupt that goes off constantly
(system_reset_common, but it goes off during normal system operations
too). I'm not sure exactly what this interrupt does.

Running a simple function trace, you can see it goes off quite a bit:

# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
          <idle>-0     [001]  1558.859363: .pasemi_system_reset_exception <-.system_reset_exception
          <idle>-0     [000]  1558.860112: .pasemi_system_reset_exception <-.system_reset_exception
          <idle>-0     [000]  1558.861109: .pasemi_system_reset_exception <-.system_reset_exception
          <idle>-0     [001]  1558.861361: .pasemi_system_reset_exception <-.system_reset_exception
          <idle>-0     [000]  1558.861437: .pasemi_system_reset_exception <-.system_reset_exception

When the region is unmapped, the system crashes with:

Disabling non-boot CPUs ...
Error taking CPU1 down: -38
Unable to handle kernel paging request for data at address 0xd0000800903a0100
Faulting instruction address: 0xc000000000055fcc
Oops: Kernel access of bad area, sig: 11 [#1]
PREEMPT SMP NR_CPUS=64 NUMA PA Semi PWRficient
Modules linked in: shpchp
NIP: c000000000055fcc LR: c000000000055fb4 CTR: c0000000000df1fc
REGS: c0000000012175d0 TRAP: 0300   Not tainted  (3.8.0-rc4-test-dirty)
MSR: 9000000000009032 <SF,HV,EE,ME,IR,DR,RI>  CR: 24000088  XER: 00000000
SOFTE: 0
DAR: d0000800903a0100, DSISR: 42000000
TASK = c0000000010e9008[0] 'swapper/0' THREAD: c000000001214000 CPU: 0
GPR00: d0000800903a0000 c000000001217850 c0000000012167e0 0000000000000000 
GPR04: 0000000000000000 0000000000000724 0000000000000724 0000000000000000 
GPR08: 0000000000000000 0000000000000000 0000000000000001 0000000000a70000 
GPR12: 0000000024000080 c00000000fff0000 ffffffffffffffff 000000003ffffae0 
GPR16: ffffffffffffffff 0000000000a21198 0000000000000060 0000000000000000 
GPR20: 00000000008fdd35 0000000000a21258 000000003ffffaf0 0000000000000417 
GPR24: 0000000000a226d0 c000000000000000 0000000000000000 0000000000000000 
GPR28: c00000000138b358 0000000000000000 c000000001144818 d0000800903a0100 
NIP [c000000000055fcc] .set_astate+0x5c/0xa4
LR [c000000000055fb4] .set_astate+0x44/0xa4
Call Trace:
[c000000001217850] [c000000000055fb4] .set_astate+0x44/0xa4 (unreliable)
[c0000000012178f0] [c00000000005647c] .restore_astate+0x2c/0x34
[c000000001217980] [c000000000054668] .pasemi_system_reset_exception+0x6c/0x88
[c000000001217a00] [c000000000019ef0] .system_reset_exception+0x48/0x84
[c000000001217a80] [c000000000001e40] system_reset_common+0x140/0x180
--- Exception: 100 at sleep_common+0x48/0x5c
    LR = sleep_common+0x48/0x5c
[c000000001217d70] [c0000000000546c0] sleep_common+0x14/0x5c (unreliable)
[c000000001217db0] [c000000000013a04] .cpu_idle+0x114/0x244
[c000000001217e50] [c00000000000ae64] .rest_init+0xa0/0xac
[c000000001217ee0] [c0000000009e0940] .start_kernel+0x45c/0x464
[c000000001217f90] [c000000000009868] .start_here_common+0x20/0x38
Instruction dump:
419e0070 38000000 8bad021a 980d021a 57ff6026 480a4f99 60000000 7fff07b4 
e81c0000 3bff0100 7fe0fa14 7c0004ac <7f60fd2c> 2fbd0000 38000001 980d021c 
---[ end trace ff87239238ef747b ]---

Non-boot CPUs are not disabled


Apparently, unmapping that region of memory is not a good idea.

As it seems that the exit handler is required in case of error at boot
up, it doesn't make sense to allow it to unmap the region after the
system is running.

Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/powerpc/platforms/pasemi/cpufreq.c b/arch/powerpc/platforms/pasemi/cpufreq.c
index 95d0017..890f30e 100644
--- a/arch/powerpc/platforms/pasemi/cpufreq.c
+++ b/arch/powerpc/platforms/pasemi/cpufreq.c
@@ -236,6 +236,13 @@ out:
 
 static int pas_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 {
+	/*
+	 * We don't support CPU hotplug. Don't unmap after the system
+	 * has already made it to a running state.
+	 */
+	if (system_state != SYSTEM_BOOTING)
+		return 0;
+
 	if (sdcasr_mapbase)
 		iounmap(sdcasr_mapbase);
 	if (sdcpwr_mapbase)


