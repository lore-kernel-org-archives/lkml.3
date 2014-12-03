Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaLCL5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:57:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbaLCL1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 045/101] block: Fix computation of merged request priority
Date: Wed,  3 Dec 2014 12:26:07 +0100
Message-Id: <a39c8649e480bf8bf6419bc1ed6c8d66fbc89ebb.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ioprio.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ioprio.c b/fs/ioprio.c
index e50170ca7c33..31666c92b46a 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
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
2.1.3

