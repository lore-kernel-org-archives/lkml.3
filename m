Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3KNQpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:45:15 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45327 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab3KNQou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:50 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Drokin <oleg.drokin@intel.com>,
        Jian Yu <jian.yu@intel.com>, Jinshan Xiong <jinshan.xiong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 21/26] staging/lustre/clio: Do not shrink sublock at cancel
Date: Fri, 15 Nov 2013 00:43:08 +0800
Message-Id: <1384447393-13838-22-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Drokin <oleg.drokin@intel.com>

Shrinking sublock at ldlm lock cancel time means whoever happened
to attach to this lock just before will reenqueue the wrong lock.

Lustre-change: http://review.whamcloud.com/7569
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3027
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Jian Yu <jian.yu@intel.com>
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Patrick Farrell <paf@cray.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/lov/lovsub_lock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lov/lovsub_lock.c b/drivers/staging/lustre/lustre/lov/lovsub_lock.c
index 80305aa..b38c30d 100644
--- a/drivers/staging/lustre/lustre/lov/lovsub_lock.c
+++ b/drivers/staging/lustre/lustre/lov/lovsub_lock.c
@@ -208,7 +208,10 @@ int lov_sublock_modify(const struct lu_env *env, struct lov_lock *lov,
 	pd->cld_mode = parent_descr->cld_mode;
 	pd->cld_gid  = parent_descr->cld_gid;
 	lovsub_lock_descr_map(d, subobj->lso_super, subobj->lso_index, pd);
-	lov->lls_sub[idx].sub_got = *d;
+
+	/* LU-3027: only update extent of lock */
+	lov->lls_sub[idx].sub_got.cld_start = d->cld_start;
+	lov->lls_sub[idx].sub_got.cld_end = d->cld_end;
 	/*
 	 * Notify top-lock about modification, if lock description changes
 	 * materially.
-- 
1.7.9.5

