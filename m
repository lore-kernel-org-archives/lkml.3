Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaHEBfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:35:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42808 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaHEBdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:33:24 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: Vikram Mulukutla <markivx@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH 3/8] msm: scm: Flush the command buffer only instead of the entire cache
Date: Mon,  4 Aug 2014 18:31:45 -0700
Message-Id: <1407202310-3359-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vikram Mulukutla <markivx@codeaurora.org>

scm_call flushes the entire cache before calling into the
secure world. This is both a performance penalty as well
as insufficient on SMP systems where the CPUs possess a
write-back L1 cache. Flush only the command and response
buffers instead, moving the responsibility of flushing any
other cached buffer (being passed to the secure world) to
callers.

Signed-off-by: Vikram Mulukutla <markivx@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-qcom/scm.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-qcom/scm.c b/arch/arm/mach-qcom/scm.c
index c08786ebf116..ec37b037e69c 100644
--- a/arch/arm/mach-qcom/scm.c
+++ b/arch/arm/mach-qcom/scm.c
@@ -196,12 +196,12 @@ static int __scm_call(const struct scm_command *cmd)
 	u32 cmd_addr = virt_to_phys(cmd);
 
 	/*
-	 * Flush the entire cache here so callers don't have to remember
-	 * to flush the cache when passing physical addresses to the secure
-	 * side in the buffer.
+	 * Flush the command buffer so that the secure world sees
+	 * the correct data.
 	 */
-	flush_cache_all();
-	outer_flush_all();
+	__cpuc_flush_dcache_area((void *)cmd, cmd->len);
+	outer_flush_range(cmd_addr, cmd_addr + cmd->len);
+
 	ret = smc(cmd_addr);
 	if (ret < 0)
 		ret = scm_remap_error(ret);
@@ -238,6 +238,13 @@ static void scm_inv_range(unsigned long start, unsigned long end)
  * @resp_len: length of the response buffer
  *
  * Sends a command to the SCM and waits for the command to finish processing.
+ *
+ * A note on cache maintenance:
+ * Note that any buffers that are expected to be accessed by the secure world
+ * must be flushed before invoking scm_call and invalidated in the cache
+ * immediately after scm_call returns. Cache maintenance on the command and
+ * response buffers is taken care of by scm_call; however, callers are
+ * responsible for any other cached buffers passed over to the secure world.
  */
 int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
 		void *resp_buf, size_t resp_len)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

