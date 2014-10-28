Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbaJ1Dv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:51:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbaJ1Dvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:51:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [PATCH 3.10 17/43] Drivers: hv: vmbus: Cleanup vmbus_post_msg()
Date: Tue, 28 Oct 2014 11:36:15 +0800
Message-Id: <20141028033524.138121612@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/hv/connection.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -393,10 +393,21 @@ int vmbus_post_msg(void *buffer, size_t
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


