Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaGBDyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 23:54:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52775 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaGBDy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 23:54:29 -0400
Subject: [PATCH V3] powerpc/powernv: Check for IRQHAPPENED before sleeping
To: benh@kernel.crashing.org, mikey@neuling.org, mpe@ellerman.id.au
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: shreyas@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Jul 2014 09:19:35 +0530
Message-ID: <20140702034811.2956.30873.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070203-3532-0000-0000-000002DF1839
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8d6f7c5a: "powerpc/powernv: Make it possible to skip the IRQHAPPENED
check in power7_nap()" added code that prevents cpus from checking for
pending interrupts just before entering sleep state, which is wrong. These
interrupts are delivered during the soft irq disabled state of the cpu.

A cpu cannot enter any idle state with pending interrupts because they will
never be serviced until the next time the cpu is woken up by some other
interrupt. Its only then that the pending interrupts are replayed. This can result
in device timeouts or warnings about this cpu being stuck.

This patch fixes ths issue by ensuring that cpus check for pending interrupts
just before entering any idle state as long as they are not in the path of split
core operations.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
Chanes in V2: https://lkml.org/lkml/2014/7/1/3
Modified the changelog to add the details of the problem that this patch
fixes

Changes in V3:
V2 assumed that this patch would be useful only in the context of doorbell
ipis. But that is not true; this patch is required to correctly handle any
type of interrupt delivered in the idle enter path.


 arch/powerpc/kernel/idle_power7.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
index 2480256..5cf3d36 100644
--- a/arch/powerpc/kernel/idle_power7.S
+++ b/arch/powerpc/kernel/idle_power7.S
@@ -131,7 +131,7 @@ _GLOBAL(power7_nap)
 
 _GLOBAL(power7_sleep)
 	li	r3,1
-	li	r4,0
+	li	r4,1
 	b	power7_powersave_common
 	/* No return */
 

