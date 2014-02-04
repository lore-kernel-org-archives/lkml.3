Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934974AbaBDV3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:29:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934640AbaBDVMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 105/140] zram: fix race between reset and flushing pending work
Date: Tue,  4 Feb 2014 13:11:32 -0800
Message-Id: <20140204211039.973549084@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minchan Kim <minchan@kernel.org>

commit da4a04126baa3be03bc566d4a2ee0944c5e783d0 upstream.

Dan and Sergey reported that there is a racy between reset and flushing
of pending work so that it could make oops by freeing zram->meta in
reset while zram_slot_free can access zram->meta if new request is
adding during the race window.

This patch moves flush after taking init_lock so it prevents new request
so that it closes the race.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -552,14 +552,14 @@ static void zram_reset_device(struct zra
 	size_t index;
 	struct zram_meta *meta;
 
-	flush_work(&zram->free_work);
-
 	down_write(&zram->init_lock);
 	if (!zram->init_done) {
 		up_write(&zram->init_lock);
 		return;
 	}
 
+	flush_work(&zram->free_work);
+
 	meta = zram->meta;
 	zram->init_done = 0;
 


