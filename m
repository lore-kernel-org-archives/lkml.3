Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3KYN67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:58:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58962 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207Ab3KYNx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Helge Deller" <deller@gmx.de>,
        "John David Anglin" <dave.anglin@bell.net>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.304391692@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 78/87] parisc: Do not crash 64bit SMP kernels on
 machines with >= 4GB RAM
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 54e181e073fc1415e41917d725ebdbd7de956455 upstream.

Since the beginning of the parisc-linux port, sometimes 64bit SMP kernels were
not able to bring up other CPUs than the monarch CPU and instead crashed the
kernel.  The reason was unclear, esp. since it involved various machines (e.g.
J5600, J6750 and SuperDome). Testing showed, that those crashes didn't happened
when less than 4GB were installed, or if a 32bit Linux kernel was booted.

In the end, the fix for those SMP problems is trivial:
During the early phase of the initialization of the CPUs, including the monarch
CPU, the PDC_PSW firmware function to enable WIDE (=64bit) mode is called.
It's documented that this firmware function may clobber various registers, and
one one of those possibly clobbered registers is %cr30 which holds the task
thread info pointer.

Now, if %cr30 would always have been clobbered, then this bug would have been
detected much earlier. But lots of testing finally showed, that - at least for
%cr30 - on some machines only the upper 32bits of the 64bit register suddenly
turned zero after the firmware call.

So, after finding the root cause, the explanation for the various crashes
became clear:
- On 32bit SMP Linux kernels all upper 32bit were zero, so we didn't faced this
  problem.
- Monarch CPUs in 64bit mode always booted sucessfully, because the inital task
  thread info pointer was below 4GB.
- Secondary CPUs booted sucessfully on machines with less than 4GB RAM because
  the upper 32bit were zero anyay.
- Secondary CPus failed to boot if we had more than 4GB RAM and the task thread
  info pointer was located above the 4GB boundary.

Finally, the patch to fix this problem is trivial by saving the %cr30 register
before the firmware call and restoring it afterwards.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/parisc/kernel/head.S | 4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -195,6 +195,8 @@ common_stext:
 	ldw             MEM_PDC_HI(%r0),%r6
 	depd            %r6, 31, 32, %r3        /* move to upper word */
 
+	mfctl		%cr30,%r6		/* PCX-W2 firmware bug */
+
 	ldo             PDC_PSW(%r0),%arg0              /* 21 */
 	ldo             PDC_PSW_SET_DEFAULTS(%r0),%arg1 /* 2 */
 	ldo             PDC_PSW_WIDE_BIT(%r0),%arg2     /* 2 */
@@ -203,6 +205,8 @@ common_stext:
 	copy            %r0,%arg3
 
 stext_pdc_ret:
+	mtctl		%r6,%cr30		/* restore task thread info */
+
 	/* restore rfi target address*/
 	ldd             TI_TASK-THREAD_SZ_ALGN(%sp), %r10
 	tophys_r1       %r10

