Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbaGWKs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:48:29 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:41942 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaGWKs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:48:27 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: standby24x7@gmail.com, lisa@xenapiadmin.com, sulamiification@gmail.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        devel@driverdev.osuosl.org, dcb314@hotmail.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] drivers/staging/bcm/Misc.c: fix a check
Date: Wed, 23 Jul 2014 13:47:33 +0300
Message-Id: <1406112453-2393-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue was reported by static analysis.
The value holding flags was &-ed with 0x02, being compared to 0x01
(TRUE) after that. Such comparsion is always false.

Resolution: drop the comparsion to TRUE in the condition.

&-ing with 0x02 is right, according to result variable name
(reporting_mode) and description in drivers/staging/bcm/target_params.h
("bit 1 = 1: CINR reporting in Idlemode Msg").

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80801
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/staging/bcm/Misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index a1c833c..883f739 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -1154,7 +1154,7 @@ static void doPowerAutoCorrection(struct bcm_mini_adapter *psAdapter)
 	reporting_mode = ntohl(psAdapter->pstargetparams->m_u32PowerSavingModeOptions) & 0x02;
 	psAdapter->bIsAutoCorrectEnabled = !((char)(psAdapter->ulPowerSaveMode >> 3) & 0x1);
 
-	if (reporting_mode == TRUE) {
+	if (reporting_mode) {
 		BCM_DEBUG_PRINT(psAdapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "can't do suspen/resume as reporting mode is enable");
 		psAdapter->bDoSuspend = false;
 	}
-- 
1.8.5.5

