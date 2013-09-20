Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3ITUKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:10:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41316 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3ITUKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianpeng Ma <majianpeng@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 08/93] ceph: Don't forget the 'up_read(&osdc->map_sem)' if met error.
Date: Fri, 20 Sep 2013 13:08:03 -0700
Message-Id: <1379707768-1804-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 494ddd11be3e2621096bb425eed2886f8e8446d4 upstream.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ceph/ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index 36549a4..c171111 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -197,8 +197,10 @@ static long ceph_ioctl_get_dataloc(struct file *file, void __user *arg)
 	r = ceph_calc_file_object_mapping(&ci->i_layout, dl.file_offset, &len,
 					  &dl.object_no, &dl.object_offset,
 					  &olen);
-	if (r < 0)
+	if (r < 0) {
+		up_read(&osdc->map_sem);
 		return -EIO;
+	}
 	dl.file_offset -= dl.object_offset;
 	dl.object_size = ceph_file_layout_object_size(ci->i_layout);
 	dl.block_size = ceph_file_layout_su(ci->i_layout);
-- 
1.8.1.2

