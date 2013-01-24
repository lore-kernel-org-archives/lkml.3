Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3AXBQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 20:16:13 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:59147
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab3AXBQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 20:16:00 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, davem@davemloft.net, jkosina@suse.cz,
        James.Bottomley@HansenPartnership.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
Date: Wed, 23 Jan 2013 17:42:45 -0800
Message-Id: <1358991765-22715-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358991765-22715-1-git-send-email-kys@microsoft.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Execute the shutdown code in a thread context. With recent changes made to the
shutdown code, shutdown code cannot be invoked from an interrupt context.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_util.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 8b7868a..aceb67f 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -49,6 +49,16 @@ static struct hv_util_service util_kvp = {
 	.util_deinit = hv_kvp_deinit,
 };
 
+static void perform_shutdown(struct work_struct *dummy)
+{
+		orderly_poweroff(true);
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
1.7.4.1

