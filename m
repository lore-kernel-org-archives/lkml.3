Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaCENEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:04:50 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:34626 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaCENEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:04:45 -0500
From: "Maxin B. John" <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        josh@joshtriplett.org, bergwolf@gmail.com,
        dulshani.gunawardhana89@gmail.com, jinshan.xiong@intel.com,
        alexey.zhuravlev@intel.com, "Maxin B. John" <maxin.john@enea.com>
Subject: [PATCH 2/2] lustre/lov_obd: fix possible null pointer dereference
Date: Wed,  5 Mar 2014 14:04:36 +0100
Message-Id: <1394024676-35160-2-git-send-email-maxin.john@enea.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394024676-35160-1-git-send-email-maxin.john@enea.com>
References: <1394024676-35160-1-git-send-email-maxin.john@enea.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maxin B. John" <maxin.john@enea.com>

osc_obd can be NULL. cppcheck reported this:
[lustre/lustre/lov/lov_obd.c:283]: (error) Possible null pointer dereference:
osc_obd - otherwise it is redundant to check if osc_obd is null at line 295

Signed-off-by: Maxin B. John <maxin.john@enea.com>
---
 drivers/staging/lustre/lustre/lov/lov_obd.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index 50a77c5..5c0271c 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -279,8 +279,6 @@ static int lov_disconnect_obd(struct obd_device *obd, struct lov_tgt_desc *tgt)
 	int rc;
 
 	osc_obd = class_exp2obd(tgt->ltd_exp);
-	CDEBUG(D_CONFIG, "%s: disconnecting target %s\n",
-	       obd->obd_name, osc_obd->obd_name);
 
 	if (tgt->ltd_active) {
 		tgt->ltd_active = 0;
@@ -289,14 +287,17 @@ static int lov_disconnect_obd(struct obd_device *obd, struct lov_tgt_desc *tgt)
 	}
 
 	lov_proc_dir = obd->obd_proc_private;
-	if (lov_proc_dir)
-		lprocfs_remove_proc_entry(osc_obd->obd_name, lov_proc_dir);
 
 	if (osc_obd) {
 		/* Pass it on to our clients.
 		 * XXX This should be an argument to disconnect,
 		 * XXX not a back-door flag on the OBD.  Ah well.
 		 */
+		CDEBUG(D_CONFIG, "%s: disconnecting target %s\n",
+			obd->obd_name, osc_obd->obd_name);
+		if (lov_proc_dir)
+			lprocfs_remove_proc_entry(osc_obd->obd_name,
+							lov_proc_dir);
 		osc_obd->obd_force = obd->obd_force;
 		osc_obd->obd_fail = obd->obd_fail;
 		osc_obd->obd_no_recov = obd->obd_no_recov;
-- 
1.7.10.4

