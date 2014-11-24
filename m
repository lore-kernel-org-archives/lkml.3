Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaKXOIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:08:13 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:35559 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKXOIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:08:11 -0500
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: [PATCH] pseries/le: Fix endiannes issue in RTAS call from xmon
Date: Mon, 24 Nov 2014 15:07:53 +0100
Message-Id: <1416838073-16642-1-git-send-email-ldufour@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112414-0017-0000-0000-000001F4B3C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pseries system (LPAR) xmon failed to enter when running in LE mode, system
is hunging. Inititating xmon will lead to such an output on the console:

SysRq : Entering xmon
cpu 0x15: Vector: 0  at [c0000003f39ffb10]
    pc: c00000000007ed7c: sysrq_handle_xmon+0x5c/0x70
    lr: c00000000007ed7c: sysrq_handle_xmon+0x5c/0x70
    sp: c0000003f39ffc70
   msr: 8000000000009033
  current = 0xc0000003fafa7180
  paca    = 0xc000000007d75e80	 softe: 0	 irq_happened: 0x01
    pid   = 14617, comm = bash
Bad kernel stack pointer fafb4b0 at eca7cc4
cpu 0x15: Vector: 300 (Data Access) at [c000000007f07d40]
    pc: 000000000eca7cc4
    lr: 000000000eca7c44
    sp: fafb4b0
   msr: 8000000000001000
   dar: 10000000
 dsisr: 42000000
  current = 0xc0000003fafa7180
  paca    = 0xc000000007d75e80	 softe: 0	 irq_happened: 0x01
    pid   = 14617, comm = bash
cpu 0x15: Exception 300 (Data Access) in xmon, returning to main loop
xmon: WARNING: bad recursive fault on cpu 0x15

The root cause is that xmon is calling RTAS to turn off the surveillance
when entering xmon, and RTAS is requiring big endian parameters.

This patch is byte swapping the RTAS arguments when running in LE mode.

Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
---
 arch/powerpc/xmon/xmon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index b988b5addf86..c8efbb37d6e0 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -293,10 +293,10 @@ static inline void disable_surveillance(void)
 	args.token = rtas_token("set-indicator");
 	if (args.token == RTAS_UNKNOWN_SERVICE)
 		return;
-	args.nargs = 3;
-	args.nret = 1;
+	args.nargs = cpu_to_be32(3);
+	args.nret = cpu_to_be32(1);
 	args.rets = &args.args[3];
-	args.args[0] = SURVEILLANCE_TOKEN;
+	args.args[0] = cpu_to_be32(SURVEILLANCE_TOKEN);
 	args.args[1] = 0;
 	args.args[2] = 0;
 	enter_rtas(__pa(&args));
-- 
1.9.1

