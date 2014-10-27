Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaJ0TVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:21:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaJ0TCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:02:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilya Dryomov <idryomov@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 095/105] libceph: ceph-msgr workqueue needs a resque worker
Date: Mon, 27 Oct 2014 11:57:10 -0700
Message-Id: <1414436240-13879-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@redhat.com>

commit f9865f06f7f18c6661c88d0511f05c48612319cc upstream.

Commit f363e45fd118 ("net/ceph: make ceph_msgr_wq non-reentrant")
effectively removed WQ_MEM_RECLAIM flag from ceph_msgr_wq.  This is
wrong - libceph is very much a memory reclaim path, so restore it.

Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Tested-by: Micha Krause <micha@krausam.de>
Reviewed-by: Sage Weil <sage@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ceph/messenger.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 94e21b9..057017b 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -290,7 +290,11 @@ int ceph_msgr_init(void)
 	if (ceph_msgr_slab_init())
 		return -ENOMEM;
 
-	ceph_msgr_wq = alloc_workqueue("ceph-msgr", 0, 0);
+	/*
+	 * The number of active work items is limited by the number of
+	 * connections, so leave @max_active at default.
+	 */
+	ceph_msgr_wq = alloc_workqueue("ceph-msgr", WQ_MEM_RECLAIM, 0);
 	if (ceph_msgr_wq)
 		return 0;
 
-- 
1.9.1

