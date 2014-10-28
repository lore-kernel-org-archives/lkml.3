Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaJ1Dhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:37:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaJ1Dhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [PATCH 3.17 047/146] Drivers: hv: vmbus: Cleanup vmbus_close_internal()
Date: Tue, 28 Oct 2014 11:33:09 +0800
Message-Id: <20141028033345.456921298@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 98d731bb064a9d1817a6ca9bf8b97051334a7cfe upstream.

Eliminate calls to BUG_ON() in vmbus_close_internal().
We have chosen to potentially leak memory, than crash the guest
in case of failures.

In this version of the patch I have addressed comments from
Dan Carpenter (dan.carpenter@oracle.com).

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/channel.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -479,7 +479,7 @@ static void reset_channel_cb(void *arg)
 	channel->onchannel_callback = NULL;
 }
 
-static void vmbus_close_internal(struct vmbus_channel *channel)
+static int vmbus_close_internal(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
 	int ret;
@@ -502,11 +502,28 @@ static void vmbus_close_internal(struct
 
 	ret = vmbus_post_msg(msg, sizeof(struct vmbus_channel_close_channel));
 
-	BUG_ON(ret != 0);
+	if (ret) {
+		pr_err("Close failed: close post msg return is %d\n", ret);
+		/*
+		 * If we failed to post the close msg,
+		 * it is perhaps better to leak memory.
+		 */
+		return ret;
+	}
+
 	/* Tear down the gpadl for the channel's ring buffer */
-	if (channel->ringbuffer_gpadlhandle)
-		vmbus_teardown_gpadl(channel,
-					  channel->ringbuffer_gpadlhandle);
+	if (channel->ringbuffer_gpadlhandle) {
+		ret = vmbus_teardown_gpadl(channel,
+					   channel->ringbuffer_gpadlhandle);
+		if (ret) {
+			pr_err("Close failed: teardown gpadl return %d\n", ret);
+			/*
+			 * If we failed to teardown gpadl,
+			 * it is perhaps better to leak memory.
+			 */
+			return ret;
+		}
+	}
 
 	/* Cleanup the ring buffers for this channel */
 	hv_ringbuffer_cleanup(&channel->outbound);
@@ -515,7 +532,7 @@ static void vmbus_close_internal(struct
 	free_pages((unsigned long)channel->ringbuffer_pages,
 		get_order(channel->ringbuffer_pagecount * PAGE_SIZE));
 
-
+	return ret;
 }
 
 /*


