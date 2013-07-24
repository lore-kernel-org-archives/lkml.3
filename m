Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3GXRUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:20:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43027 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3GXRU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:20:29 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-RESEND 3/8] staging/lustre: fix 'data race condition' issues in at_reset()
Date: Thu, 25 Jul 2013 01:17:26 +0800
Message-Id: <1374686251-3152-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374686251-3152-1-git-send-email-bergwolf@gmail.com>
References: <1374686251-3152-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'data race condition' defects found by Coverity version
6.5.0:
Data race condition (MISSING_LOCK)
Accessing variable without holding lock. Elsewhere,
this variable is accessed with lock held.

at_reset() needs to take at->at_lock before modifying its members.

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
 1 files changed, 2 insertions(+), 0 deletions(-)

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
1.7.1

