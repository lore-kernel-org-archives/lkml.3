Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbaJIVIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:08:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59162 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbaJIVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 047/163] libceph: gracefully handle large reply messages from the mon
Date: Thu,  9 Oct 2014 14:01:12 -0700
Message-Id: <1412888588-26755-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@redhat.com>

commit 73c3d4812b4c755efeca0140f606f83772a39ce4 upstream.

We preallocate a few of the message types we get back from the mon.  If we
get a larger message than we are expecting, fall back to trying to allocate
a new one instead of blindly using the one we have.

Signed-off-by: Sage Weil <sage@redhat.com>
Reviewed-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ceph/mon_client.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 2ac9ef3..dbcbf5a 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1041,7 +1041,15 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
 	if (!m) {
 		pr_info("alloc_msg unknown type %d\n", type);
 		*skip = 1;
+	} else if (front_len > m->front_alloc_len) {
+		pr_warning("mon_alloc_msg front %d > prealloc %d (%u#%llu)\n",
+			   front_len, m->front_alloc_len,
+			   (unsigned int)con->peer_name.type,
+			   le64_to_cpu(con->peer_name.num));
+		ceph_msg_put(m);
+		m = ceph_msg_new(type, front_len, GFP_NOFS, false);
 	}
+
 	return m;
 }
 
-- 
1.9.1

