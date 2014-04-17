Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaDQSzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:55:40 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:15928 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaDQSz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:55:29 -0400
X-IronPort-AV: E=Sophos;i="4.97,880,1389772800"; 
   d="scan'208";a="25331368"
From: Tim Kryger <tim.kryger@linaro.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: core: Return error in get optional stub
Date: Thu, 17 Apr 2014 11:55:24 -0700
Message-ID: <1397760924-7423-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers that call regulator_get_optional are tolerant to the absence of
that regulator.  By modifying the value returned from the stub function
to match that seen when a regulator isn't present, callers can wrap the
regulator logic with an IS_ERR based conditional even if they happen to
call regulator_is_supported_voltage.  This improves efficiency as well
as eliminates the possibility for a very subtle bug.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
---

This change was proposed here: https://lkml.org/lkml/2014/4/16/627

 include/linux/regulator/consumer.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index e530681..1a4a8c1 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -258,14 +258,14 @@ regulator_get_exclusive(struct device *dev, const char *id)
 static inline struct regulator *__must_check
 regulator_get_optional(struct device *dev, const char *id)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 
 static inline struct regulator *__must_check
 devm_regulator_get_optional(struct device *dev, const char *id)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline void regulator_put(struct regulator *regulator)
-- 
1.7.9.5

