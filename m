Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbaAMQEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:04:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53375 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaAMQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianpeng Ma <majianpeng@gmail.com>, Sage Weil <sage@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 117/208] ceph: Add check returned value on func ceph_calc_ceph_pg.
Date: Mon, 13 Jan 2014 15:59:18 +0000
Message-Id: <1389628849-1614-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 2fbcbff1d6b9243ef71c64a8ab993bc3c7bb7af1 upstream.

Func ceph_calc_ceph_pg maybe failed.So add check for returned value.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ceph/ioctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index a5ce62e..669622f 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -211,8 +211,12 @@ static long ceph_ioctl_get_dataloc(struct file *file, void __user *arg)
 	snprintf(dl.object_name, sizeof(dl.object_name), "%llx.%08llx",
 		 ceph_ino(inode), dl.object_no);
 
-	ceph_calc_ceph_pg(&pgid, dl.object_name, osdc->osdmap,
-		ceph_file_layout_pg_pool(ci->i_layout));
+	r = ceph_calc_ceph_pg(&pgid, dl.object_name, osdc->osdmap,
+				ceph_file_layout_pg_pool(ci->i_layout));
+	if (r < 0) {
+		up_read(&osdc->map_sem);
+		return r;
+	}
 
 	dl.osd = ceph_calc_pg_primary(osdc->osdmap, pgid);
 	if (dl.osd >= 0) {
-- 
1.8.3.2

