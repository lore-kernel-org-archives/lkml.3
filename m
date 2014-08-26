Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaHZSCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:02:31 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41019
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbaHZSCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:02:25 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 3/4] Drivers: hv: vmbus: Cleanup vmbus_close_internal()
Date: Tue, 26 Aug 2014 12:05:51 -0700
Message-Id: <1409079952-16599-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1409079952-16599-1-git-send-email-kys@microsoft.com>
References: <1409079922-16560-1-git-send-email-kys@microsoft.com>
 <1409079952-16599-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate calls to BUG_ON() in vmbus_close_internal().
We have chosen to potentially leak memory, than crash the guest
in case of failures.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hv/channel.c |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 0206314..d6c8ea2 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -479,10 +479,10 @@ static void reset_channel_cb(void *arg)
 	channel->onchannel_callback = NULL;
 }
 
-static void vmbus_close_internal(struct vmbus_channel *channel)
+static int vmbus_close_internal(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
-	int ret;
+	int ret = 0;
 
 	channel->state = CHANNEL_OPEN_STATE;
 	channel->sc_creation_callback = NULL;
@@ -502,11 +502,28 @@ static void vmbus_close_internal(struct vmbus_channel *channel)
 
 	ret = vmbus_post_msg(msg, sizeof(struct vmbus_channel_close_channel));
 
-	BUG_ON(ret != 0);
+	if (ret) {
+		pr_err("Close failed: close post msg return is %d\n", ret);
+		/*
+		 * If we failed to post the close msg,
+		 * it is perhaps better to leak memory.
+		 */
+		goto close_err;
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
+			goto close_err;
+		}
+	}
 
 	/* Cleanup the ring buffers for this channel */
 	hv_ringbuffer_cleanup(&channel->outbound);
@@ -515,7 +532,8 @@ static void vmbus_close_internal(struct vmbus_channel *channel)
 	free_pages((unsigned long)channel->ringbuffer_pages,
 		get_order(channel->ringbuffer_pagecount * PAGE_SIZE));
 
-
+close_err:
+	return ret;
 }
 
 /*
-- 
1.7.4.1

