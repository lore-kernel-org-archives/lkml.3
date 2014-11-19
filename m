Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaKSBE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:04:59 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:64946 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaKSBE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:04:57 -0500
From: Juston Li <juston.h.li@gmail.com>
To: oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org, HPDD-discuss@ml01.01.org,
        Juston Li <juston.h.li@gmail.com>
Subject: [PATCH v2] staging: lustre: mdc: use __FMODE_EXEC macro
Date: Tue, 18 Nov 2014 17:03:51 -0800
Message-Id: <1416359031-7990-1-git-send-email-juston.h.li@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FMODE_EXEC is type fmode_t but is used in operations
with integers which leads to sparse warnings:
drivers/staging/lustre/lustre/mdc/mdc_lib.c:198:21: warning: restricted fmode_t degrades to integer
drivers/staging/lustre/lustre/mdc/mdc_locks.c:300:49: warning: restricted fmode_t degrades to integer

Fix by using __FMODE_EXEC macro defined in fs.h.

Note the same warnings occurs with other fmode flags
here but they don't have a corresponding int macro.

Changes since v1:
remove ifdefs. FMODE_EXEC and __FMODE_EXEC should
always be defined in fs.h

Signed-off-by: Juston Li <juston.h.li@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_lib.c   | 4 +---
 drivers/staging/lustre/lustre/mdc/mdc_locks.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index e8732cc..4e59995 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -194,10 +194,8 @@ static __u64 mds_pack_open_flags(__u64 flags, __u32 mode)
 		cr_flags |= MDS_OPEN_SYNC;
 	if (flags & O_DIRECTORY)
 		cr_flags |= MDS_OPEN_DIRECTORY;
-#ifdef FMODE_EXEC
-	if (flags & FMODE_EXEC)
+	if (flags & __FMODE_EXEC)
 		cr_flags |= MDS_FMODE_EXEC;
-#endif
 	if (cl_is_lov_delay_create(flags))
 		cr_flags |= MDS_OPEN_DELAY_CREATE;
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index b58147e..8c9b4f5 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -296,10 +296,8 @@ static struct ptlrpc_request *mdc_intent_open_pack(struct obd_export *exp,
 		} else {
 			if (it->it_flags & (FMODE_WRITE|MDS_OPEN_TRUNC))
 				mode = LCK_CW;
-#ifdef FMODE_EXEC
-			else if (it->it_flags & FMODE_EXEC)
+			else if (it->it_flags & __FMODE_EXEC)
 				mode = LCK_PR;
-#endif
 			else
 				mode = LCK_CR;
 		}
-- 
2.1.3

