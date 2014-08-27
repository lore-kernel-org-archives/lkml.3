Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965309AbaH0WWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:22:39 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:35175
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935932AbaH0WWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:22:04 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com, decui@microsoft.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH V2 4/5] Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
Date: Wed, 27 Aug 2014 16:25:34 -0700
Message-Id: <1409181935-23295-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1409181935-23295-1-git-send-email-kys@microsoft.com>
References: <1409181905-23254-1-git-send-email-kys@microsoft.com>
 <1409181935-23295-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the call to BUG_ON() by waiting for the host to respond. We are
trying to reclaim the ownership of memory that was given to the host and so
we will have to wait until the host responds.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hv/channel.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index eb3158e..9a6a2c3 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -363,7 +363,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	u32 next_gpadl_handle;
 	unsigned long flags;
 	int ret = 0;
-	int t;
 
 	next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
 	atomic_inc(&vmbus_connection.next_gpadl_handle);
@@ -410,9 +409,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
 		}
 	}
-	t = wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
-	BUG_ON(t == 0);
-
+	wait_for_completion(&msginfo->waitevent);
 
 	/* At this point, we received the gpadl created msg */
 	*gpadl_handle = gpadlmsg->gpadl;
-- 
1.7.4.1

