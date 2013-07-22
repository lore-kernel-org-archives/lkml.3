Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab3GVQMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:12:21 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46867 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838Ab3GVQMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:15 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Lai Siyao <lai.siyao@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: [PATCH 29/48] staging/lustre/mdt: duplicate link names in directory
Date: Tue, 23 Jul 2013 00:06:50 +0800
Message-Id: <1374509230-3324-30-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Dilger <andreas.dilger@intel.com>

When creating a hard link to a file, the MDT/MDD/OSD code does
not verify whether the target link name already exists in the
directory.  The ZFS ZAP code checks for duplicate entries. The
add_dirent_to_buf() function in ldiskfs only checks entries for
duplicates while it is traversing the leaf block looking for free
space.  Even if it scanned the whole leaf block, this would not
work for non-htree directories since there is no guarantee that
the name is being inserted into the same leaf block.

To fix this, link should check target object doesn't exist as
other creat operations.

Add sanity.sh test_31o with multiple threads racing to link a new
name into the directory, while ensuring that there is a free entry
in the leaf block that is large enough to hold the duplicate name.
This needs to be racy, because otherwise the client VFS will see
the existing name and not send the RPC to the MDS, hiding the bug.

Add DLDLMRES/PLDLMRES macros for printing the whole lock resource
name (including the name hash) in LDLM_DEBUG() messages in a format
similar to DFID/PFID so they can be found in debug logs more easily.

The patch pickes client side change of the original patch, which only
contains the DLM printk part.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2901
Lustre-change: http://review.whamcloud.com/6591
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |    4 +
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |  145 ++++++++++----------
 2 files changed, 76 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index ace4e18..3aaa869 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -2690,6 +2690,10 @@ struct ldlm_res_id {
 	__u64 name[RES_NAME_SIZE];
 };
 
