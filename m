Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762849AbbA1FZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:25:49 -0500
Received: from mail.kernel.org ([198.145.29.136]:37239 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933369AbbA1EPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:15:02 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 020/177] Drivers: hv: vmbus: Cleanup vmbus_close_internal()
Date: Wed, 28 Jan 2015 12:06:46 +0800
Message-Id: <1422418236-12852-39-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 98d731bb064a9d1817a6ca9bf8b97051334a7cfe upstream.

Eliminate calls to BUG_ON() in vmbus_close_internal().
We have chosen to potentially leak memory, than crash the guest
in case of failures.

In this version of the patch I have addressed comments from
Dan Carpenter (dan.carpenter@oracle.com).

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: s/return ret/return/g]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/hv/channel.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 7bbbb95..3c8b2c4 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -531,11 +531,28 @@ void vmbus_close(struct vmbus_channel *channel)
 
 	ret = vmbus_post_msg(msg, sizeof(struct vmbus_channel_close_channel));
 
-	BUG_ON(ret != 0);
+	if (ret) {
+		pr_err("Close failed: close post msg return is %d\n", ret);
+		/*
+		 * If we failed to post the close msg,
+		 * it is perhaps better to leak memory.
+		 */
+		return;
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
+			return;
+		}
+	}
 
 	/* Cleanup the ring buffers for this channel */
 	hv_ringbuffer_cleanup(&channel->outbound);
@@ -543,8 +560,6 @@ void vmbus_close(struct vmbus_channel *channel)
 
 	free_pages((unsigned long)channel->ringbuffer_pages,
 		get_order(channel->ringbuffer_pagecount * PAGE_SIZE));
-
-
 }
 EXPORT_SYMBOL_GPL(vmbus_close);
 
-- 
1.9.1

