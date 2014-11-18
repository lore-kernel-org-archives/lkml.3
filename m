Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaKROXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:23:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbaKROKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 110/206] ARC: [SMP] General Fixes
Date: Tue, 18 Nov 2014 15:07:45 +0100
Message-Id: <1e3b42efefd201e167bef3429ac7c90a9c3d534b.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c3441edd2dea83923421fd6050d2ffdc57696323 upstream.

-Pass the expected arg to non-boot park'ing routine
 (It worked so far because existing SMP backends don't use the arg)

-CONFIG_DEBUG_PREEMPT warning

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arc/kernel/head.S     | 7 ++++---
 arch/arc/mm/cache_arc700.c | 3 +--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arc/kernel/head.S b/arch/arc/kernel/head.S
index 0f944f024513..fda7e4a7e361 100644
--- a/arch/arc/kernel/head.S
+++ b/arch/arc/kernel/head.S
@@ -24,13 +24,13 @@
 	.globl stext
 stext:
 	;-------------------------------------------------------------------
-	; Don't clobber r0-r4 yet. It might have bootloader provided info
+	; Don't clobber r0-r2 yet. It might have bootloader provided info
 	;-------------------------------------------------------------------
 
 	sr	@_int_vec_base_lds, [AUX_INTR_VEC_BASE]
 
 #ifdef CONFIG_SMP
-	; Only Boot (Master) proceeds. Others wait in platform dependent way
+	; Ensure Boot (Master) proceeds. Others wait in platform dependent way
 	;	IDENTITY Reg [ 3  2  1  0 ]
 	;	(cpu-id)             ^^^	=> Zero for UP ARC700
 	;					=> #Core-ID if SMP (Master 0)
@@ -39,7 +39,8 @@ stext:
 	; need to make sure only boot cpu takes this path.
 	GET_CPU_ID  r5
 	cmp	r5, 0
-	jnz	arc_platform_smp_wait_to_boot
+	mov.ne	r0, r5
+	jne	arc_platform_smp_wait_to_boot
 #endif
 	; Clear BSS before updating any globals
 	; XXX: use ZOL here
diff --git a/arch/arc/mm/cache_arc700.c b/arch/arc/mm/cache_arc700.c
index 5a1259cd948c..fd9350fa5e6b 100644
--- a/arch/arc/mm/cache_arc700.c
+++ b/arch/arc/mm/cache_arc700.c
@@ -100,10 +100,9 @@
 #define DC_CTRL_INV_MODE_FLUSH  0x40
 #define DC_CTRL_FLUSH_STATUS    0x100
 
-char *arc_cache_mumbojumbo(int cpu_id, char *buf, int len)
+char *arc_cache_mumbojumbo(int c, char *buf, int len)
 {
 	int n = 0;
-	unsigned int c = smp_processor_id();
 
 #define PR_CACHE(p, enb, str)						\
 {									\
-- 
2.1.3

