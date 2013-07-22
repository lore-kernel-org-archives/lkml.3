Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3GVQLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:11:12 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48164 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3GVQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:06 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Drokin <green@whamcloud.com>,
        Oleg Drokin <oleg.drokin@intel.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 15/48] staging/lustre: Make quota namespace refcounting consistent
Date: Tue, 23 Jul 2013 00:06:36 +0800
Message-Id: <1374509230-3324-16-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Drokin <green@whamcloud.com>

It seems quota namespace is needlessly referenced on connect,
but that's not necessary as it could not go away until entire
obd goes away.
On the other hand this extra reference disturbs other logic
depending on empty namespace having zero refcount, so this patch
drops such extra referencing.

This picks client side change of the original patch.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2924
Lustre-change: http://review.whamcloud.com/6234
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-by: Johann Lombardi <johann.lombardi@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h |    3 +--
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |    6 +-----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h b/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
index 785c1a1..bf6f003 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_internal.h
@@ -84,8 +84,7 @@ static inline struct mutex *ldlm_namespace_lock(ldlm_side_t client)
 		&ldlm_srv_namespace_lock : &ldlm_cli_namespace_lock;
 }
 
-/* ns_bref is the number of resources in this namespace with the notable
- * exception of quota namespaces which have their empty refcount at 1 */
+/* ns_bref is the number of resources in this namespace */
 static inline int ldlm_ns_empty(struct ldlm_namespace *ns)
 {
 	return atomic_read(&ns->ns_bref) == 0;
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 7162838..17eab79 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -1171,11 +1171,7 @@ ldlm_resource_get(struct ldlm_namespace *ns, struct ldlm_resource *parent,
 	/* Let's see if we happened to be the very first resource in this
 	 * namespace. If so, and this is a client namespace, we need to move
 	 * the namespace into the active namespaces list to be patrolled by
-	 * the ldlm_poold.
-	 * A notable exception, for quota namespaces qsd_lib.c already took a
-	 * namespace reference, so it won't be participating in all of this,
-	 * but I guess that's ok since we have no business cancelling quota
-	 * locks anyway */
+	 * the ldlm_poold. */
 	if (ns_is_client(ns) && ns_refcount == 1) {
 		mutex_lock(ldlm_namespace_lock(LDLM_NAMESPACE_CLIENT));
 		ldlm_namespace_move_to_active_locked(ns, LDLM_NAMESPACE_CLIENT);
-- 
1.7.9.5

