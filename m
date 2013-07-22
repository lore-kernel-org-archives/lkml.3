Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3GVQTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:19:23 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36797 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab3GVQMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:02 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Hiroya Nozaki <nozaki.hiroya@jp.fujitsu.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 27/48] staging/lustre/ptlrpc: Race between start and stop service threads
Date: Tue, 23 Jul 2013 00:06:48 +0800
Message-Id: <1374509230-3324-28-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroya Nozaki <nozaki.hiroya@jp.fujitsu.com>

When ptlrpc_start_thread fails to create a new thread, it will
finalize and free a struct ptlrpc_thread created and used here.
Considering this, it can be a problem when ptlrpc_svcpt_stop_thread
is driven and handles the struct ptlrpc_thread right after or right
before failure of cfs_create_thread. Because this situation let
the both of ptlrpc_start_thread and ptlrpc_svcpt_stop_threads
access the freed ptlrpc_thread and cause OS panic. Or, it may
happen that ptlrpc_svcpt_stop_threads waits forever holding an
already-freed waitq.

This patch adds an error handling into ptlrpc_start_thread to fix
this problem.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2889
Lustre-change: http://review.whamcloud.com/5552
Signed-off-by: Hiroya Nozaki <nozaki.hiroya@jp.fujitsu.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/service.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index 6871711..87bd638 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -2765,11 +2765,19 @@ int ptlrpc_start_thread(struct ptlrpc_service_part *svcpt, int wait)
 		CERROR("cannot start thread '%s': rc %d\n",
 		       thread->t_name, rc);
 		spin_lock(&svcpt->scp_lock);
-		list_del(&thread->t_link);
 		--svcpt->scp_nthrs_starting;
-		spin_unlock(&svcpt->scp_lock);
-
-		OBD_FREE(thread, sizeof(*thread));
+		if (thread_is_stopping(thread)) {
+			/* this ptlrpc_thread is being hanled
+			 * by ptlrpc_svcpt_stop_threads now
+			 */
+			thread_add_flags(thread, SVC_STOPPED);
+			wake_up(&thread->t_ctl_waitq);
+			spin_unlock(&svcpt->scp_lock);
+		} else {
+			list_del(&thread->t_link);
+			spin_unlock(&svcpt->scp_lock);
+			OBD_FREE_PTR(thread);
+		}
 		RETURN(rc);
 	}
 
-- 
1.7.9.5

