Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbaJ2Sgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:36:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:8255 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585AbaJ2Sgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:36:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,278,1413270000"; 
   d="scan'208";a="622959122"
Subject: [RFC PATCH 2/5] block: ioprio hint to low-level device drivers
From: "Jason B. Akers" <jason.b.akers@intel.com>
To: linux-ide@vger.kernel.org
Cc: axboe@fb.com, dan.j.williams@intel.com, kapil.karkra@intel.com,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Oct 2014 11:23:53 -0700
Message-ID: <20141029182353.4879.67152.stgit@stg-AndroidDev-VirtualBox>
In-Reply-To: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
User-Agent: StGit/0.17.1-4-g4a0c1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

The priority in the io_context is consumed by the io scheduler.  For
caching advice we need the request->ioprio field to be up-to-date.  Set
the bio ioprio at submit time.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jason B. Akers <jason.b.akers@intel.com>
---
 block/bio.c    |    1 +
 block/ioprio.c |   22 ++++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 3e6e198..e133b5c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2009,6 +2009,7 @@ int bio_associate_current(struct bio *bio)
 	/* acquire active ref on @ioc and associate */
 	get_io_context_active(ioc);
 	bio->bi_ioc = ioc;
+	bio_set_prio(bio, ioprio_best(ioc->ioprio, bio_prio(bio)));
 
 	/* associate blkcg if exists */
 	rcu_read_lock();
diff --git a/block/ioprio.c b/block/ioprio.c
index e50170c..fec1202 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -159,18 +159,28 @@ int ioprio_best(unsigned short aprio, unsigned short bprio)
 {
 	unsigned short aclass = IOPRIO_PRIO_CLASS(aprio);
 	unsigned short bclass = IOPRIO_PRIO_CLASS(bprio);
+	unsigned short class, data, advice;
 
 	if (aclass == IOPRIO_CLASS_NONE)
 		aclass = IOPRIO_CLASS_BE;
 	if (bclass == IOPRIO_CLASS_NONE)
 		bclass = IOPRIO_CLASS_BE;
 
-	if (aclass == bclass)
-		return min(aprio, bprio);
-	if (aclass > bclass)
-		return bprio;
-	else
-		return aprio;
+	/* best priority */
+	if (aclass == bclass) {
+		class = aclass;
+		data = min(IOPRIO_PRIO_DATA(aprio), IOPRIO_PRIO_DATA(bprio));
+	} else if (aclass > bclass) {
+		class = bclass;
+		data = IOPRIO_PRIO_DATA(bprio);
+	} else {
+		class = aclass;
+		data = IOPRIO_PRIO_DATA(aprio);
+	}
+
+	/* best cache advice, assumes invalid advice is zero */
+	advice = max(IOPRIO_ADVICE(aprio), IOPRIO_ADVICE(bprio));
+	return IOPRIO_ADVISE(class, data, advice);
 }
 
 SYSCALL_DEFINE2(ioprio_get, int, which, int, who)

