Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799Ab3AOXZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:25:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:47120 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933746Ab3AOWw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>,
        Alex Elder <elder@inktank.com>
Subject: [ 139/171] ceph: tolerate (and warn on) extraneous dentry from mds
Date: Tue, 15 Jan 2013 14:45:04 -0800
Message-Id: <20130115224323.369234213@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Sage Weil <sage@inktank.com>

If the MDS gives us a dentry and we weren't prepared to handle it,
WARN_ON_ONCE instead of crashing.

Reported-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
(cherry picked from commit 6c5e50fa614fea5325a2973be06f7ec6f1055316)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/inode.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -992,11 +992,15 @@ int ceph_fill_trace(struct super_block *
 	if (rinfo->head->is_dentry) {
 		struct inode *dir = req->r_locked_dir;
 
-		err = fill_inode(dir, &rinfo->diri, rinfo->dirfrag,
-				 session, req->r_request_started, -1,
-				 &req->r_caps_reservation);
-		if (err < 0)
-			return err;
+		if (dir) {
+			err = fill_inode(dir, &rinfo->diri, rinfo->dirfrag,
+					 session, req->r_request_started, -1,
+					 &req->r_caps_reservation);
+			if (err < 0)
+				return err;
+		} else {
+			WARN_ON_ONCE(1);
+		}
 	}
 
 	/*
@@ -1004,6 +1008,7 @@ int ceph_fill_trace(struct super_block *
 	 * will have trouble splicing in the virtual snapdir later
 	 */
 	if (rinfo->head->is_dentry && !req->r_aborted &&
+	    req->r_locked_dir &&
 	    (rinfo->head->is_target || strncmp(req->r_dentry->d_name.name,
 					       fsc->mount_options->snapdir_name,
 					       req->r_dentry->d_name.len))) {


