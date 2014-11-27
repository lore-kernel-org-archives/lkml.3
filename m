Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaK0IrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:47:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:41555 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbaK0IrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:47:15 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sage Weil <sage@redhat.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 29/91] libceph: gracefully handle large reply messages from the mon
Date: Thu, 27 Nov 2014 16:42:12 +0800
Message-Id: <1417077794-9299-29-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sage Weil <sage@redhat.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 73c3d4812b4c755efeca0140f606f83772a39ce4 upstream.

We preallocate a few of the message types we get back from the mon.  If we
get a larger message than we are expecting, fall back to trying to allocate
a new one instead of blindly using the one we have.

Signed-off-by: Sage Weil <sage@redhat.com>
Reviewed-by: Ilya Dryomov <ilya.dryomov@inktank.com>
[lizf: Backported to 3.4: s/front_alloc_len/front_max/g]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 net/ceph/mon_client.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 6765da3..bc293c0 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1042,7 +1042,15 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
 	if (!m) {
 		pr_info("alloc_msg unknown type %d\n", type);
 		*skip = 1;
+	} else if (front_len > m->front_max) {
+		pr_warning("mon_alloc_msg front %d > prealloc %d (%u#%llu)\n",
+			   front_len, m->front_max,
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

