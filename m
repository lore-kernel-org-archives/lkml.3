Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab3KNQyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:54:16 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44404 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab3KNQjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:45 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 20/39] staging/lustre/build: fix 'data race condition' issues
Date: Fri, 15 Nov 2013 00:32:43 +0800
Message-Id: <1384446782-13741-21-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'data race condition' defects found by Coverity version
6.5.0:
Data race condition (MISSING_LOCK)
Accessing variable without holding lock. Elsewhere,
this variable is accessed with lock held.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2744
Lustre-change: http://review.whamcloud.com/6567
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/selftest/conrpc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/conrpc.c b/drivers/staging/lustre/lnet/selftest/conrpc.c
index 4d48c77..d600823 100644
--- a/drivers/staging/lustre/lnet/selftest/conrpc.c
+++ b/drivers/staging/lustre/lnet/selftest/conrpc.c
@@ -938,8 +938,12 @@ lstcon_sesnew_stat_reply(lstcon_rpc_trans_t *trans,
 		return status;
 
 	if (!trans->tas_feats_updated) {
-		trans->tas_feats_updated = 1;
-		trans->tas_features = reply->msg_ses_feats;
+		spin_lock(&console_session.ses_rpc_lock);
+		if (!trans->tas_feats_updated) { /* recheck with lock */
+			trans->tas_feats_updated = 1;
+			trans->tas_features = reply->msg_ses_feats;
+		}
+		spin_unlock(&console_session.ses_rpc_lock);
 	}
 
 	if (reply->msg_ses_feats != trans->tas_features) {
-- 
1.7.9.5

