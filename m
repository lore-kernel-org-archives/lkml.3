Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3KNQlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:41:03 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42474 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab3KNQkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:01 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Mikhail Pershin <mike.pershin@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 24/39] staging/lustre/obdclass: fix wrong device put in case of race
Date: Fri, 15 Nov 2013 00:32:47 +0800
Message-Id: <1384446782-13741-25-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikhail Pershin <mike.pershin@intel.com>

The ls_device_put() might be called from local_oid_storage_fini()
wrongly if mutex-protected check failed due to race

Lustre-change: http://review.whamcloud.com/6334
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3316
Signed-off-by: Mikhail Pershin <mike.pershin@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/obdclass/local_storage.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/local_storage.c b/drivers/staging/lustre/lustre/obdclass/local_storage.c
index 295bb7c..367d3fd 100644
--- a/drivers/staging/lustre/lustre/obdclass/local_storage.c
+++ b/drivers/staging/lustre/lustre/obdclass/local_storage.c
@@ -882,12 +882,15 @@ void local_oid_storage_fini(const struct lu_env *env,
 	ls = dt2ls_dev(los->los_dev);
 
 	mutex_lock(&ls->ls_los_mutex);
-	if (atomic_read(&los->los_refcount) == 0) {
-		if (los->los_obj)
-			lu_object_put_nocache(env, &los->los_obj->do_lu);
-		list_del(&los->los_list);
-		OBD_FREE_PTR(los);
+	if (atomic_read(&los->los_refcount) > 0) {
+		mutex_unlock(&ls->ls_los_mutex);
+		return;
 	}
+
+	if (los->los_obj)
+		lu_object_put_nocache(env, &los->los_obj->do_lu);
+	list_del(&los->los_list);
+	OBD_FREE_PTR(los);
 	mutex_unlock(&ls->ls_los_mutex);
 	ls_device_put(env, ls);
 }
-- 
1.7.9.5

