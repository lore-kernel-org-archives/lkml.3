Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3KNQpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:45:08 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46432 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab3KNQoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:54 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 22/26] staging/lustre/osc: osc_extent_wait() shouldn't be interruptible
Date: Fri, 15 Nov 2013 00:43:09 +0800
Message-Id: <1384447393-13838-23-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

Otherwise it will hit the assertion at cl_lock.c:

   cl_lock.c:1967:discard_cb())
        ASSERTION( (!(page->cp_type == CPT_CACHEABLE) ||
        (!PageWriteback(cl_page_vmpage(env, page)))) ) failed:

This is because in osc_lock_flush() we have to make sure the IO
is finished before discarding the pages.

Lustre-change: http://review.whamcloud.com/5419
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2779
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index ff36e77..6051e41 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -891,7 +891,7 @@ static int osc_extent_wait(const struct lu_env *env, struct osc_extent *ext,
 			"%s: wait ext to %d timedout, recovery in progress?\n",
 			osc_export(obj)->exp_obd->obd_name, state);
 
-		lwi = LWI_INTR(LWI_ON_SIGNAL_NOOP, NULL);
+		lwi = LWI_INTR(NULL, NULL);
 		rc = l_wait_event(ext->oe_waitq, extent_wait_cb(ext, state),
 				  &lwi);
 	}
-- 
1.7.9.5

