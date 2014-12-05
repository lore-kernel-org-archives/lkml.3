Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaLEXYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:24:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaLEW4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.14 31/73] powerpc/pseries: Fix endiannes issue in RTAS call from xmon
Date: Fri,  5 Dec 2014 14:44:37 -0800
Message-Id: <20141205224434.875070774@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Dufour <ldufour@linux.vnet.ibm.com>

commit 3b8a3c01096925a824ed3272601082289d9c23a5 upstream.

On pseries system (LPAR) xmon failed to enter when running in LE mode,
system is hunging. Inititating xmon will lead to such an output on the
console:

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
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/xmon/xmon.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -288,10 +288,10 @@ static inline void disable_surveillance(
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


