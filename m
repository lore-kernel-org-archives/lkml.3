Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab3HSWqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:46:04 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:33221 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3HSWqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:46:02 -0400
From: Peter Wu <lekensteyn@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] writeback: fix NULL dereference when device is gone
Date: Tue, 20 Aug 2013 00:45:53 +0200
Message-ID: <5177367.3UXkd1Z6lS@al>
User-Agent: KMail/4.11 (Linux/3.11.0-rc6-git-dirty+; KDE/4.11.0; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1308172104070.7744-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1308172104070.7744-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Wu <lekensteyn@gmail.com>

This solves a BUG followed by a lockup in the following case:

1. Connect device and look in dmesg for the address:

    [   40.034520] usb 6-2: Product: My Passport 0748

2. Write something:

    dd if=/dev/zero of=/dev/sdd bs=1M

3. Remove device:

    echo 1 > /sys/bus/usb/devices/6-2/remove

4. Machine locks up (because the work queue got stuck?).

Signed-off-by: Peter Wu <lekensteyn@gmail.com>
---
 fs/fs-writeback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 68851ff..6e38a8b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1007,7 +1007,8 @@ void bdi_writeback_workfn(struct work_struct *work)
 	struct backing_dev_info *bdi = wb->bdi;
 	long pages_written;
 
-	set_worker_desc("flush-%s", dev_name(bdi->dev));
+	if (bdi->dev)
+		set_worker_desc("flush-%s", dev_name(bdi->dev));
 	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
-- 
1.8.3.4
