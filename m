Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab3KNQoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:44:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47597 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab3KNQnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:43:43 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Niu Yawei <yawei.niu@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 03/26] staging/lustre/clio: incorrect assertions in 'enable-invariants'
Date: Fri, 15 Nov 2013 00:42:50 +0800
Message-Id: <1384447393-13838-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niu Yawei <yawei.niu@intel.com>

Fixed several incorrect assumptions in 'enable-invariants'.

Lustre-change: http://review.whamcloud.com/6832
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3521
Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/cl_page.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/cl_page.c b/drivers/staging/lustre/lustre/obdclass/cl_page.c
index 2a5ce37..d997c8e 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_page.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_page.c
@@ -481,7 +481,7 @@ static inline int cl_page_invariant(const struct cl_page *pg)
 	child  = pg->cp_child;
 	owner  = pg->cp_owner;
 
-	return cl_page_in_use(pg) &&
+	return cl_page_in_use_noref(pg) &&
 		ergo(parent != NULL, parent->cp_child == pg) &&
 		ergo(child != NULL, child->cp_parent == pg) &&
 		ergo(child != NULL, pg->cp_obj != child->cp_obj) &&
@@ -814,7 +814,7 @@ void cl_page_disown0(const struct lu_env *env,
 
 	state = pg->cp_state;
 	PINVRNT(env, pg, state == CPS_OWNED || state == CPS_FREEING);
-	PINVRNT(env, pg, cl_page_invariant(pg));
+	PINVRNT(env, pg, cl_page_invariant(pg) || state == CPS_FREEING);
 	cl_page_owner_clear(pg);
 
 	if (state == CPS_OWNED)
@@ -989,7 +989,8 @@ EXPORT_SYMBOL(cl_page_unassume);
 void cl_page_disown(const struct lu_env *env,
 		    struct cl_io *io, struct cl_page *pg)
 {
-	PINVRNT(env, pg, cl_page_is_owned(pg, io));
+	PINVRNT(env, pg, cl_page_is_owned(pg, io) ||
+			 pg->cp_state == CPS_FREEING);
 
 	pg = cl_page_top(pg);
 	io = cl_io_top(io);
-- 
1.7.9.5

