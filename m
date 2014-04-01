Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaDALRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:17:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaDALRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomoki Sekiyama <tomoki.sekiyama@hds.com>, Jens Axboe <axboe@kernel.dk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <christian@borntraeger.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 075/144] s390/dasd: hold request queue sysfs lock when calling elevator_init()
Date: Tue,  1 Apr 2014 12:14:39 +0100
Message-Id: <1396350948-29910-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit ef0899410ff630b2e75306da49996dbbfa318165 upstream.

"elevator: Fix a race in elevator switching and md device initialization"
changed the semantics of elevator_init() in a way that now enforces to hold
the corresponding request queue's sysfs_lock when calling elevator_init()
to fix a race.
The patch did not convert the s390 dasd device driver which is the only
device driver which also calls elevator_init(). So add the missing locking.

Cc: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Christian Borntraeger <christian@borntraeger.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/block/dasd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 451bf99..846d5c6 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2978,12 +2978,12 @@ static int dasd_alloc_queue(struct dasd_block *block)
 
 	elevator_exit(block->request_queue->elevator);
 	block->request_queue->elevator = NULL;
+	mutex_lock(&block->request_queue->sysfs_lock);
 	rc = elevator_init(block->request_queue, "deadline");
-	if (rc) {
+	if (rc)
 		blk_cleanup_queue(block->request_queue);
-		return rc;
-	}
-	return 0;
+	mutex_unlock(&block->request_queue->sysfs_lock);
+	return rc;
 }
 
 /*
-- 
1.9.1

