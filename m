Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaJ0TDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52681 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaJ0TDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 035/105] Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
Date: Mon, 27 Oct 2014 11:56:10 -0700
Message-Id: <1414436240-13879-36-git-send-email-kamal@canonical.com>
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

commit 72c6b71c245dac8f371167d97ef471b367d0b66b upstream.

Eliminate the call to BUG_ON() by waiting for the host to respond. We are
trying to reclaim the ownership of memory that was given to the host and so
we will have to wait until the host responds.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hv/channel.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index d2d9cd6..6c28f48 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -360,7 +360,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	u32 next_gpadl_handle;
 	unsigned long flags;
 	int ret = 0;
-	int t;
 
 	next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
 	atomic_inc(&vmbus_connection.next_gpadl_handle);
@@ -407,9 +406,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
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

