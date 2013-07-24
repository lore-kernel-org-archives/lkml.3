Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab3GXIgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:36:19 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:32024 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752650Ab3GXIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:36:11 -0400
From: mail-agent-noreply@emc.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 3/8] staging/lustre: fix 'data race condition' issues in at_reset()
Date: Wed, 24 Jul 2013 16:31:27 +0800
Message-Id: <1374654692-13237-4-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374654692-13237-3-git-send-email-mail-agent-noreply@emc.com>
References: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-2-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-3-git-send-email-mail-agent-noreply@emc.com>
X-EMM-MHVC: 1
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

