Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbbANLNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:13:47 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:58385 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbbANLNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:13:46 -0500
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc: powernv: winkle: Restore LPCR with LPCR_PECE1 cleared
Date: Wed, 14 Jan 2015 16:43:21 +0530
Message-Id: <1421234001-24886-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011411-0033-0000-0000-00000353B8DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LPCR_PECE1 bit controls whether decrementer interrupts are allowed to
cause exit from power-saving mode. While waking up from winkle, restoring
LPCR with LPCR_PECE1 set (i.e Decrementer interrupts allowed) can cause
issue in the following scenario:

- All the threads in a core are offlined. The core enters deep winkle.
- Spurious interrupt wakes up a thread in the core. Here LPCR is restored
  with LPCR_PECE1 bit set.
- Since it was a spurious interrupt on a offline thread, the thread clears
  the interrupt and goes back to winkle.
- Here before the thread executes winkle and puts the core into deep winkle,
  if a decrementer interrupt occurs on any of the sibling threads in the core
  that thread wakes up. 
- Since in offline loop we are flushing interrupt only in case of external
  interrupt, the decrementer interrupt does not get flushed. So at this stage
  the thread is stuck in this is loop of waking up at 0x100 due to decrementer
  interrupt, not flushing the interrupt as only external interrupts get flushed,
  entering winkle, waking up at 0x100 again.

Fix this by programming PORE to restore LPCR with LPCR_PECE1 bit 
cleared when waking up from winkle.

Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
This issue is separate from the issue which Alexey has reported. Fix for that is
still pending.

 arch/powerpc/platforms/powernv/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index ad0e32e..83067b1 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -298,7 +298,7 @@ int pnv_save_sprs_for_winkle(void)
 	 * all cpus at boot. Get these reg values of current cpu and use the
 	 * same accross all cpus.
 	 */
-	uint64_t lpcr_val = mfspr(SPRN_LPCR);
+	uint64_t lpcr_val = mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1;
 	uint64_t hid0_val = mfspr(SPRN_HID0);
 	uint64_t hid1_val = mfspr(SPRN_HID1);
 	uint64_t hid4_val = mfspr(SPRN_HID4);
-- 
1.9.3

