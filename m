Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368Ab3GQXTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:19:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56481 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934317Ab3GQWyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:54:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 069/145] Drivers: hv: Execute shutdown in a thread context
Date: Wed, 17 Jul 2013 15:46:41 -0700
Message-Id: <1374101277-7915-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 3dd6cb497198a0533a2530b6a345c60c9a29b9bc upstream.

Execute the shutdown code in a thread context. With recent changes made to the
shutdown code, shutdown code cannot be invoked from an interrupt context.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hv/hv_util.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index a0667de..c64be4f 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -49,6 +49,16 @@ static struct hv_util_service util_kvp = {
 	.util_deinit = hv_kvp_deinit,
 };
 
+static void perform_shutdown(struct work_struct *dummy)
+{
+	orderly_poweroff(true);
+}
+
+/*
+ * Perform the shutdown operation in a thread context.
+ */
+static DECLARE_WORK(shutdown_work, perform_shutdown);
+
 static void shutdown_onchannelcallback(void *context)
 {
 	struct vmbus_channel *channel = context;
@@ -106,7 +116,7 @@ static void shutdown_onchannelcallback(void *context)
 	}
 
 	if (execute_shutdown == true)
-		orderly_poweroff(true);
+		schedule_work(&shutdown_work);
 }
 
 /*
-- 
1.8.1.2

