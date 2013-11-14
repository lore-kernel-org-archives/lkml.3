Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3KNQPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:15:49 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55239 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3KNQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:14:44 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 05/40] staging/lustre: validate open handle cookies
Date: Fri, 15 Nov 2013 00:13:07 +0800
Message-Id: <1384445622-12346-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Add a const void *h_owner member to struct portals_handle. Add a const
void *owner parameter to class_handle2object() which must be matched
by the h_owner member of the handle in addition to the cookie.  Adjust
the callers of class_handle2object() accordingly, using NULL as the
argument to the owner parameter, except in the case of
mdt_handle2mfd() where we add an explicit mdt_export_data parameter
which we use as the owner when searching for a MFD. When allocating a
new MFD, pass a pointer to the mdt_export_data into mdt_mfd_new() and
store it in h_owner. This allows the MDT to validate that the client
has not sent the wrong open handle cookie, or sent the right cookie to
the wrong MDT.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3233
Lustre-change: http://review.whamcloud.com/6938
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/include/lustre_handles.h |    5 +++--
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    2 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |    4 ++--
 drivers/staging/lustre/lustre/obdclass/genops.c    |    2 +-
 .../lustre/lustre/obdclass/lustre_handles.c        |    4 ++--
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_handles.h b/drivers/staging/lustre/lustre/include/lustre_handles.h
index fcd40f3..5671f62 100644
--- a/drivers/staging/lustre/lustre/include/lustre_handles.h
+++ b/drivers/staging/lustre/lustre/include/lustre_handles.h
@@ -66,7 +66,8 @@ struct portals_handle_ops {
 struct portals_handle {
 	struct list_head			h_link;
 	__u64				h_cookie;
-	struct portals_handle_ops	*h_ops;
+	const void		       *h_owner;
+	struct portals_handle_ops      *h_ops;
 
 	/* newly added fields to handle the RCU issue. -jxiong */
 	cfs_rcu_head_t			h_rcu;
@@ -83,7 +84,7 @@ void class_handle_hash(struct portals_handle *,
 		       struct portals_handle_ops *ops);
 void class_handle_unhash(struct portals_handle *);
 void class_handle_hash_back(struct portals_handle *);
-void *class_handle2object(__u64 cookie);
+void *class_handle2object(__u64 cookie, const void *owner);
 void class_handle_free_cb(cfs_rcu_head_t *);
 int class_handle_init(void);
 void class_handle_cleanup(void);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 3900a69..d81ca5c 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -570,7 +570,7 @@ struct ldlm_lock *__ldlm_handle2lock(const struct lustre_handle *handle,
 
 	LASSERT(handle);
 
-	lock = class_handle2object(handle->cookie);
+	lock = class_handle2object(handle->cookie, NULL);
 	if (lock == NULL)
 		return NULL;
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_internal.h b/drivers/staging/lustre/lustre/lov/lov_internal.h
index 796da89..79ac458 100644
--- a/drivers/staging/lustre/lustre/lov/lov_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_internal.h
@@ -107,10 +107,10 @@ static inline void lov_put_reqset(struct lov_request_set *set)
 }
 
 static inline struct lov_lock_handles *
-lov_handle2llh(struct lustre_handle *handle)
+lov_handle2llh(const struct lustre_handle *handle)
 {
 	LASSERT(handle != NULL);
-	return(class_handle2object(handle->cookie));
+	return class_handle2object(handle->cookie, NULL);
 }
 
 static inline void lov_llh_put(struct lov_lock_handles *llh)
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index f6fae16..0da0034 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -701,7 +701,7 @@ struct obd_export *class_conn2export(struct lustre_handle *conn)
 	}
 
 	CDEBUG(D_INFO, "looking for export cookie "LPX64"\n", conn->cookie);
-	export = class_handle2object(conn->cookie);
+	export = class_handle2object(conn->cookie, NULL);
 	return export;
 }
 EXPORT_SYMBOL(class_conn2export);
diff --git a/drivers/staging/lustre/lustre/obdclass/lustre_handles.c b/drivers/staging/lustre/lustre/obdclass/lustre_handles.c
index be31d32..c6406c3 100644
--- a/drivers/staging/lustre/lustre/obdclass/lustre_handles.c
+++ b/drivers/staging/lustre/lustre/obdclass/lustre_handles.c
@@ -147,7 +147,7 @@ void class_handle_hash_back(struct portals_handle *h)
 }
 EXPORT_SYMBOL(class_handle_hash_back);
 
-void *class_handle2object(__u64 cookie)
+void *class_handle2object(__u64 cookie, const void *owner)
 {
 	struct handle_bucket *bucket;
 	struct portals_handle *h;
@@ -161,7 +161,7 @@ void *class_handle2object(__u64 cookie)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(h, &bucket->head, h_link) {
-		if (h->h_cookie != cookie)
+		if (h->h_cookie != cookie || h->h_owner != owner)
 			continue;
 
 		spin_lock(&h->h_lock);
-- 
1.7.9.5

