Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbaAMRIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:08:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbaAMQBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 021/208] ceph: wake up 'safe' waiters when unregistering request
Date: Mon, 13 Jan 2014 15:57:42 +0000
Message-Id: <1389628849-1614-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit fc55d2c9448b34218ca58733a6f51fbede09575b upstream.

We also need to wake up 'safe' waiters if error occurs or request
aborted. Otherwise sync(2)/fsync(2) may hang forever.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c9c69cd..17b97ff 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -639,6 +639,8 @@ static void __unregister_request(struct ceph_mds_client *mdsc,
 		req->r_unsafe_dir = NULL;
 	}
 
+	complete_all(&req->r_safe_completion);
+
 	ceph_mdsc_put_request(req);
 }
 
@@ -2155,7 +2157,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	if (head->safe) {
 		req->r_got_safe = true;
 		__unregister_request(mdsc, req);
-		complete_all(&req->r_safe_completion);
 
 		if (req->r_got_unsafe) {
 			/*
-- 
1.8.3.2

