Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967478AbaLLHBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:01:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51719 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758578AbaLLGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sitsofe Wheeler" <sitsofe@yahoo.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.98972994@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 019/164] Drivers: hv: vmbus: Cleanup vmbus_post_msg()
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hv/connection.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -284,10 +284,21 @@ int vmbus_post_msg(void *buffer, size_t
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

