Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab3KNQtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:49:21 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39493 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab3KNQoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:09 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Bobi Jam <bobijam.xu@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 10/26] staging/lustre/ldlm: MDT mount fails on MDS w/o MGS on it
Date: Fri, 15 Nov 2013 00:42:57 +0800
Message-Id: <1384447393-13838-11-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bobi Jam <bobijam.xu@intel.com>

If we specify multiple --mgsnode for a MDT, when we start MDS upon
it while MGS is no the other node, the MGC import connection will
always select the local nid (which is one of the candidate mgsnode)
since it think its the closest connection.

This patch treats further --mgsnode nids as failover nids, so that
multiple import connections are added for the MGC import.

Lustre-change: http://review.whamcloud.com/7509
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3829
Signed-off-by: Bobi Jam <bobijam.xu@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |   38 +++++++++++++-------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index a69a630..74e170f 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -332,12 +332,13 @@ int lustre_start_mgc(struct super_block *sb)
 	sprintf(niduuid, "%s_%x", mgcname, i);
 	if (IS_SERVER(lsi)) {
 		ptr = lsi->lsi_lmd->lmd_mgs;
+		CDEBUG(D_MOUNT, "mgs nids %s.\n", ptr);
 		if (IS_MGS(lsi)) {
 			/* Use local nids (including LO) */
 			lnet_process_id_t id;
 			while ((rc = LNetGetId(i++, &id)) != -ENOENT) {
-				rc = do_lcfg(mgcname, id.nid,
-					     LCFG_ADD_UUID, niduuid, 0,0,0);
+				rc = do_lcfg(mgcname, id.nid, LCFG_ADD_UUID,
+					     niduuid, 0, 0, 0);
 			}
 		} else {
 			/* Use mgsnode= nids */
@@ -349,19 +350,30 @@ int lustre_start_mgc(struct super_block *sb)
 				CERROR("No MGS nids given.\n");
 				GOTO(out_free, rc = -EINVAL);
 			}
+			/*
+			 * LU-3829.
+			 * Here we only take the first mgsnid as its primary
+			 * serving mgs node, the rest mgsnid will be taken as
+			 * failover mgs node, otherwise they would be takens
+			 * as multiple nids of a single mgs node.
+			 */
 			while (class_parse_nid(ptr, &nid, &ptr) == 0) {
-				rc = do_lcfg(mgcname, nid,
-					     LCFG_ADD_UUID, niduuid, 0,0,0);
-				i++;
+				rc = do_lcfg(mgcname, nid, LCFG_ADD_UUID,
+					     niduuid, 0, 0, 0);
+				if (rc == 0) {
+					i = 1;
+					break;
+				}
 			}
 		}
 	} else { /* client */
 		/* Use nids from mount line: uml1,1@elan:uml2,2@elan:/lustre */
 		ptr = lsi->lsi_lmd->lmd_dev;
 		while (class_parse_nid(ptr, &nid, &ptr) == 0) {
-			rc = do_lcfg(mgcname, nid,
-				     LCFG_ADD_UUID, niduuid, 0,0,0);
-			i++;
+			rc = do_lcfg(mgcname, nid, LCFG_ADD_UUID,
+				     niduuid, 0, 0, 0);
+			if (rc == 0)
+				++i;
 			/* Stop at the first failover nid */
 			if (*ptr == ':')
 				break;
@@ -394,16 +406,18 @@ int lustre_start_mgc(struct super_block *sb)
 		sprintf(niduuid, "%s_%x", mgcname, i);
 		j = 0;
 		while (class_parse_nid_quiet(ptr, &nid, &ptr) == 0) {
-			j++;
-			rc = do_lcfg(mgcname, nid,
-				     LCFG_ADD_UUID, niduuid, 0,0,0);
+			rc = do_lcfg(mgcname, nid, LCFG_ADD_UUID,
+				     niduuid, 0, 0, 0);
+			if (rc == 0)
+				++j;
 			if (*ptr == ':')
 				break;
 		}
 		if (j > 0) {
 			rc = do_lcfg(mgcname, 0, LCFG_ADD_CONN,
 				     niduuid, 0, 0, 0);
-			i++;
+			if (rc == 0)
+				++i;
 		} else {
 			/* at ":/fsname" */
 			break;
-- 
1.7.9.5

