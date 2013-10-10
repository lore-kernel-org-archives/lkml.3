Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3JJPyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:54:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab3JJPu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 030/104] cfq: explicitly use 64bit divide operation for 64bit arguments
Date: Thu, 10 Oct 2013 08:41:18 -0700
Message-Id: <1381419752-29733-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatol Pomozov <anatol.pomozov@gmail.com>

commit f3cff25f05f2ac29b2ee355e611b0657482f6f1d upstream.

'samples' is 64bit operant, but do_div() second parameter is 32.
do_div silently truncates high 32 bits and calculated result
is invalid.

In case if low 32bit of 'samples' are zeros then do_div() produces
kernel crash.

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 block/cfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e62e920..1a872282 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1484,7 +1484,7 @@ static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
 
 	if (samples) {
 		v = blkg_stat_read(&cfqg->stats.avg_queue_size_sum);
-		do_div(v, samples);
+		v = div64_u64(v, samples);
 	}
 	__blkg_prfill_u64(sf, pd, v);
 	return 0;
-- 
1.8.1.2

