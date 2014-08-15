Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaHOQso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:48:44 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41232 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaHOQsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:48:42 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Paul Cassella <cassella@cray.com>, Patrick Farrell <paf@cray.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 03/10] staging/lustre/llite: Make sure ft_flags is valid
Date: Fri, 15 Aug 2014 12:48:08 -0400
Message-Id: <1408121295-29115-4-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Cassella <cassella@cray.com>

In ll_fault0, the 'fault' struct is mostly cleared before the call to
cl_io_loop, but ft_flags is not reset. It is ordinarily set by
the call to filemap_fault in vvp_io_kernel_fault, but if Lustre
returns before calling filemap_fault, it still has the old value of
ft_flags.

ll_fault0 will then consume the ft_flags field. If it has the
VM_FAULT_RETRY bit set, it will be used as ll_fault0() and
ll_fault()'s return value.

This is a problem when VM_FAULT_RETRY is in ft_flags:
When fault/filemap_fault return with that flag set, they have already
released the mmap semaphore, and do_page_fault does not need to
release it.
Incorrectly returning this flag from ll_fault means mmap_sem
is not upped in the kernel's do_page_fault().

In addition to clearing ft_flags, this patch does not use it unless
it is valid.  It's potentially misleading to return ft_flags in
"fault_ret" if ft_flags has not been set by filemap_fault.

This adds clarity, but does not change the current behavior:
When not valid, ft_flags is replaced by fault_ret, which is zero,
as is ft_flags when not set by filemap_fault.

Signed-off-by: Patrick Farrell <paf@cray.com>
Reviewed-on: http://review.whamcloud.com/10956
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-5291
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_internal.h | 4 ++++
 drivers/staging/lustre/lustre/llite/llite_mmap.c     | 8 +++++++-
 drivers/staging/lustre/lustre/llite/vvp_io.c         | 1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 634ffa6..684405e 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -894,6 +894,10 @@ struct vvp_io {
 				 * fault API used bitflags for return code.
 				 */
 				unsigned int    ft_flags;
+				/**
+				 * check that flags are from filemap_fault
+				 */
+				bool		ft_flags_valid;
 			} fault;
 		} fault;
 	} u;
diff --git a/drivers/staging/lustre/lustre/llite/llite_mmap.c b/drivers/staging/lustre/lustre/llite/llite_mmap.c
index 7dae610..5916648 100644
--- a/drivers/staging/lustre/lustre/llite/llite_mmap.c
+++ b/drivers/staging/lustre/lustre/llite/llite_mmap.c
@@ -310,10 +310,16 @@ static int ll_fault0(struct vm_area_struct *vma, struct vm_fault *vmf)
 		vio->u.fault.ft_vma       = vma;
 		vio->u.fault.ft_vmpage    = NULL;
 		vio->u.fault.fault.ft_vmf = vmf;
+		vio->u.fault.fault.ft_flags = 0;
+		vio->u.fault.fault.ft_flags_valid = 0;
 
 		result = cl_io_loop(env, io);
 
-		fault_ret = vio->u.fault.fault.ft_flags;
+		/* ft_flags are only valid if we reached
+		 * the call to filemap_fault */
+		if (vio->u.fault.fault.ft_flags_valid)
+			fault_ret = vio->u.fault.fault.ft_flags;
+
 		vmpage = vio->u.fault.ft_vmpage;
 		if (result != 0 && vmpage != NULL) {
 			page_cache_release(vmpage);
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index a4117d6..fd24874 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -615,6 +615,7 @@ static int vvp_io_kernel_fault(struct vvp_fault_io *cfio)
 	struct vm_fault *vmf = cfio->fault.ft_vmf;
 
 	cfio->fault.ft_flags = filemap_fault(cfio->ft_vma, vmf);
+	cfio->fault.ft_flags_valid = 1;
 
 	if (vmf->page) {
 		CDEBUG(D_PAGE,
-- 
1.9.3

