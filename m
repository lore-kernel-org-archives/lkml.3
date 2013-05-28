Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452Ab3E1O7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:59:23 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53809 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934269Ab3E1O7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:59:21 -0400
From: Emil Goode <emilgoode@gmail.com>
To: sage@inktank.com
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] ceph: improve error handling in ceph_mdsmap_decode
Date: Tue, 28 May 2013 16:59:00 +0200
Message-Id: <1369753140-28802-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following improvements to the error handling
in the ceph_mdsmap_decode function:

- Add a NULL check for return value from kcalloc
- Make use of the variable err

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 fs/ceph/mdsmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 9278dec..d4d3897 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -138,6 +138,8 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 				m->m_info[mds].export_targets =
 					kcalloc(num_export_targets, sizeof(u32),
 						GFP_NOFS);
+				if (m->m_info[mds].export_targets == NULL)
+					goto badmem;
 				for (j = 0; j < num_export_targets; j++)
 					m->m_info[mds].export_targets[j] =
 					       ceph_decode_32(&pexport_targets);
@@ -170,7 +172,7 @@ bad:
 		       DUMP_PREFIX_OFFSET, 16, 1,
 		       start, end - start, true);
 	ceph_mdsmap_destroy(m);
-	return ERR_PTR(-EINVAL);
+	return ERR_PTR(err);
 }
 
 void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
-- 
1.7.10.4

