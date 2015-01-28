Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbbA1F0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:26:50 -0500
Received: from mail.kernel.org ([198.145.29.136]:37176 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933283AbbA1EOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:52 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 018/177] Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
Date: Wed, 28 Jan 2015 12:06:42 +0800
Message-Id: <1422418236-12852-35-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 72c6b71c245dac8f371167d97ef471b367d0b66b upstream.

Eliminate the call to BUG_ON() by waiting for the host to respond. We are
trying to reclaim the ownership of memory that was given to the host and so
we will have to wait until the host responds.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/hv/channel.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index fa59090..1211d38 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -400,7 +400,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	u32 next_gpadl_handle;
 	unsigned long flags;
 	int ret = 0;
-	int t;
 
 	next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
 	atomic_inc(&vmbus_connection.next_gpadl_handle);
@@ -447,9 +446,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
 		}
 	}
-	t = wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
-	BUG_ON(t == 0);
-
+	wait_for_completion(&msginfo->waitevent);
 
 	/* At this point, we received the gpadl created msg */
 	*gpadl_handle = gpadlmsg->gpadl;
-- 
1.9.1

