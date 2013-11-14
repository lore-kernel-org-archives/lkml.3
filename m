Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab3KNQ4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:56:37 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:37849 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab3KNQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:22 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Aurelien Degremont <aurelien.degremont@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 14/39] staging/lustre/hsm: copy start error should set HP_FLAG_COMPLETED
Date: Fri, 15 Nov 2013 00:32:37 +0800
Message-Id: <1384446782-13741-15-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aurelien Degremont <aurelien.degremont@cea.fr>

If an error occurs when initializing a HSM request, in
ll_ioc_copy_start(), the PROGRESS message, sent to coordinator, should
carry the error code but also HP_FLAG_COMPLETED to mark the request as
finished (with error). If not, the Coordinator will ignore this
message and consider the request is still running.

Lustre-change: http://review.whamcloud.com/7265
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3685
Signed-off-by: Aurelien Degremont <aurelien.degremont@cea.fr>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/dir.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 044aa095..f52c624 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -942,6 +942,9 @@ static int ll_ioc_copy_start(struct super_block *sb, struct hsm_copy *copy)
 	}
 
 progress:
+	/* On error, the request should be considered as completed */
+	if (hpk.hpk_errval > 0)
+		hpk.hpk_flags |= HP_FLAG_COMPLETED;
 	rc = obd_iocontrol(LL_IOC_HSM_PROGRESS, sbi->ll_md_exp, sizeof(hpk),
 			   &hpk, NULL);
 
-- 
1.7.9.5

