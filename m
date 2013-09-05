Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab3IEWXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:23:23 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:33445 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3IEWXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:23:20 -0400
Date: Thu, 5 Sep 2013 18:23:19 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        jiayisuse@gmail.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] ceph: Do not do invalidate if the filesystem is mounted
 nofsc
Message-ID: <ed0af89bd01410f38f017ad4de6e1bd94c79e738.1378418255.git.milosz@adfin.com>
References: <cover.1378418255.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378418255.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we would always try to enqueue work even if the filesystem is not
mounted with fscache enabled (or the file has no cookie). In the case of the
filesystem mouned nofsc (but with fscache compiled in) this would lead to a
crash.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/ceph/cache.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index c737ae9..d3b88c7 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -374,8 +374,12 @@ out:
 
 void ceph_queue_revalidate(struct inode *inode)
 {
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
+	if (fsc->revalidate_wq == NULL || ci->fscache == NULL)
+		return;
+
 	ihold(inode);
 
 	if (queue_work(ceph_sb_to_client(inode->i_sb)->revalidate_wq,
-- 
1.7.9.5

