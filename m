Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954Ab3AOWx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:53:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:47420 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933926Ab3AOWxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>
Subject: [ 165/171] ceph: Dont add dirty inode to dirty list if caps is in migration
Date: Tue, 15 Jan 2013 14:45:30 -0800
Message-Id: <20130115224325.223499549@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Yan, Zheng" <zheng.z.yan@intel.com>

Add dirty inode to cap_dirty_migrating list instead, this can avoid
ceph_flush_dirty_caps() entering infinite loop.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
(cherry picked from commit 0685235ffd9dbdb9ccbda587f8a3c83ad1d5a921)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1349,11 +1349,15 @@ int __ceph_mark_dirty_caps(struct ceph_i
 		if (!ci->i_head_snapc)
 			ci->i_head_snapc = ceph_get_snap_context(
 				ci->i_snap_realm->cached_context);
-		dout(" inode %p now dirty snapc %p\n", &ci->vfs_inode,
-			ci->i_head_snapc);
+		dout(" inode %p now dirty snapc %p auth cap %p\n",
+		     &ci->vfs_inode, ci->i_head_snapc, ci->i_auth_cap);
 		BUG_ON(!list_empty(&ci->i_dirty_item));
 		spin_lock(&mdsc->cap_dirty_lock);
-		list_add(&ci->i_dirty_item, &mdsc->cap_dirty);
+		if (ci->i_auth_cap)
+			list_add(&ci->i_dirty_item, &mdsc->cap_dirty);
+		else
+			list_add(&ci->i_dirty_item,
+				 &mdsc->cap_dirty_migrating);
 		spin_unlock(&mdsc->cap_dirty_lock);
 		if (ci->i_flushing_caps == 0) {
 			ihold(inode);


