Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaAMO1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:27:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51248 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaAMOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 21/96] ceph: cleanup aborted requests when re-sending requests.
Date: Mon, 13 Jan 2014 14:23:44 +0000
Message-Id: <1389623099-18783-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit eb1b8af33c2e42a9a57fc0a7588f4a7b255d2e79 upstream.

Aborted requests usually get cleared when the reply is received.
If MDS crashes, no reply will be received. So we need to cleanup
aborted requests when re-sending requests.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Reviewed-by: Greg Farnum <greg@inktank.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ceph/mds_client.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0b26ea8..5efe309 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1815,8 +1815,11 @@ static int __do_request(struct ceph_mds_client *mdsc,
 	int mds = -1;
 	int err = -EAGAIN;
 
-	if (req->r_err || req->r_got_result)
+	if (req->r_err || req->r_got_result) {
+		if (req->r_aborted)
+			__unregister_request(mdsc, req);
 		goto out;
+	}
 
 	if (req->r_timeout &&
 	    time_after_eq(jiffies, req->r_started + req->r_timeout)) {
-- 
1.8.3.2

