Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965249AbaH0WWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:22:08 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:35174
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933938AbaH0WWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:22:04 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com, decui@microsoft.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH V3 3/5] Drivers: hv: vmbus: Cleanup vmbus_close_internal()
Date: Wed, 27 Aug 2014 16:25:33 -0700
Message-Id: <1409181935-23295-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1409181935-23295-1-git-send-email-kys@microsoft.com>
References: <1409181905-23254-1-git-send-email-kys@microsoft.com>
 <1409181935-23295-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate calls to BUG_ON() in vmbus_close_internal().
We have chosen to potentially leak memory, than crash the guest
in case of failures.

In this version of the patch I have addressed comments from
Dan Carpenter (dan.carpenter@oracle.com).

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hv/channel.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 0206314..eb3158e 100644
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
@@ -502,11 +502,28 @@ static void vmbus_close_internal(struct vmbus_channel *channel)
 
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
@@ -515,7 +532,7 @@ static void vmbus_close_internal(struct vmbus_channel *channel)
 	free_pages((unsigned long)channel->ringbuffer_pages,
 		get_order(channel->ringbuffer_pagecount * PAGE_SIZE));
 
-
+	return ret;
 }
 
 /*
-- 
1.7.4.1

