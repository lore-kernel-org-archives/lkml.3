Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016Ab3AOXRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:17:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:47431 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933949Ab3AOWxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>
Subject: [ 166/171] ceph: Fix __ceph_do_pending_vmtruncate
Date: Tue, 15 Jan 2013 14:45:31 -0800
Message-Id: <20130115224325.295830336@linuxfoundation.org>
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

we should set i_truncate_pending to 0 after page cache is truncated
to i_truncate_size

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
(cherry picked from commit a85f50b6ef93fbbb2ae932ce9b2376509d172796)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/inode.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1466,7 +1466,7 @@ void __ceph_do_pending_vmtruncate(struct
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u64 to;
-	int wrbuffer_refs, wake = 0;
+	int wrbuffer_refs, finish = 0;
 
 retry:
 	spin_lock(&ci->i_ceph_lock);
@@ -1498,15 +1498,18 @@ retry:
 	truncate_inode_pages(inode->i_mapping, to);
 
 	spin_lock(&ci->i_ceph_lock);
-	ci->i_truncate_pending--;
-	if (ci->i_truncate_pending == 0)
-		wake = 1;
+	if (to == ci->i_truncate_size) {
+		ci->i_truncate_pending = 0;
+		finish = 1;
+	}
 	spin_unlock(&ci->i_ceph_lock);
+	if (!finish)
+		goto retry;
 
 	if (wrbuffer_refs == 0)
 		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
-	if (wake)
-		wake_up_all(&ci->i_cap_wq);
+
+	wake_up_all(&ci->i_cap_wq);
 }
 
 


