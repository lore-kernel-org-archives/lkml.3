Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3HSW1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:27:13 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62575 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3HSW1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:27:11 -0400
Date: Mon, 19 Aug 2013 15:27:18 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: bcache: Fix a writeback performance regression
Message-ID: <20130819222718.GA32104@kmo-pixel>
References: <20130814225904.GA6427@kmo-pixel>
 <520C788A.1060208@profihost.ag>
 <520DFAB4.1050402@profihost.ag>
 <52114614.4070509@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52114614.4070509@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 12:09:24AM +0200, Stefan Priebe wrote:
> 
> Vanilla 3.10.7 + bcache: Fix a writeback performance regression
> 
> http://pastebin.com/raw.php?i=LXZk4cMH

Whoops, at first I thought this was the same bug as one I'd already been
chasing down that had been a harmless bug - turns out I didn't look
closely enough at the backtrace.

What happened is background writeback is deadlocking, because for some
reason the workqueue it's running out of is a singlethreaded workqueue,
so as soon as it decides to queue enough writeback bios that it has to
sleep on that semaphore (which often won't happen due to the PD
controller based ratelimiting) - boom, deadlock.

Here's the fixup patch I just tested and am applying:


>From 0af68de350e05e43fd093b36dcb0fe8aa838fabf Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kmo@daterainc.com>
Date: Mon, 19 Aug 2013 15:26:22 -0700
Subject: [PATCH] bcache: Fix a writeback deadlock

Signed-off-by: Kent Overstreet <kmo@daterainc.com>

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index f88c62e..27ac519 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -351,7 +351,7 @@ static void write_dirty(struct closure *cl)
 
 	closure_bio_submit(&io->bio, cl, &io->dc->disk);
 
-	continue_at(cl, write_dirty_finish, dirty_wq);
+	continue_at(cl, write_dirty_finish, system_wq);
 }
 
 static void read_dirty_endio(struct bio *bio, int error)
@@ -371,7 +371,7 @@ static void read_dirty_submit(struct closure *cl)
 
 	closure_bio_submit(&io->bio, cl, &io->dc->disk);
 
-	continue_at(cl, write_dirty, dirty_wq);
+	continue_at(cl, write_dirty, system_wq);
 }
 
 static void read_dirty(struct closure *cl)
@@ -512,7 +512,7 @@ void bch_writeback_exit(void)
 
 int __init bch_writeback_init(void)
 {
-	dirty_wq = create_singlethread_workqueue("bcache_writeback");
+	dirty_wq = create_workqueue("bcache_writeback");
 	if (!dirty_wq)
 		return -ENOMEM;
 
