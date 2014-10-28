Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaJ1Dhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:37:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaJ1Dhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [PATCH 3.17 048/146] Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
Date: Tue, 28 Oct 2014 11:33:10 +0800
Message-Id: <20141028033345.496707697@linuxfoundation.org>
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

commit 72c6b71c245dac8f371167d97ef471b367d0b66b upstream.

Eliminate the call to BUG_ON() by waiting for the host to respond. We are
trying to reclaim the ownership of memory that was given to the host and so
we will have to wait until the host responds.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/channel.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -363,7 +363,6 @@ int vmbus_establish_gpadl(struct vmbus_c
 	u32 next_gpadl_handle;
 	unsigned long flags;
 	int ret = 0;
-	int t;
 
 	next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
 	atomic_inc(&vmbus_connection.next_gpadl_handle);
@@ -410,9 +409,7 @@ int vmbus_establish_gpadl(struct vmbus_c
 
 		}
 	}
-	t = wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
-	BUG_ON(t == 0);
-
+	wait_for_completion(&msginfo->waitevent);
 
 	/* At this point, we received the gpadl created msg */
 	*gpadl_handle = gpadlmsg->gpadl;


