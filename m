Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab3GVQXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:23:35 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56834 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab3GVQKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:13 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 05/48] staging/lustre: fix 'program hangs' errors
Date: Tue, 23 Jul 2013 00:06:26 +0800
Message-Id: <1374509230-3324-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'program hangs' defects found by Coverity version 6.5.1:
Missing unlock (LOCK)
Returning without unlocking.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3054
Lustre-change: http://review.whamcloud.com/5870
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/selftest/rpc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index bc1f38b..0dfc76e 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -661,8 +661,10 @@ srpc_finish_service(struct srpc_service *sv)
 
 	cfs_percpt_for_each(scd, i, sv->sv_cpt_data) {
 		spin_lock(&scd->scd_lock);
-		if (!swi_deschedule_workitem(&scd->scd_buf_wi))
+		if (!swi_deschedule_workitem(&scd->scd_buf_wi)) {
+			spin_unlock(&scd->scd_lock);
 			return 0;
+		}
 
 		if (scd->scd_buf_nposted > 0) {
 			CDEBUG(D_NET, "waiting for %d posted buffers to unlink",
-- 
1.7.9.5

