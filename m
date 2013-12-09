Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676Ab3LIM7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:59:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:48424 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab3LIM72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:59:28 -0500
From: Chris Redpath <chris.redpath@arm.com>
To: pjt@google.com, mingo@redhat.com, peterz@infradead.org,
        alex.shi@linaro.org, morten.rasmussen@arm.com,
        dietmar.eggemann@arm.com
Cc: linux-kernel@vger.kernel.org, Chris Redpath <chris.redpath@arm.com>
Subject: [PATCH 1/2] sched: reset blocked load decay_count during synchronization
Date: Mon,  9 Dec 2013 12:59:09 +0000
Message-Id: <1386593950-26475-2-git-send-email-chris.redpath@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
X-OriginalArrivalTime: 09 Dec 2013 12:59:25.0991 (UTC) FILETIME=[7D266B70:01CEF4DE]
X-MC-Unique: 113120912592701001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rB9CxwZ3005437

If an entity happens to sleep for less than one tick duration
the tracked load associated with that entity can be decayed by an
unexpectedly large amount if it is later migrated to a different
CPU. This can interfere with correct scheduling when entity load
is used for decision making.

The reason for this is that when an entity is dequeued and enqueued
quickly, such that se.avg.decay_count and cfs_rq.decay_counter
do not differ when that entity is enqueued again,
__synchronize_entity_decay skips the calculation step and also skips
clearing the decay_count. At a later time that entity may be
migrated and its load will be decayed incorrectly.

All users of this function expect decay_count to be zero'ed after
use.

Signed-off-by: Chris Redpath <chris.redpath@arm.com>
---
 kernel/sched/fair.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e8b652e..b7e5945 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2142,12 +2142,10 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 	u64 decays = atomic64_read(&cfs_rq->decay_counter);
 
 	decays -= se->avg.decay_count;
-	if (!decays)
-		return 0;
-
-	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
+	if (decays)
+		se->avg.load_avg_contrib =
+			decay_load(se->avg.load_avg_contrib, decays);
 	se->avg.decay_count = 0;
-
 	return decays;
 }
 
-- 
1.7.9.5


