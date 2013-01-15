Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3AOWi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:38:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:44076 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957Ab3AOWgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>
Subject: [ 217/221] ceph: call handle_cap_grant() for cap import message
Date: Tue, 15 Jan 2013 10:52:24 -0800
Message-Id: <20130115185013.702613632@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Yan, Zheng" <zheng.z.yan@intel.com>

(cherry picked from commit 0e5e1774a92e6fe9c511585de8f078b4c4c68dbb)

If client sends cap message that requests new max size during
exporting caps, the exporting MDS will drop the message quietly.
So the client may wait for the reply that updates the max size
forever. call handle_cap_grant() for cap import message can
avoid this issue.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2749,6 +2749,7 @@ static void handle_cap_import(struct cep
 
 	/* make sure we re-request max_size, if necessary */
 	spin_lock(&ci->i_ceph_lock);
+	ci->i_wanted_max_size = 0;  /* reset */
 	ci->i_requested_max_size = 0;
 	spin_unlock(&ci->i_ceph_lock);
 }
@@ -2844,8 +2845,6 @@ void ceph_handle_caps(struct ceph_mds_se
 	case CEPH_CAP_OP_IMPORT:
 		handle_cap_import(mdsc, inode, h, session,
 				  snaptrace, snaptrace_len);
-		ceph_check_caps(ceph_inode(inode), 0, session);
-		goto done_unlocked;
 	}
 
 	/* the rest require a cap */
@@ -2862,6 +2861,7 @@ void ceph_handle_caps(struct ceph_mds_se
 	switch (op) {
 	case CEPH_CAP_OP_REVOKE:
 	case CEPH_CAP_OP_GRANT:
+	case CEPH_CAP_OP_IMPORT:
 		handle_cap_grant(inode, h, session, cap, msg->middle);
 		goto done_unlocked;
 


