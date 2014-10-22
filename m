Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaJVNdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:33:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaJVNdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:33:06 -0400
Date: Wed, 22 Oct 2014 09:32:38 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
        Jonathan Brassow <jbrassow@redhat.com>,
        Edward Thornber <thornber@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 15/18] dm kcopyd: introduce the function submit_job
In-Reply-To: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1410220932130.31351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We move some code to a function submit_job. It is needed for the next
patch that calls submit_job from another place.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

Index: linux-3.16-rc5/drivers/md/dm-kcopyd.c
===================================================================
--- linux-3.16-rc5.orig/drivers/md/dm-kcopyd.c	2014-07-14 16:45:23.000000000 +0200
+++ linux-3.16-rc5/drivers/md/dm-kcopyd.c	2014-07-14 17:28:36.000000000 +0200
@@ -698,6 +698,17 @@ static void split_job(struct kcopyd_job 
 	}
 }
 
+static void submit_job(struct kcopyd_job *job)
+{
+	if (job->source.count <= SUB_JOB_SIZE)
+		dispatch_job(job);
+	else {
+		mutex_init(&job->lock);
+		job->progress = 0;
+		split_job(job);
+	}
+}
+
 int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 		   unsigned int num_dests, struct dm_io_region *dests,
 		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
@@ -746,13 +757,7 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 	job->context = context;
 	job->master_job = job;
 
-	if (job->source.count <= SUB_JOB_SIZE)
-		dispatch_job(job);
-	else {
-		mutex_init(&job->lock);
-		job->progress = 0;
-		split_job(job);
-	}
+	submit_job(job);
 
 	return 0;
 }

