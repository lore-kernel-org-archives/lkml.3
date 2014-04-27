Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaD0RHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:07:54 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47984 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbaD0RHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:47 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Li Xi <pkuelelixi@gmail.com>, Li Xi <lixi@ddn.com>,
        Bobi Jam <bobijam.xu@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 07/47] staging/lustre/ldlm: Hold lock when clearing flag
Date: Sun, 27 Apr 2014 13:06:31 -0400
Message-Id: <1398618431-29757-8-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Xi <pkuelelixi@gmail.com>

This patch moves lock's skip flag clearing from lru-delete to
lru-add code to prevent clearing lock's flag without resource lock
protection.

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Bobi Jam <bobijam.xu@intel.com>
Reviewed-on: http://review.whamcloud.com/8772
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4269
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 0548aca..1066e00 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -232,8 +232,6 @@ int ldlm_lock_remove_from_lru_nolock(struct ldlm_lock *lock)
 
 		LASSERT(lock->l_resource->lr_type != LDLM_FLOCK);
 		list_del_init(&lock->l_lru);
-		if (lock->l_flags & LDLM_FL_SKIPPED)
-			lock->l_flags &= ~LDLM_FL_SKIPPED;
 		LASSERT(ns->ns_nr_unused > 0);
 		ns->ns_nr_unused--;
 		rc = 1;
@@ -271,6 +269,8 @@ void ldlm_lock_add_to_lru_nolock(struct ldlm_lock *lock)
 	LASSERT(list_empty(&lock->l_lru));
 	LASSERT(lock->l_resource->lr_type != LDLM_FLOCK);
 	list_add_tail(&lock->l_lru, &ns->ns_unused_list);
+	if (lock->l_flags & LDLM_FL_SKIPPED)
+		lock->l_flags &= ~LDLM_FL_SKIPPED;
 	LASSERT(ns->ns_nr_unused >= 0);
 	ns->ns_nr_unused++;
 }
-- 
1.8.5.3

