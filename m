Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab3KNQl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:41:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3KNQlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:41:00 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, James Simmons <uja.ornl@gmail.com>,
        Patrick Farrell <paf@cray.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 39/39] staging/lustre/osc: Lustre returns EINTR from writes when SA_RESTART is set
Date: Fri, 15 Nov 2013 00:33:02 +0800
Message-Id: <1384446782-13741-40-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <uja.ornl@gmail.com>

When Lustre is in a read or write system call and receives a
SIGALRM, it will return EINTR if interrupted in osc_enter_cache.
This prevents the system call from being restarted if
SA_RESTART is set in the handler.

This patch changes behavior in this location to return ERESTARTSYS
when a signal arrives during the call to l_wait_event.

Lustre-change: http://review.whamcloud.com/7002
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3581
Signed-off-by: Patrick Farrell <paf@cray.com>
Signed-off-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Rahul Deshmukh <rahul_deshmukh@xyratex.com>
Reviewed-by: Cory Spitz <spitzcor@cray.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_cache.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index 7d63a37..abb4604 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -1533,13 +1533,24 @@ static int osc_enter_cache(const struct lu_env *env, struct client_obd *cli,
 
 		/* l_wait_event is interrupted by signal, or timed out */
 		if (rc < 0) {
-			if (rc == -ETIMEDOUT) {
+			switch (rc) {
+			case -ETIMEDOUT:
 				OSC_DUMP_GRANT(D_ERROR, cli,
 						"try to reserve %d.\n", bytes);
 				osc_extent_tree_dump(D_ERROR, osc);
 				rc = -EDQUOT;
+				break;
+			case -EINTR:
+				/* Ensures restartability - LU-3581 */
+				rc = -ERESTARTSYS;
+				break;
+			default:
+				CDEBUG(D_CACHE, "%s: event for cache space @"
+				       " %p never arrived due to %d\n",
+				       cli->cl_import->imp_obd->obd_name,
+				       &ocw, rc);
+				break;
 			}
-
 			list_del_init(&ocw.ocw_entry);
 			GOTO(out, rc);
 		}
-- 
1.7.9.5

