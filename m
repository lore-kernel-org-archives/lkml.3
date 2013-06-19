Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006Ab3FSBV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:21:58 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:5385 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab3FSBSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:18:48 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 01/11] ipc,shm: introduce lockless functions to obtain the ipc object
Date: Tue, 18 Jun 2013 18:18:26 -0700
Message-Id: <1371604716-3439-2-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
References: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add shm_obtain_object() and shm_obtain_object_check(), which will allow us
to get the ipc object without acquiring the lock. Just as with other forms
of ipc, these functions are basically wrappers around ipc_obtain_object*().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/shm.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/ipc/shm.c b/ipc/shm.c
index c6b4ad5..216ae72 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -124,6 +124,26 @@ void __init shm_init (void)
 				IPC_SHM_IDS, sysvipc_shm_proc_show);
 }
 
+static inline struct shmid_kernel *shm_obtain_object(struct ipc_namespace *ns, int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object(&shm_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct shmid_kernel, shm_perm);
+}
+
+static inline struct shmid_kernel *shm_obtain_object_check(struct ipc_namespace *ns, int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object_check(&shm_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct shmid_kernel, shm_perm);
+}
+
 /*
  * shm_lock_(check_) routines are called in the paths where the rw_mutex
  * is not necessarily held.
-- 
1.7.11.7

