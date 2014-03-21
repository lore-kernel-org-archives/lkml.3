Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966636AbaCUA1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:27:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966001AbaCUAJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        Jens Axboe <axboe@kernel.dk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <christian@borntraeger.net>
Subject: [PATCH 3.10 75/85] s390/dasd: hold request queue sysfs lock when calling elevator_init()
Date: Thu, 20 Mar 2014 17:10:18 -0700
Message-Id: <20140321000609.441627130@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2879,12 +2879,12 @@ static int dasd_alloc_queue(struct dasd_
 
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


