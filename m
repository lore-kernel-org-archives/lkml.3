Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaDRCbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:31:16 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:62749 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaDRCaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:30:22 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] ARM: bcm: have bcm_kona_smc() return request result
Date: Thu, 17 Apr 2014 21:30:09 -0500
Message-Id: <1397788215-20279-5-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397788215-20279-1-git-send-email-elder@linaro.org>
References: <1397788215-20279-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is assumed that SEC_ROM_RET_OK is the only valid "good"
result of a secure monitor request.  However the values that can be
returned by a secure monitor request are dependent on which service
id was provided.

We therefore should handle the result in a request-dependent way.
The most natural way to do that is to have the initiator of the
request--where bcm_kona_smc() is called--handle the result in a way
appropriate to the request.

An "smc" operation must be performed only on core 0, while the
request can be initiated from any core.  To pass back the request
result, we add a new field to the bcm_kona_smc_data structure, and
have bcm_kona_smc() return that value rather than 0.

There's only one caller right now.  Move the existing check of the
result out of __bcm_kona_smc() and into the kona_l2_cache_init()
where the SSAPI_ENABLE_L2_CACHE request is initiated.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/mach-bcm/bcm_kona_smc.c |   12 +++++-------
 arch/arm/mach-bcm/kona.c         |    8 +++++++-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
index 0d2bfe2..47cf360 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -30,6 +30,7 @@ struct bcm_kona_smc_data {
 	unsigned arg1;
 	unsigned arg2;
 	unsigned arg3;
+	unsigned result;
 };
 
 static const struct of_device_id bcm_kona_smc_ids[] __initconst = {
@@ -80,7 +81,6 @@ static void __bcm_kona_smc(void *info)
 {
 	struct bcm_kona_smc_data *data = info;
 	u32 *args = bcm_smc_buffer;
-	int rc;
 
 	BUG_ON(smp_processor_id() != 0);
 	BUG_ON(!args);
@@ -94,11 +94,8 @@ static void __bcm_kona_smc(void *info)
 	/* Flush caches for input data passed to Secure Monitor */
 	flush_cache_all();
 
-	/* Trap into Secure Monitor */
-	rc = bcm_kona_smc_asm(data->service_id, bcm_smc_buffer_phys);
-
-	if (rc != SEC_ROM_RET_OK)
-		pr_err("Secure Monitor call failed (0x%x)!\n", rc);
+	/* Trap into Secure Monitor and record the request result */
+	data->result = bcm_kona_smc_asm(data->service_id, bcm_smc_buffer_phys);
 }
 
 unsigned bcm_kona_smc(unsigned service_id, unsigned arg0, unsigned arg1,
@@ -111,6 +108,7 @@ unsigned bcm_kona_smc(unsigned service_id, unsigned arg0, unsigned arg1,
 	data.arg1 = arg1;
 	data.arg2 = arg2;
 	data.arg3 = arg3;
+	data.result = 0;
 
 	/*
 	 * Due to a limitation of the secure monitor, we must use the SMP
@@ -123,5 +121,5 @@ unsigned bcm_kona_smc(unsigned service_id, unsigned arg0, unsigned arg1,
 
 	put_cpu();
 
-	return 0;
+	return data.result;
 }
diff --git a/arch/arm/mach-bcm/kona.c b/arch/arm/mach-bcm/kona.c
index 768bc28..ecdd713 100644
--- a/arch/arm/mach-bcm/kona.c
+++ b/arch/arm/mach-bcm/kona.c
@@ -19,6 +19,7 @@
 
 void __init kona_l2_cache_init(void)
 {
+	unsigned int result;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_CACHE_L2X0))
@@ -31,7 +32,12 @@ void __init kona_l2_cache_init(void)
 		return;
 	}
 
-	bcm_kona_smc(SSAPI_ENABLE_L2_CACHE, 0, 0, 0, 0);
+	result = bcm_kona_smc(SSAPI_ENABLE_L2_CACHE, 0, 0, 0, 0);
+	if (result != SEC_ROM_RET_OK) {
+		pr_err("Secure Monitor call failed (%u)! Skipping L2 init.\n",
+			result);
+		return;
+	}
 
 	/*
 	 * The aux_val and aux_mask have no effect since L2 cache is already
-- 
1.7.9.5

