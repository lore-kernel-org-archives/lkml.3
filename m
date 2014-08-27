Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965219AbaH0WWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:22:06 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:44230
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933932AbaH0WWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:22:04 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com, decui@microsoft.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH V2 1/5] Drivers: hv: vmbus: Cleanup vmbus_post_msg()
Date: Wed, 27 Aug 2014 16:25:31 -0700
Message-Id: <1409181935-23295-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1409181905-23254-1-git-send-email-kys@microsoft.com>
References: <1409181905-23254-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Posting messages to the host can fail because of transient resource
related failures. Correctly deal with these failures and increase the
number of attempts to post the message before giving up.

In this version of the patch, I have normalized the error code to
Linux error code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hv/connection.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index ae22e3c..e206619 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -427,10 +427,21 @@ int vmbus_post_msg(void *buffer, size_t buflen)
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
1.7.4.1

