Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaFKVoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:44:19 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:35164 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaFKVoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:44:18 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH] block: remove WQ_POWER_EFFICIENT from kblockd
Date: Wed, 11 Jun 2014 23:43:54 +0200
Message-Id: <1402523034-24193-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk-mq issues async requests through kblockd. To issue a work request on a
specific CPU, kblockd_schedule_delayed_work_on is used. However, the CPU can
change if the machine is a laptop or similar. In that case its
workqueue.power_efficient parameter is set to true. That enables kblockd to be
WQ_UNBOUND by default. Leaving blk-mq to bounce its hw ctx queues between CPUs.

Remove the kblockd WQ_POWER_EFFICIENT flag to prevent this behavior.

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 block/blk-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f6f6b9a..6f8dba1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3312,8 +3312,7 @@ int __init blk_dev_init(void)
 
 	/* used for unplugging and affects IO latency/throughput - HIGHPRI */
 	kblockd_workqueue = alloc_workqueue("kblockd",
-					    WQ_MEM_RECLAIM | WQ_HIGHPRI |
-					    WQ_POWER_EFFICIENT, 0);
+					    WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!kblockd_workqueue)
 		panic("Failed to create kblockd\n");
 
-- 
1.9.1

