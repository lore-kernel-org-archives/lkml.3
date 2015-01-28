Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbbA1EOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:14:44 -0500
Received: from mail.kernel.org ([198.145.29.136]:37073 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760740AbbA1EOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:41 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 016/177] Drivers: hv: vmbus: Cleanup vmbus_post_msg()
Date: Wed, 28 Jan 2015 12:06:38 +0800
Message-Id: <1422418236-12852-31-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit fdeebcc62279119dbeafbc1a2e39e773839025fd upstream.

Posting messages to the host can fail because of transient resource
related failures. Correctly deal with these failures and increase the
number of attempts to post the message before giving up.

In this version of the patch, I have normalized the error code to
Linux error code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/hv/connection.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 650c9f0..2d52a1b 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -294,10 +294,21 @@ int vmbus_post_msg(void *buffer, size_t buflen)
 	 * insufficient resources. Retry the operation a couple of
 	 * times before giving up.
 	 */
-	while (retries < 3) {
-		ret =  hv_post_message(conn_id, 1, buffer, buflen);
-		if (ret != HV_STATUS_INSUFFICIENT_BUFFERS)
+	while (retries < 10) {
+		ret = hv_post_message(conn_id, 1, buffer, buflen);
+
+		switch (ret) {
+		case HV_STATUS_INSUFFICIENT_BUFFERS:
+			ret = -ENOMEM;
+		case -ENOMEM:
+			break;
+		case HV_STATUS_SUCCESS:
 			return ret;
+		default:
+			pr_err("hv_post_msg() failed; error code:%d\n", ret);
+			return -EINVAL;
+		}
+
 		retries++;
 		msleep(100);
 	}
-- 
1.9.1

