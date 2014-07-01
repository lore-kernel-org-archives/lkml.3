Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaGAMFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:05:45 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:51249 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaGAMFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:05:44 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: behanw@converseincode.com, bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mach-bcm SMC: address clang inline asm incompatibility
Date: Tue,  1 Jul 2014 07:05:39 -0500
Message-Id: <1404216339-6480-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My GCC-based build environment likes to call register r12 by the
name "ip" in inline asm.  Behan Webster informed me that his Clang-
based build environment likes "r12" instead.

Try to make them both happy.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm/mach-bcm/bcm_kona_smc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
index a55a7ec..3937bd5 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -106,9 +106,14 @@ int __init bcm_kona_smc_init(void)
  * request result appropriately.  This result value is found in r0
  * when the "smc" request completes.
  */
+#ifdef __clang__
+#define R12	"r12"
+#else  /* !__clang__ */
+#define R12	"ip"	/* gcc calls r12 "ip" */
+#endif /* !__clang__ */
 static int bcm_kona_do_smc(u32 service_id, u32 buffer_phys)
 {
-	register u32 ip asm("ip");	/* Also called r12 */
+	register u32 ip asm(R12);	/* Also called r12 */
 	register u32 r0 asm("r0");
 	register u32 r4 asm("r4");
 	register u32 r5 asm("r5");
@@ -120,7 +125,7 @@ static int bcm_kona_do_smc(u32 service_id, u32 buffer_phys)
 
 	asm volatile (
 		/* Make sure we got the registers we want */
-		__asmeq("%0", "ip")
+		__asmeq("%0", R12)
 		__asmeq("%1", "r0")
 		__asmeq("%2", "r4")
 		__asmeq("%3", "r5")
-- 
1.9.1

