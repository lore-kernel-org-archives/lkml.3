Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab3FEV3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:29:13 -0400
Received: from mail.ispras.ru ([83.149.199.45]:48358 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3FEV3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:29:12 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] GFS2: fix error propagation in init_threads()
Date: Thu,  6 Jun 2013 01:29:04 +0400
Message-Id: <1370467744-4533-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kthread_run() fails, init_threads() returns
IS_ERR(p) instead of PTR_ERR(p).

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/gfs2/ops_fstype.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 60ede2a..0262c19 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -916,16 +916,16 @@ static int init_threads(struct gfs2_sbd *sdp, int undo)
 		goto fail_quotad;
 
 	p = kthread_run(gfs2_logd, sdp, "gfs2_logd");
-	error = IS_ERR(p);
-	if (error) {
+	if (IS_ERR(p)) {
+		error = PTR_ERR(p);
 		fs_err(sdp, "can't start logd thread: %d\n", error);
 		return error;
 	}
 	sdp->sd_logd_process = p;
 
 	p = kthread_run(gfs2_quotad, sdp, "gfs2_quotad");
-	error = IS_ERR(p);
-	if (error) {
+	if (IS_ERR(p)) {
+		error = PTR_ERR(p);
 		fs_err(sdp, "can't start quotad thread: %d\n", error);
 		goto fail;
 	}
-- 
1.8.1.2

