Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaHEBd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:33:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42796 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaHEBdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:33:24 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH 1/8] msm: scm: Fix incorrect cache invalidation
Date: Mon,  4 Aug 2014 18:31:43 -0700
Message-Id: <1407202310-3359-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache invalidation in scm_call() correctly rounds down the
start address to invalidate the beginning of the cacheline but
doesn't properly round up the 'end' address to make it aligned.
The last chunk of the buffer won't be invalidated when 'end' is
not cacheline size aligned so make sure to invalidate the last
few bytes in such situations. It also doesn't do anything about
outer caches so make sure to invalidate and flush those as well.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-qcom/scm.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-qcom/scm.c b/arch/arm/mach-qcom/scm.c
index c536fd6bf827..820c72165e19 100644
--- a/arch/arm/mach-qcom/scm.c
+++ b/arch/arm/mach-qcom/scm.c
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 
+#include <asm/outercache.h>
 #include <asm/cacheflush.h>
 
 #include "scm.h"
@@ -203,6 +204,7 @@ static int __scm_call(const struct scm_command *cmd)
 	 * side in the buffer.
 	 */
 	flush_cache_all();
+	outer_flush_all();
 	ret = smc(cmd_addr);
 	if (ret < 0)
 		ret = scm_remap_error(ret);
@@ -210,6 +212,20 @@ static int __scm_call(const struct scm_command *cmd)
 	return ret;
 }
 
+static void scm_inv_range(unsigned long start, unsigned long end)
+{
+	start = round_down(start, CACHELINESIZE);
+	end = round_up(end, CACHELINESIZE);
+	outer_inv_range(start, end);
+	while (start < end) {
+		asm ("mcr p15, 0, %0, c7, c6, 1" : : "r" (start)
+		     : "memory");
+		start += CACHELINESIZE;
+	}
+	dsb();
+	isb();
+}
+
 /**
  * scm_call() - Send an SCM command
  * @svc_id: service identifier
@@ -227,6 +243,7 @@ int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
 	int ret;
 	struct scm_command *cmd;
 	struct scm_response *rsp;
+	unsigned long start, end;
 
 	cmd = alloc_scm_command(cmd_len, resp_len);
 	if (!cmd)
@@ -243,17 +260,15 @@ int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
 		goto out;
 
 	rsp = scm_command_to_response(cmd);
+	start = (unsigned long)rsp;
+
 	do {
-		u32 start = (u32)rsp;
-		u32 end = (u32)scm_get_response_buffer(rsp) + resp_len;
-		start &= ~(CACHELINESIZE - 1);
-		while (start < end) {
-			asm ("mcr p15, 0, %0, c7, c6, 1" : : "r" (start)
-			     : "memory");
-			start += CACHELINESIZE;
-		}
+		scm_inv_range(start, start + sizeof(*rsp));
 	} while (!rsp->is_complete);
 
+	end = (unsigned long)scm_get_response_buffer(rsp) + resp_len;
+	scm_inv_range(start, end);
+
 	if (resp_buf)
 		memcpy(resp_buf, scm_get_response_buffer(rsp), resp_len);
 out:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

