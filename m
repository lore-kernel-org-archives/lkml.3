Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbaJaIXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:23:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbaJaIX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:23:27 -0400
From: Jan Kara <jack@suse.cz>
To: axboe@kernel.dk
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] block: Fix computation of merged request priority
Date: Thu, 30 Oct 2014 20:43:38 +0100
Message-Id: <1414698218-11199-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Priority of a merged request is computed by ioprio_best(). If one of the
requests has undefined priority (IOPRIO_CLASS_NONE) and another request
has priority from IOPRIO_CLASS_BE, the function will return the
undefined priority which is wrong. Fix the function to properly return
priority of a request with the defined priority.

Fixes: d58cdfb89ce0c6bd5f81ae931a984ef298dbda20
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/ioprio.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/ioprio.c b/block/ioprio.c
index e50170ca7c33..3a71df7f38cb 100644
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
 
+ 	aclass = IOPRIO_PRIO_CLASS(aprio);
+	bclass = IOPRIO_PRIO_CLASS(bprio);
 	if (aclass == bclass)
 		return min(aprio, bprio);
 	if (aclass > bclass)
-- 
1.8.1.4

