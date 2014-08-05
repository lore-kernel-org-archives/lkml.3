Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaHEBfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:35:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42808 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaHEBdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:33:25 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH 5/8] msm: scm: Add API to query for service/command availability.
Date: Mon,  4 Aug 2014 18:31:47 -0700
Message-Id: <1407202310-3359-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Saravana Kannan <skannan@codeaurora.org>

Some drivers may need to query the secure environment about the
availability of a particular service/command. Add support for
this.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
[sboyd@codeaurora.org: Add some commit text]

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-qcom/scm.c | 18 +++++++++++++++++-
 arch/arm/mach-qcom/scm.h |  2 ++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-qcom/scm.c b/arch/arm/mach-qcom/scm.c
index a05cad3fa1c5..e80571f57ca4 100644
--- a/arch/arm/mach-qcom/scm.c
+++ b/arch/arm/mach-qcom/scm.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -394,3 +394,19 @@ u32 scm_get_version(void)
 	return version;
 }
 EXPORT_SYMBOL(scm_get_version);
+
+#define IS_CALL_AVAIL_CMD	1
+int scm_is_call_available(u32 svc_id, u32 cmd_id)
+{
+	int ret;
+	u32 svc_cmd = (svc_id << 10) | cmd_id;
+	u32 ret_val = 0;
+
+	ret = scm_call(SCM_SVC_INFO, IS_CALL_AVAIL_CMD, &svc_cmd,
+			sizeof(svc_cmd), &ret_val, sizeof(ret_val));
+	if (ret)
+		return ret;
+
+	return ret_val;
+}
+EXPORT_SYMBOL(scm_is_call_available);
diff --git a/arch/arm/mach-qcom/scm.h b/arch/arm/mach-qcom/scm.h
index 1f0f0180e767..f94c7279616a 100644
--- a/arch/arm/mach-qcom/scm.h
+++ b/arch/arm/mach-qcom/scm.h
@@ -14,6 +14,7 @@
 
 #define SCM_SVC_BOOT			0x1
 #define SCM_SVC_PIL			0x2
+#define SCM_SVC_INFO			0x6
 
 extern int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
 		void *resp_buf, size_t resp_len);
@@ -24,5 +25,6 @@ extern s32 scm_call_atomic2(u32 svc, u32 cmd, u32 arg1, u32 arg2);
 #define SCM_VERSION(major, minor) (((major) << 16) | ((minor) & 0xFF))
 
 extern u32 scm_get_version(void);
+extern int scm_is_call_available(u32 svc_id, u32 cmd_id);
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

