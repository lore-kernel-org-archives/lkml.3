Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaE0RQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbaE0RQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:16:33 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org
Subject: [PATCH] hv: use correct order when freeing monitor_pages
Date: Tue, 27 May 2014 19:16:20 +0200
Message-Id: <1401210980-2515-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We try to free two pages when only one has been allocated.
Cleanup path is unlikely, so I haven't found any trace that would fit,
but I hope that free_pages_prepare() does catch it.

Cc: stable@vger.kernel.org
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 Cc'd stable because the worst-case looks hard to debug.
 Btw. the module can't get unloaded after we successfully connect?

 drivers/hv/connection.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 7f10c15..e84f452 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -224,8 +224,8 @@ cleanup:
 		vmbus_connection.int_page = NULL;
 	}
 
-	free_pages((unsigned long)vmbus_connection.monitor_pages[0], 1);
-	free_pages((unsigned long)vmbus_connection.monitor_pages[1], 1);
+	free_pages((unsigned long)vmbus_connection.monitor_pages[0], 0);
+	free_pages((unsigned long)vmbus_connection.monitor_pages[1], 0);
 	vmbus_connection.monitor_pages[0] = NULL;
 	vmbus_connection.monitor_pages[1] = NULL;
 
-- 
1.9.3

