Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbbAJGm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 01:42:29 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:56764
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbbAJGm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 01:42:26 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 3/6] Drivers: hv: hv_balloon: Don't post pressure status from interrupt context
Date: Fri,  9 Jan 2015 23:54:31 -0800
Message-Id: <1420876474-9205-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1420876474-9205-1-git-send-email-kys@microsoft.com>
References: <1420876440-9164-1-git-send-email-kys@microsoft.com>
 <1420876474-9205-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently release memory (balloon down) in the interrupt context and we also
post memory status while releasing memory. Rather than posting the status
in the interrupt context, wakeup the status posting thread to post the status.
This will address the inconsistent lock state that Sitsofe Wheeler <sitsofe@gmail.com>
reported:

http://lkml.iu.edu/hypermail/linux/kernel/1411.1/00075.html

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reported-by: Sitsofe Wheeler <sitsofe@gmail.com>
---
 drivers/hv/hv_balloon.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 8e30415..ff16938 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1226,7 +1226,7 @@ static void balloon_down(struct hv_dynmem_device *dm,
 
 	for (i = 0; i < range_count; i++) {
 		free_balloon_pages(dm, &range_array[i]);
-		post_status(&dm_device);
+		complete(&dm_device.config_event);
 	}
 
 	if (req->more_pages == 1)
@@ -1250,19 +1250,16 @@ static void balloon_onchannelcallback(void *context);
 static int dm_thread_func(void *dm_dev)
 {
 	struct hv_dynmem_device *dm = dm_dev;
-	int t;
 
 	while (!kthread_should_stop()) {
-		t = wait_for_completion_interruptible_timeout(
+		wait_for_completion_interruptible_timeout(
 						&dm_device.config_event, 1*HZ);
 		/*
 		 * The host expects us to post information on the memory
 		 * pressure every second.
 		 */
-
-		if (t == 0)
-			post_status(dm);
-
+		reinit_completion(&dm_device.config_event);
+		post_status(dm);
 	}
 
 	return 0;
-- 
1.7.4.1

