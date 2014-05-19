Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaESVjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:39:47 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64470 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaESVjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:39:46 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>, Peng Tao <bergwolf@gmail.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Masanari Iida <standby24x7@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: lov: lov_obd.c:  Fix for possible null pointer dereference
Date: Mon, 19 May 2014 23:40:35 +0200
Message-Id: <1400535635-6035-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/lov/lov_obd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index 02509d0..0364c16 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -280,7 +280,7 @@ static int lov_disconnect_obd(struct obd_device *obd, struct lov_tgt_desc *tgt)
 
 	osc_obd = class_exp2obd(tgt->ltd_exp);
 	CDEBUG(D_CONFIG, "%s: disconnecting target %s\n",
-	       obd->obd_name, osc_obd->obd_name);
+		obd->obd_name, osc_obd ? osc_obd->obd_name : "NULL");
 
 	if (tgt->ltd_active) {
 		tgt->ltd_active = 0;
@@ -288,11 +288,11 @@ static int lov_disconnect_obd(struct obd_device *obd, struct lov_tgt_desc *tgt)
 		tgt->ltd_exp->exp_obd->obd_inactive = 1;
 	}
 
-	lov_proc_dir = obd->obd_proc_private;
-	if (lov_proc_dir)
-		lprocfs_remove_proc_entry(osc_obd->obd_name, lov_proc_dir);
-
 	if (osc_obd) {
+		lov_proc_dir = obd->obd_proc_private;
+		if (lov_proc_dir) {
+			lprocfs_remove_proc_entry(osc_obd->obd_name, lov_proc_dir);
+		}
 		/* Pass it on to our clients.
 		 * XXX This should be an argument to disconnect,
 		 * XXX not a back-door flag on the OBD.  Ah well.
-- 
1.7.10.4

