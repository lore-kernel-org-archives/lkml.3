Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaIZKDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:03:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbaIZJqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sage Weil <sage@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 117/142] libceph: gracefully handle large reply messages from the mon
Date: Fri, 26 Sep 2014 11:45:28 +0200
Message-Id: <a1f3bee285ee52c8658ca2360a74a768417dc21f.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sage Weil <sage@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 73c3d4812b4c755efeca0140f606f83772a39ce4 upstream.

We preallocate a few of the message types we get back from the mon.  If we
get a larger message than we are expecting, fall back to trying to allocate
a new one instead of blindly using the one we have.

Signed-off-by: Sage Weil <sage@redhat.com>
Reviewed-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ceph/mon_client.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 2ac9ef35110b..dbcbf5a4707f 100644
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
2.1.0

