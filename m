Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaAVHMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 02:12:45 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45935 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbaAVHMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 02:12:41 -0500
Subject: [RESEND PATCH V5 5/8] powermgt: Add OPAL call to resync timebase on
 wakeup
To: peterz@infradead.org, fweisbec@gmail.com, paul.gortmaker@windriver.com,
        paulus@samba.org, mingo@kernel.org, mikey@neuling.org,
        shangw@linux.vnet.ibm.com, rafael.j.wysocki@intel.com,
        galak@kernel.crashing.org, =daniel.lezcano@linaro.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        --to=agraf@suse.de, arnd@arndb.de, linux-pm@vger.kernel.org,
        rostedt@goodmis.org, michael@ellerman.id.au, john.stultz@linaro.org,
        anton@samba.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 22 Jan 2014 12:39:04 +0530
Message-ID: <20140122070904.30650.83324.stgit@preeti.in.ibm.com>
In-Reply-To: <20140122065918.30650.22437.stgit@preeti.in.ibm.com>
References: <20140122065918.30650.22437.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012207-9332-0000-0000-000002D86C9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

During "Fast-sleep" and deeper power savings state, decrementer and
timebase could be stopped making it out of sync with rest
of the cores in the system.

Add a firmware call to request platform to resync timebase
using low level platform methods.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/opal.h                |    2 ++
 arch/powerpc/kernel/exceptions-64s.S           |    2 +-
 arch/powerpc/kernel/idle_power7.S              |   27 ++++++++++++++++++++++++
 arch/powerpc/platforms/powernv/opal-wrappers.S |    1 +
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
index 9a87b44..8c4829f 100644
--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -154,6 +154,7 @@ extern int opal_enter_rtas(struct rtas_args *args,
 #define OPAL_FLASH_VALIDATE			76
 #define OPAL_FLASH_MANAGE			77
 #define OPAL_FLASH_UPDATE			78
+#define OPAL_RESYNC_TIMEBASE			79
 #define OPAL_GET_MSG				85
 #define OPAL_CHECK_ASYNC_COMPLETION		86
 
@@ -863,6 +864,7 @@ extern void opal_flash_init(void);
 extern int opal_machine_check(struct pt_regs *regs);
 
 extern void opal_shutdown(void);
+extern int opal_resync_timebase(void);
 
 extern void opal_lpc_init(void);
 
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index b01a9cb..9533d7a 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -145,7 +145,7 @@ BEGIN_FTR_SECTION
 
 	/* Fast Sleep wakeup on PowerNV */
 8:	GET_PACA(r13)
-	b 	.power7_wakeup_loss
+	b 	.power7_wakeup_tb_loss
 
 9:
 END_FTR_SECTION_IFSET(CPU_FTR_HVMODE | CPU_FTR_ARCH_206)
diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
index 14f78be..c3ab869 100644
--- a/arch/powerpc/kernel/idle_power7.S
+++ b/arch/powerpc/kernel/idle_power7.S
@@ -17,6 +17,7 @@
 #include <asm/ppc-opcode.h>
 #include <asm/hw_irq.h>
 #include <asm/kvm_book3s_asm.h>
+#include <asm/opal.h>
 
 #undef DEBUG
 
@@ -125,6 +126,32 @@ _GLOBAL(power7_sleep)
 	b	power7_powersave_common
 	/* No return */
 
+_GLOBAL(power7_wakeup_tb_loss)
+	ld	r2,PACATOC(r13);
+	ld	r1,PACAR1(r13)
+
+	/* Time base re-sync */
+	li	r0,OPAL_RESYNC_TIMEBASE
+	LOAD_REG_ADDR(r11,opal);
+	ld	r12,8(r11);
+	ld	r2,0(r11);
+	mtctr	r12
+	bctrl
+
+	/* TODO: Check r3 for failure */
+
+	REST_NVGPRS(r1)
+	REST_GPR(2, r1)
+	ld	r3,_CCR(r1)
+	ld	r4,_MSR(r1)
+	ld	r5,_NIP(r1)
+	addi	r1,r1,INT_FRAME_SIZE
+	mtcr	r3
+	mfspr	r3,SPRN_SRR1		/* Return SRR1 */
+	mtspr	SPRN_SRR1,r4
+	mtspr	SPRN_SRR0,r5
+	rfid
+
 _GLOBAL(power7_wakeup_loss)
 	ld	r1,PACAR1(r13)
 	REST_NVGPRS(r1)
diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
index 719aa5c..a11a87c 100644
--- a/arch/powerpc/platforms/powernv/opal-wrappers.S
+++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
@@ -126,5 +126,6 @@ OPAL_CALL(opal_return_cpu,			OPAL_RETURN_CPU);
 OPAL_CALL(opal_validate_flash,			OPAL_FLASH_VALIDATE);
 OPAL_CALL(opal_manage_flash,			OPAL_FLASH_MANAGE);
 OPAL_CALL(opal_update_flash,			OPAL_FLASH_UPDATE);
+OPAL_CALL(opal_resync_timebase,			OPAL_RESYNC_TIMEBASE);
 OPAL_CALL(opal_get_msg,				OPAL_GET_MSG);
 OPAL_CALL(opal_check_completion,		OPAL_CHECK_ASYNC_COMPLETION);