+#define DLDLMRES	"["LPX64":"LPX64":"LPX64"]."LPX64i
+#define PLDLMRES(res)	(res)->lr_name.name[0], (res)->lr_name.name[1], \
+			(res)->lr_name.name[2], (res)->lr_name.name[3]
+
 extern void lustre_swab_ldlm_res_id (struct ldlm_res_id *id);
 
 static inline int ldlm_res_eq(const struct ldlm_res_id *res0,
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index c10ba9c..ce1add1 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -2336,91 +2336,90 @@ void _ldlm_lock_debug(struct ldlm_lock *lock,
 	switch (resource->lr_type) {
 	case LDLM_EXTENT:
 		libcfs_debug_vmsg2(msgdata, fmt, args,
-		       " ns: %s lock: %p/"LPX64" lrc: %d/%d,%d mode: %s/%s "
-		       "res: "LPU64"/"LPU64" rrc: %d type: %s ["LPU64"->"LPU64
-		       "] (req "LPU64"->"LPU64") flags: "LPX64" nid: %s remote:"
-		       " "LPX64" expref: %d pid: %u timeout: %lu lvb_type: %d\n",
-		       ldlm_lock_to_ns_name(lock), lock,
-		       lock->l_handle.h_cookie, atomic_read(&lock->l_refc),
-		       lock->l_readers, lock->l_writers,
-		       ldlm_lockname[lock->l_granted_mode],
-		       ldlm_lockname[lock->l_req_mode],
-		       resource->lr_name.name[0],
-		       resource->lr_name.name[1],
-		       atomic_read(&resource->lr_refcount),
-		       ldlm_typename[resource->lr_type],
-		       lock->l_policy_data.l_extent.start,
-		       lock->l_policy_data.l_extent.end,
-		       lock->l_req_extent.start, lock->l_req_extent.end,
-		       lock->l_flags, nid, lock->l_remote_handle.cookie,
-		       exp ? atomic_read(&exp->exp_refcount) : -99,
-		       lock->l_pid, lock->l_callback_timeout, lock->l_lvb_type);
+			" ns: %s lock: %p/"LPX64" lrc: %d/%d,%d mode: %s/%s "
+			"res: "DLDLMRES" rrc: %d type: %s ["LPU64"->"LPU64"] "
+			"(req "LPU64"->"LPU64") flags: "LPX64" nid: %s remote: "
+			LPX64" expref: %d pid: %u timeout: %lu lvb_type: %d\n",
+			ldlm_lock_to_ns_name(lock), lock,
+			lock->l_handle.h_cookie, atomic_read(&lock->l_refc),
+			lock->l_readers, lock->l_writers,
+			ldlm_lockname[lock->l_granted_mode],
+			ldlm_lockname[lock->l_req_mode],
+			PLDLMRES(resource),
+			atomic_read(&resource->lr_refcount),
+			ldlm_typename[resource->lr_type],
+			lock->l_policy_data.l_extent.start,
+			lock->l_policy_data.l_extent.end,
+			lock->l_req_extent.start, lock->l_req_extent.end,
+			lock->l_flags, nid, lock->l_remote_handle.cookie,
+			exp ? atomic_read(&exp->exp_refcount) : -99,
+			lock->l_pid, lock->l_callback_timeout,
+			lock->l_lvb_type);
 		break;
 
 	case LDLM_FLOCK:
 		libcfs_debug_vmsg2(msgdata, fmt, args,
-		       " ns: %s lock: %p/"LPX64" lrc: %d/%d,%d mode: %s/%s "
-		       "res: "LPU64"/"LPU64" rrc: %d type: %s pid: %d "
-		       "["LPU64"->"LPU64"] flags: "LPX64" nid: %s remote: "LPX64
-		       " expref: %d pid: %u timeout: %lu\n",
-		       ldlm_lock_to_ns_name(lock), lock,
-		       lock->l_handle.h_cookie, atomic_read(&lock->l_refc),
-		       lock->l_readers, lock->l_writers,
-		       ldlm_lockname[lock->l_granted_mode],
-		       ldlm_lockname[lock->l_req_mode],
-		       resource->lr_name.name[0],
-		       resource->lr_name.name[1],
-		       atomic_read(&resource->lr_refcount),
-		       ldlm_typename[resource->lr_type],
-		       lock->l_policy_data.l_flock.pid,
-		       lock->l_policy_data.l_flock.start,
-		       lock->l_policy_data.l_flock.end,
-		       lock->l_flags, nid, lock->l_remote_handle.cookie,
-		       exp ? atomic_read(&exp->exp_refcount) : -99,
-		       lock->l_pid, lock->l_callback_timeout);
+			" ns: %s lock: %p/"LPX64" lrc: %d/%d,%d mode: %s/%s "
+			"res: "DLDLMRES" rrc: %d type: %s pid: %d "
+			"["LPU64"->"LPU64"] flags: "LPX64" nid: %s "
+			"remote: "LPX64" expref: %d pid: %u timeout: %lu\n",
+			ldlm_lock_to_ns_name(lock), lock,
+			lock->l_handle.h_cookie, atomic_read(&lock->l_refc),
+			lock->l_readers, lock->l_writers,
+			ldlm_lockname[lock->l_granted_mode],
+			ldlm_lockname[lock->l_req_mode],
+			PLDLMRES(resource),
+			atomic_read(&resource->lr_refcount),
+			ldlm_typename[resource->lr_type],
+			lock->l_policy_data.l_flock.pid,
+			lock->l_policy_data.l_flock.start,
+			lock->l_policy_data.l_flock.end,
+			lock->l_flags, nid, lock->l_remote_handle.cookie,
+			exp ? atomic_read(&exp->exp_refcount) : -99,
+			lock->l_pid, lock->l_callback_timeout);
 		break;
 
 	case LDLM_IBITS:
 		libcfs_debug_vmsg2(msgdata, fmt, args,
-		       " ns: %s lock: %p/"LPX64" lrc: %d/%d,%d mode: %s/%s "
-		       "res: "LPU64"/"LPU64" bits "LPX64" rrc: %d type: %s "
-		       "flags: "LPX64" nid: %s remote: "LPX64" expref: %d "
-		       "pid: %u timeout: %lu lvb_type: %d\n",
-		       ldlm_lock_to_ns_name(lock),
-		       lock, lock->l_handle.h_cookie,
-		       atomic_read (&lock->l_refc),
-		       lock->l_readers, lock->l_writers,
-		       ldlm_lockname[lock->l_granted_mode],
-		       ldlm_lockname[lock->l_req_mode],
-		       resource->lr_name.name[0],
-		       resource->lr_name.name[1],
-		       lock->l_policy_data.l_inodebits.bits,
-		       atomic_read(&resource->lr_refcount),
-		       ldlm_typename[resource->lr_type],
-		       lock->l_flags, nid, lock->l_remote_handle.cookie,
-		       exp ? atomic_read(&exp->exp_refcount) : -99,
-		       lock->l_pid, lock->l_callback_timeout, lock->l_lvb_type);
+			" ns: %s lock: %p/"LPX64" lrc: %d/%d,%d mode: %s/%s "
+			"res: "DLDLMRES" bits "LPX64" rrc: %d type: %s "
+			"flags: "LPX64" nid: %s remote: "LPX64" expref: %d "
+			"pid: %u timeout: %lu lvb_type: %d\n",
+			ldlm_lock_to_ns_name(lock),
+			lock, lock->l_handle.h_cookie,
+			atomic_read(&lock->l_refc),
+			lock->l_readers, lock->l_writers,
+			ldlm_lockname[lock->l_granted_mode],
+			ldlm_lockname[lock->l_req_mode],
+			PLDLMRES(resource),
+			lock->l_policy_data.l_inodebits.bits,
+			atomic_read(&resource->lr_refcount),
+			ldlm_typename[resource->lr_type],
+			lock->l_flags, nid, lock->l_remote_handle.cookie,
+			exp ? atomic_read(&exp->exp_refcount) : -99,
+			lock->l_pid, lock->l_callback_timeout,
+			lock->l_lvb_type);
 		break;
 
 	default:
 		libcfs_debug_vmsg2(msgdata, fmt, args,
-		       " ns: %s lock: %p/"LPX64" lrc: %d/%d,%d mode: %s/%s "
-		       "res: "LPU64"/"LPU64" rrc: %d type: %s flags: "LPX64" "
-		       "nid: %s remote: "LPX64" expref: %d pid: %u timeout: %lu"
-		       "lvb_type: %d\n",
-		       ldlm_lock_to_ns_name(lock),
-		       lock, lock->l_handle.h_cookie,
-		       atomic_read (&lock->l_refc),
-		       lock->l_readers, lock->l_writers,
-		       ldlm_lockname[lock->l_granted_mode],
-		       ldlm_lockname[lock->l_req_mode],
-		       resource->lr_name.name[0],
-		       resource->lr_name.name[1],
-		       atomic_read(&resource->lr_refcount),
-		       ldlm_typename[resource->lr_type],
-		       lock->l_flags, nid, lock->l_remote_handle.cookie,
-		       exp ? atomic_read(&exp->exp_refcount) : -99,
-		       lock->l_pid, lock->l_callback_timeout, lock->l_lvb_type);
+			" ns: %s lock: %p/"LPX64" lrc: %d/%d,%d mode: %s/%s "
+			"res: "DLDLMRES" rrc: %d type: %s flags: "LPX64" "
+			"nid: %s remote: "LPX64" expref: %d pid: %u "
+			"timeout: %lu lvb_type: %d\n",
+			ldlm_lock_to_ns_name(lock),
+			lock, lock->l_handle.h_cookie,
+			atomic_read(&lock->l_refc),
+			lock->l_readers, lock->l_writers,
+			ldlm_lockname[lock->l_granted_mode],
+			ldlm_lockname[lock->l_req_mode],
+			PLDLMRES(resource),
+			atomic_read(&resource->lr_refcount),
+			ldlm_typename[resource->lr_type],
+			lock->l_flags, nid, lock->l_remote_handle.cookie,
+			exp ? atomic_read(&exp->exp_refcount) : -99,
+			lock->l_pid, lock->l_callback_timeout,
+			lock->l_lvb_type);
 		break;
 	}
 	va_end(args);
-- 
1.7.9.5

