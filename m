Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbaEAIP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:15:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43447 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaEAIPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:15:24 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-spi@vger.kernel.org, broonie@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] spi: Fix hung task timeout when initialization fails
Date: Thu,  1 May 2014 10:15:15 +0200
Message-Id: <1398932115-11646-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kthread_run on spi_init_queue() fails, spi_destroy_queue can lead to
hang timeout.

Before 786235eeba0e1e85e5cbbb9f97d1087ad03dfa21 kthread:
make kthread_create() killable" it was very unlikely that kthread_run
would fail, but after that patch a kill to modprobe can lead to this
kind of error. Udev kills modprobe after 30 seconds.

When this happens, spi_destroy_queue() leads to a hung process that
outputs a error message and avoids the computer to be halted/rebooted.

This bug is particulary critical on machines that relay on the spi
subsystem to hold a file system (MTD over SPI).

[   95.900328] spi_master spi32765: failed to create message pump task
[   95.900358] spi_master spi32765: problem initializing queue
[   95.912333] qtec_pcie b0030000.pcie_bridge: Axi-pcie bridge supervisor
[  240.463698] INFO: task udevd:129 blocked for more than 120 seconds.
[  240.463733] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.463807] Call Trace:
[  240.463968]  [<ffffffff8178c22d>] wait_for_completion+0x1d/0x20
[  240.464036]  [<ffffffff8146c637>] spi_destroy_queue+0x27/0x60
[  240.464050]  [<ffffffff8146cc46>] spi_register_master+0x5d6/0x900

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

v2: Comment by Mark Brown:
-Improve commit message

 drivers/spi/spi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 4eb9bf0..8331556 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1114,8 +1114,10 @@ static int spi_destroy_queue(struct spi_master *master)
 		return ret;
 	}
 
-	flush_kthread_worker(&master->kworker);
-	kthread_stop(master->kworker_task);
+	if (!IS_ERR(master->kworker_task)) {
+		flush_kthread_worker(&master->kworker);
+		kthread_stop(master->kworker_task);
+	}
 
 	return 0;
 }
-- 
1.9.2

