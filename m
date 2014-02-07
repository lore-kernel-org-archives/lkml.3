Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaBGLwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42373 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbaBGLwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 196/233] zram: fix race between reset and flushing pending work
Date: Fri,  7 Feb 2014 11:46:55 +0000
Message-Id: <1391773652-25214-197-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: zram is still a staging driver in 3.11 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index dda8771..fc540ea 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -551,14 +551,14 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
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
 
-- 
1.8.3.2

