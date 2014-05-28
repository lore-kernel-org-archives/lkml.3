Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaE1EnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:43:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54554 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbaE1EnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:43:21 -0400
Subject: [PATCH 1/6] powernv,
 cpuidle: Move the flags used for idle state discovery to powernv
 core
To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        svaidyan@in.ibm.com, paulus@samba.org,
        srivatsa.bhat@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 28 May 2014 10:08:47 +0530
Message-ID: <20140528043847.15676.19985.stgit@preeti.in.ibm.com>
In-Reply-To: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
References: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052804-7182-0000-0000-00000AB22E0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

These flags will be used by the cpuidle driver as well as in the cpu
offline path. The offline cpus should be put to fastsleep if the idle state
is discovered so as to gain maximum power savings in the offline state.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[ Changelog added by <preeti@linux.vnet.ibm.com> ]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/processor.h |    4 ++++
 drivers/cpuidle/cpuidle-powernv.c    |    7 +++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index d660dc3..d922e5c 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -445,6 +445,10 @@ static inline unsigned long get_clean_sp(unsigned long sp, int is_32)
 }
 #endif
 
+/* Support for 'nap' and 'sleep' instructions, as discovered from the DT */
+#define IDLE_INST_NAP	0x00010000 /* nap instruction can be used */
+#define IDLE_INST_SLEEP	0x00020000 /* sleep instruction can be used */
+
 extern unsigned long cpuidle_disable;
 enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 
diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 719f6fb..5d4f9e8 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -17,12 +17,11 @@
 #include <asm/machdep.h>
 #include <asm/firmware.h>
 #include <asm/runlatch.h>
+#include <asm/processor.h>
 
 /* Flags and constants used in PowerNV platform */
 
 #define MAX_POWERNV_IDLE_STATES	8
-#define IDLE_USE_INST_NAP	0x00010000 /* Use nap instruction */
-#define IDLE_USE_INST_SLEEP	0x00020000 /* Use sleep instruction */
 
 struct cpuidle_driver powernv_idle_driver = {
 	.name             = "powernv_idle",
@@ -187,7 +186,7 @@ static int powernv_add_idle_states(void)
 
 	for (i = 0; i < dt_idle_states; i++) {
 
-		if (flags[i] & IDLE_USE_INST_NAP) {
+		if (flags[i] & IDLE_INST_NAP) {
 			/* Add NAP state */
 			strcpy(powernv_states[nr_idle_states].name, "Nap");
 			strcpy(powernv_states[nr_idle_states].desc, "Nap");
@@ -198,7 +197,7 @@ static int powernv_add_idle_states(void)
 			nr_idle_states++;
 		}
 
-		if (flags[i] & IDLE_USE_INST_SLEEP) {
+		if (flags[i] & IDLE_INST_SLEEP) {
 			/* Add FASTSLEEP state */
 			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
 			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");

