Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3GAKBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:01:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab3GAJ76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:59:58 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/12] GFS2: fix error propagation in init_threads()
Date: Mon,  1 Jul 2013 10:33:08 +0100
Message-Id: <1372671195-3472-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

If kthread_run() fails, init_threads() returns
IS_ERR(p) instead of PTR_ERR(p).

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

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
1.7.4

