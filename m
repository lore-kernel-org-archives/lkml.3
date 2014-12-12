Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966108AbaLLGsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:48:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbaLLGsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:31 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sitsofe Wheeler" <sitsofe@yahoo.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.361486055@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 021/164] Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
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

commit 72c6b71c245dac8f371167d97ef471b367d0b66b upstream.

Eliminate the call to BUG_ON() by waiting for the host to respond. We are
trying to reclaim the ownership of memory that was given to the host and so
we will have to wait until the host responds.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hv/channel.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -400,7 +400,6 @@ int vmbus_establish_gpadl(struct vmbus_c
 	u32 next_gpadl_handle;
 	unsigned long flags;
 	int ret = 0;
-	int t;
 
 	next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
 	atomic_inc(&vmbus_connection.next_gpadl_handle);
@@ -447,9 +446,7 @@ int vmbus_establish_gpadl(struct vmbus_c
 
 		}
 	}
-	t = wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
-	BUG_ON(t == 0);
-
+	wait_for_completion(&msginfo->waitevent);
 
 	/* At this point, we received the gpadl created msg */
 	*gpadl_handle = gpadlmsg->gpadl;

