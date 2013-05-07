Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab3EGJQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:16:42 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40163 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759277Ab3EGJQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:16:40 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] powerpc,
 cpu hotplug: Fix warning on boot regarding sysfs file permission
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: anton@samba.org, paulus@samba.org, gregkh@linuxfoundation.org,
        balbi@ti.com, caiqian@redhat.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 07 May 2013 14:43:34 +0530
Message-ID: <20130507091309.12448.70498.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050709-1618-0000-0000-000003D65328
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On boot, the following warning shows up on each CPU online operation:

------------[ cut here ]------------
WARNING: at drivers/base/core.c:575
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.9.0+ #2
task: c0000006fa180000 ti: c0000006fa200000 task.ti: c0000006fa200000
NIP: c00000000053772c LR: c000000000537728 CTR: 0000000001764c5c
REGS: c0000006fa203780 TRAP: 0700   Tainted: G        W     (3.9.0+)
MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28000024  XER: 00000002
SOFTE: 1
CFAR: c0000000008a6994

GPR00: c000000000537728 c0000006fa203a00 c000000000dafaf0 0000000000000020
GPR04: 0000000000000001 c000000000085d9c 0000000000000000 0000000000000002
GPR08: 0000000000000000 c0000006fa180000 c0000006fa180000 c000000000e38804
GPR12: 0000000000000000 c000000001db0000 c00000000000c1b0 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000001 c000000000e44880
GPR20: c000000000e44d18 c000000000c726a8 0000000000000000 0000000000000000
GPR24: c000000000bab158 000000000000007e c000000000e68200 c000000000c71d48
GPR28: c0000000130c0030 0000000000000002 c0000000130c0030 c000000000c71f58
NIP [c00000000053772c] .device_create_file+0xac/0xc0
LR [c000000000537728] .device_create_file+0xa8/0xc0
PACATMSCRATCH [8000000000009032]
Call Trace:
[c0000006fa203a00] [c000000000537728] .device_create_file+0xa8/0xc0 (unreliable)
[c0000006fa203a80] [c00000000089f3e4] .register_cpu_online+0x10c/0x238
[c0000006fa203b30] [c000000000bc9a80] .topology_init+0x1fc/0x200
[c0000006fa203c10] [c00000000000b870] .do_one_initcall+0x60/0x1e0
[c0000006fa203cd0] [c000000000bc3fc0] .kernel_init_freeable+0x22c/0x310
[c0000006fa203da0] [c00000000000c1cc] .kernel_init+0x1c/0x1c0
[c0000006fa203e30] [c00000000000a170] .ret_from_kernel_thread+0x64/0x74
Instruction dump:
0fe00000 4bffffb8 60000000 60000000 60000000 e8040028 2fa00000 409eff98
3c62ffd6 3863dc38 4836f221 60000000 <0fe00000> a13f0008 4bffff7c 60000000
---[ end trace b53dfda141d62ab0 ]---


The problem is that the 'spurr' per-cpu sysfs file sports a write permission
without the corresponding ->store() method. So remove the bogus write
permission to fix the warning.

Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 3ce1f86..e68a845 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -180,7 +180,7 @@ SYSFS_PMCSETUP(dscr, SPRN_DSCR);
 SYSFS_PMCSETUP(pir, SPRN_PIR);
 
 static DEVICE_ATTR(mmcra, 0600, show_mmcra, store_mmcra);
-static DEVICE_ATTR(spurr, 0600, show_spurr, NULL);
+static DEVICE_ATTR(spurr, 0400, show_spurr, NULL);
 static DEVICE_ATTR(dscr, 0600, show_dscr, store_dscr);
 static DEVICE_ATTR(purr, 0600, show_purr, store_purr);
 static DEVICE_ATTR(pir, 0400, show_pir, NULL);

