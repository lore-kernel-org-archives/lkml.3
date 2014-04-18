Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaDRCb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:31:28 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43532 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaDRCa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:30:27 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] ARM: bcm: rewrite commentary for bcm_kona_do_smc()
Date: Thu, 17 Apr 2014 21:30:14 -0500
Message-Id: <1397788215-20279-10-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397788215-20279-1-git-send-email-elder@linaro.org>
References: <1397788215-20279-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block of comments in bcm_kona_do_smc() are somewhat confusing.
This patch attempts to clarify what's going on.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/mach-bcm/bcm_kona_smc.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
index cc81c86..a55a7ec 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -77,16 +77,34 @@ int __init bcm_kona_smc_init(void)
 }
 
 /*
- * Since interrupts are disabled in the open mode, we must keep
- * interrupts disabled in secure mode by setting R5=0x3. If interrupts
- * are enabled in open mode, we can set R5=0x0 to allow interrupts in
- * secure mode.  If we did this, the secure monitor would return back
- * control to the open mode to handle the interrupt prior to completing
- * the secure service. If this happened, R12 would not be
- * SEC_EXIT_NORMAL and we would need to call SMC again after resetting
- * R5 (it gets clobbered by the secure monitor) and setting R4 to
- * SSAPI_RET_FROM_INT_SERV to indicate that we want the secure monitor
- * to finish up the previous uncompleted secure service.
+ * int bcm_kona_do_smc(u32 service_id, u32 buffer_addr)
+ *
+ * Only core 0 can run the secure monitor code.  If an "smc" request
+ * is initiated on a different core it must be redirected to core 0
+ * for execution.  We rely on the caller to handle this.
+ *
+ * Each "smc" request supplies a service id and the address of a
+ * buffer containing parameters related to the service to be
+ * performed.  A flags value defines the behavior of the level 2
+ * cache and interrupt handling while the secure monitor executes.
+ *
+ * Parameters to the "smc" request are passed in r4-r6 as follows:
+ *     r4	service id
+ *     r5	flags (SEC_ROM_*)
+ *     r6	physical address of buffer with other parameters
+ *
+ * Execution of an "smc" request produces two distinct results.
+ *
+ * First, the secure monitor call itself (regardless of the specific
+ * service request) can succeed, or can produce an error.  When an
+ * "smc" request completes this value is found in r12; it should
+ * always be SEC_EXIT_NORMAL.
+ *
+ * In addition, the particular service performed produces a result.
+ * The values that should be expected depend on the service.  We
+ * therefore return this value to the caller, so it can handle the
+ * request result appropriately.  This result value is found in r0
+ * when the "smc" request completes.
  */
 static int bcm_kona_do_smc(u32 service_id, u32 buffer_phys)
 {
-- 
1.7.9.5

