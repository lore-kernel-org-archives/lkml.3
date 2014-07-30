Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaG3Bwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:52:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbaG3BuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.15 16/37] zram: avoid lockdep splat by revalidate_disk
Date: Tue, 29 Jul 2014 18:48:52 -0700
Message-Id: <20140730014828.467162387@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minchan Kim <minchan@kernel.org>

commit b4c5c60920e3b0c4598f43e7317559f6aec51531 upstream.

Sasha reported lockdep warning [1] introduced by [2].

It could be fixed by doing disk revalidation out of the init_lock.  It's
okay because disk capacity change is protected by init_lock so that
revalidate_disk always sees up-to-date value so there is no race.

[1] https://lkml.org/lkml/2014/7/3/735
[2] zram: revalidate disk after capacity change

Fixes 2e32baea46ce ("zram: revalidate disk after capacity change").

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/zram/zram_drv.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -622,11 +622,18 @@ static void zram_reset_device(struct zra
 	memset(&zram->stats, 0, sizeof(zram->stats));
 
 	zram->disksize = 0;
-	if (reset_capacity) {
+	if (reset_capacity)
 		set_capacity(zram->disk, 0);
-		revalidate_disk(zram->disk);
-	}
+
 	up_write(&zram->init_lock);
+
+	/*
+	 * Revalidate disk out of the init_lock to avoid lockdep splat.
+	 * It's okay because disk's capacity is protected by init_lock
+	 * so that revalidate_disk always sees up-to-date capacity.
+	 */
+	if (reset_capacity)
+		revalidate_disk(zram->disk);
 }
 
 static ssize_t disksize_store(struct device *dev,
@@ -666,8 +673,15 @@ static ssize_t disksize_store(struct dev
 	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	revalidate_disk(zram->disk);
 	up_write(&zram->init_lock);
+
+	/*
+	 * Revalidate disk out of the init_lock to avoid lockdep splat.
+	 * It's okay because disk's capacity is protected by init_lock
+	 * so that revalidate_disk always sees up-to-date capacity.
+	 */
+	revalidate_disk(zram->disk);
+
 	return len;
 
 out_destroy_comp:


