Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbbAIKsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:48:08 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44602 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757500AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 10/78] ceph: fix null pointer dereference in discard_cap_releases()
Date: Fri,  9 Jan 2015 11:31:19 +0100
Message-Id: <fda703283f5e154cb64928e66f3898505e7b4d1c.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 00bd8edb861eb41d274938cfc0338999d9c593a3 upstream.

send_mds_reconnect() may call discard_cap_releases() after all
release messages have been dropped by cleanup_cap_releases()

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ceph/mds_client.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 788901552eb1..6f1161324f91 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1420,15 +1420,18 @@ static void discard_cap_releases(struct ceph_mds_client *mdsc,
 	dout("discard_cap_releases mds%d\n", session->s_mds);
 	spin_lock(&session->s_cap_lock);
 
-	/* zero out the in-progress message */
-	msg = list_first_entry(&session->s_cap_releases,
-			       struct ceph_msg, list_head);
-	head = msg->front.iov_base;
-	num = le32_to_cpu(head->num);
-	dout("discard_cap_releases mds%d %p %u\n", session->s_mds, msg, num);
-	head->num = cpu_to_le32(0);
-	msg->front.iov_len = sizeof(*head);
-	session->s_num_cap_releases += num;
+	if (!list_empty(&session->s_cap_releases)) {
+		/* zero out the in-progress message */
+		msg = list_first_entry(&session->s_cap_releases,
+					struct ceph_msg, list_head);
+		head = msg->front.iov_base;
+		num = le32_to_cpu(head->num);
+		dout("discard_cap_releases mds%d %p %u\n",
+		     session->s_mds, msg, num);
+		head->num = cpu_to_le32(0);
+		msg->front.iov_len = sizeof(*head);
+		session->s_num_cap_releases += num;
+	}
 
 	/* requeue completed messages */
 	while (!list_empty(&session->s_cap_releases_done)) {
-- 
2.2.1

