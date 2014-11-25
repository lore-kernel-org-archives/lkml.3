Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaKYLen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:34:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58466 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaKYKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilya Dryomov <idryomov@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 097/254] libceph: ceph-msgr workqueue needs a resque worker
Date: Tue, 25 Nov 2014 10:37:27 +0000
Message-Id: <1416912004-5928-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@redhat.com>

commit f9865f06f7f18c6661c88d0511f05c48612319cc upstream.

Commit f363e45fd118 ("net/ceph: make ceph_msgr_wq non-reentrant")
effectively removed WQ_MEM_RECLAIM flag from ceph_msgr_wq.  This is
wrong - libceph is very much a memory reclaim path, so restore it.

Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Tested-by: Micha Krause <micha@krausam.de>
Reviewed-by: Sage Weil <sage@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/messenger.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3d9ddc2842e1..6b15183a68c8 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -291,7 +291,11 @@ int ceph_msgr_init(void)
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
2.1.0

