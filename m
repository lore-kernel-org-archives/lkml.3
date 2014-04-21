Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaDUV4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:56:49 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:33751 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaDUVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:53:20 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/10] ARM: bcm: use memory accessors for ioremapped area
Date: Mon, 21 Apr 2014 16:53:02 -0500
Message-Id: <1398117191-2433-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398117191-2433-1-git-send-email-elder@linaro.org>
References: <1398117191-2433-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer used to pass parameters to an "smc" call is produced
through a call to ioremap().  As such, we should be using functions
like writel() to access it.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/mach-bcm/bcm_kona_smc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
index 5e31e91..d881c72 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -79,11 +79,11 @@ static void __bcm_kona_smc(void *info)
 	/* Check map in the bounce area */
 	BUG_ON(!bridge_data.initialized);
 
-	/* Copy one 32 bit word into the bounce area */
-	args[0] = data->arg0;
-	args[1] = data->arg1;
-	args[2] = data->arg2;
-	args[3] = data->arg3;
+	/* Copy the four 32 bit argument values into the bounce area */
+	writel_relaxed(data->arg0, args++);
+	writel_relaxed(data->arg1, args++);
+	writel_relaxed(data->arg2, args++);
+	writel(data->arg3, args);
 
 	/* Flush caches for input data passed to Secure Monitor */
 	if (data->service_id != SSAPI_BRCM_START_VC_CORE)
-- 
1.9.1

