Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaJ0TRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:17:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbaJ0TDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 033/105] Drivers: hv: vmbus: Cleanup vmbus_post_msg()
Date: Mon, 27 Oct 2014 11:56:08 -0700
Message-Id: <1414436240-13879-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit fdeebcc62279119dbeafbc1a2e39e773839025fd upstream.

Posting messages to the host can fail because of transient resource
related failures. Correctly deal with these failures and increase the
number of attempts to post the message before giving up.

In this version of the patch, I have normalized the error code to
Linux error code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hv/connection.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index ce5a9f2..d8fd95c 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -408,10 +408,21 @@ int vmbus_post_msg(void *buffer, size_t buflen)
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

