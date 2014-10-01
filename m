Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaJAHrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:47:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40506 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaJAHrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:47:48 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 5/5] powerpc/powernv: Enter deepest supported idle state in offline
Date: Wed,  1 Oct 2014 13:16:57 +0530
Message-Id: <1412149617-3178-6-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412149617-3178-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1412149617-3178-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100107-8236-0000-0000-000005D3090C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enter winkle during offline if supported, else revert to sleep or nap.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/powernv/smp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 3ad31d2..e3fc2c9 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -169,8 +169,10 @@ static void pnv_smp_cpu_kill_self(void)
 	while (!generic_check_cpu_restart(cpu)) {
 		ppc64_runlatch_off();
 
-		/* If sleep is supported, go to sleep, instead of nap */
-		if (idle_states & IDLE_USE_SLEEP)
+		/* Go to deepest supported idle state */
+		if (idle_states & IDLE_USE_WINKLE)
+			power7_winkle();
+		else if (idle_states & IDLE_USE_SLEEP)
 			power7_sleep();
 		else
 			power7_nap(1);
-- 
1.9.3

