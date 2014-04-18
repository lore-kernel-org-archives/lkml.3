Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaDRCbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:31:11 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:43018 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaDRCaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:30:23 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] ARM: bcm: don't special-case CPU 0 in bcm_kona_smc()
Date: Thu, 17 Apr 2014 21:30:10 -0500
Message-Id: <1397788215-20279-6-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397788215-20279-1-git-send-email-elder@linaro.org>
References: <1397788215-20279-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's logic in bcm_kona_smc() to ensure __bcm_kona_smc() gets
called on CPU 0; if already executing on CPU 0, that function is
called directly.  The direct call is not protected from interrupts,
however, which is not safe.

Note that smp_call_function_single() is designed to handle the case
where the target cpu is the current one.  It also gets a reference
to the CPU and disables IRQs across the call.

So we can simplify things and at the same time be protected against
interrupts by calling smp_call_function_single() unconditionally.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/mach-bcm/bcm_kona_smc.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
index 47cf360..6fdcf96 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -114,12 +114,7 @@ unsigned bcm_kona_smc(unsigned service_id, unsigned arg0, unsigned arg1,
 	 * Due to a limitation of the secure monitor, we must use the SMP
 	 * infrastructure to forward all secure monitor calls to Core 0.
 	 */
-	if (get_cpu() != 0)
-		smp_call_function_single(0, __bcm_kona_smc, (void *)&data, 1);
-	else
-		__bcm_kona_smc(&data);
-
-	put_cpu();
+	smp_call_function_single(0, __bcm_kona_smc, &data, 1);
 
 	return data.result;
 }
-- 
1.7.9.5

