Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3JCVNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:13:48 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48746 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab3JCVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:13:47 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Alex Dubov <oakad@yahoo.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] memstick: Fix memory leak in memstick_check() error path
Date: Thu,  3 Oct 2013 16:13:18 -0500
Message-Id: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel 3.12-rc3, kemcheck reports the following leak:

> unreferenced object 0xffff8800ae85c190 (size 16):
>   comm "kworker/u4:3", pid 685, jiffies 4294916336 (age 2831.760s)
>   hex dump (first 16 bytes):
>     6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
>   backtrace:
>     [<ffffffff8146a0d1>] kmemleak_alloc+0x21/0x50
>     [<ffffffff81160720>] __kmalloc_track_caller+0x160/0x2f0
>     [<ffffffff81237b9b>] kvasprintf+0x5b/0x90
>     [<ffffffff8122c0c1>] kobject_set_name_vargs+0x21/0x60
>     [<ffffffff812e7f5c>] dev_set_name+0x3c/0x40
>     [<ffffffffa02bf918>] memstick_check+0xb8/0x340 [memstick]
>     [<ffffffff81069862>] process_one_work+0x1d2/0x670
>     [<ffffffff8106a88a>] worker_thread+0x11a/0x370
>     [<ffffffff81072ea6>] kthread+0xd6/0xe0
>     [<ffffffff81478bbc>] ret_from_fork+0x7c/0xb0

This problem was introduced by commit 0252c3b "memstick: struct device -
replace bus_id with dev_name(), dev_set_name() where the name is not freed
in the error path.

Thanks to Catalin Marinas for suggesting the fix.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/memstick/core/memstick.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index ffcb10a..0c73a45 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -415,6 +415,7 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 	return card;
 err_out:
 	host->card = old_card;
+	kfree(card->dev.kobj.name);
 	kfree(card);
 	return NULL;
 }
-- 
1.8.1.4

