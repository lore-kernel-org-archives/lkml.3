Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaCFGRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:17:44 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:45407 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbaCFGRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:17:43 -0500
From: Tony Lu <zlu@tilera.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chris Metcalf <cmetcalf@tilera.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lu <zlu@tilera.com>
Subject: [PATCH 2/4] tile: Enable NMIs on return from handle_nmi() without
 errors
Thread-Topic: [PATCH 2/4] tile: Enable NMIs on return from handle_nmi()
 without errors
Thread-Index: Ac85A8H6L7BVmmzDSZmNaWV+kLNGKw==
Date: Thu, 6 Mar 2014 06:17:31 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C5D67FF29@USMAExch1.tad.internal.tilera.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NMI interrupts mask ALL interrupts before calling the handler,
so we need to unmask NMIs according to the value handle_nmi() returns.
If it returns zero, the NMIs should be re-enabled; if it returns
a non-zero error, the NMIs should be disabled.

Signed-off-by: Zhigang Lu <zlu@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S | 11 +++++++++++
 arch/tile/kernel/intvec_64.S | 11 ++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 605ffbd..cdbda45 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -946,6 +946,13 @@ STD_ENTRY(interrupt_return)
 	bzt     r30, .Lrestore_regs
 3:
 
+	/* We are relying on INT_PERF_COUNT at 33, and AUX_PERF_COUNT at 48 */
+	{
+	 moveli r0, lo16(1 << (INT_PERF_COUNT - 32))
+	 bz     r31, .Lrestore_regs
+	}
+	auli    r0, r0, ha16(1 << (INT_AUX_PERF_COUNT - 32))
+	mtspr   SPR_INTERRUPT_MASK_RESET_K_1, r0
 
 	/*
 	 * We now commit to returning from this interrupt, since we will be
@@ -1171,6 +1178,10 @@ handle_nmi:
 	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
 	}
 	FEEDBACK_REENTER(handle_nmi)
+	{
+	 movei  r30, 1
+	 seq    r31, r0, zero
+	}
 	j       interrupt_return
 	STD_ENDPROC(handle_nmi)
 
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 8f892a5..5b67efc 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -971,6 +971,15 @@ STD_ENTRY(interrupt_return)
 	beqzt   r30, .Lrestore_regs
 3:
 
+#if INT_PERF_COUNT + 1 != INT_AUX_PERF_COUNT
+# error Bad interrupt assumption
+#endif
+	{
+	 movei  r0, 3   /* two adjacent bits for the PERF_COUNT mask */
+	 beqz   r31, .Lrestore_regs
+	}
+	shli    r0, r0, INT_PERF_COUNT
+	mtspr   SPR_INTERRUPT_MASK_RESET_K, r0
 
 	/*
 	 * We now commit to returning from this interrupt, since we will be
@@ -1187,7 +1196,7 @@ handle_nmi:
 	FEEDBACK_REENTER(handle_nmi)
 	{
 	 movei  r30, 1
-	 move   r31, r0
+	 cmpeq  r31, r0, zero
 	}
 	j       interrupt_return
 	STD_ENDPROC(handle_nmi)
-- 
1.8.3.1

