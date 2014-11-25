Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaKYLNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:13:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaKYKmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 162/254] block: Fix computation of merged request priority
Date: Tue, 25 Nov 2014 10:38:32 +0000
Message-Id: <1416912004-5928-163-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit ece9c72accdc45c3a9484dacb1125ce572647288 upstream.

Priority of a merged request is computed by ioprio_best(). If one of the
requests has undefined priority (IOPRIO_CLASS_NONE) and another request
has priority from IOPRIO_CLASS_BE, the function will return the
undefined priority which is wrong. Fix the function to properly return
priority of a request with the defined priority.

Fixes: d58cdfb89ce0c6bd5f81ae931a984ef298dbda20
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/ioprio.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/ioprio.c b/block/ioprio.c
index e50170ca7c33..31666c92b46a 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -157,14 +157,16 @@ out:
 
 int ioprio_best(unsigned short aprio, unsigned short bprio)
 {
-	unsigned short aclass = IOPRIO_PRIO_CLASS(aprio);
-	unsigned short bclass = IOPRIO_PRIO_CLASS(bprio);
+	unsigned short aclass;
+	unsigned short bclass;
 
-	if (aclass == IOPRIO_CLASS_NONE)
-		aclass = IOPRIO_CLASS_BE;
-	if (bclass == IOPRIO_CLASS_NONE)
-		bclass = IOPRIO_CLASS_BE;
+	if (!ioprio_valid(aprio))
+		aprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_NORM);
+	if (!ioprio_valid(bprio))
+		bprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_NORM);
 
+	aclass = IOPRIO_PRIO_CLASS(aprio);
+	bclass = IOPRIO_PRIO_CLASS(bprio);
 	if (aclass == bclass)
 		return min(aprio, bprio);
 	if (aclass > bclass)
-- 
2.1.0

