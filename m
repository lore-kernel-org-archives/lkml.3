Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab3GVQNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:13:30 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49055 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3GVQNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:24 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 43/48] staging/lustre/build: fix 'data race condition' issues
Date: Tue, 23 Jul 2013 00:07:04 +0800
Message-Id: <1374509230-3324-44-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
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
Lustre-change: http://review.whamcloud.com/6569
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/include/lustre_import.h  |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lustre/include/lustre_import.h b/drivers/staging/lustre/lustre/include/lustre_import.h
index 3a5dd6a..67259eb 100644
--- a/drivers/staging/lustre/lustre/include/lustre_import.h
+++ b/drivers/staging/lustre/lustre/include/lustre_import.h
@@ -336,9 +336,11 @@ static inline unsigned int at_timeout2est(unsigned int val)
 }
 
 static inline void at_reset(struct adaptive_timeout *at, int val) {
+	spin_lock(&at->at_lock);
 	at->at_current = val;
 	at->at_worst_ever = val;
 	at->at_worst_time = cfs_time_current_sec();
+	spin_unlock(&at->at_lock);
 }
 static inline void at_init(struct adaptive_timeout *at, int val, int flags) {
 	memset(at, 0, sizeof(*at));
-- 
1.7.9.5

