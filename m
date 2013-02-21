Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3BUSzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:55:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38143 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3BUSzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:55:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: Dudley Du <dudl@cypress.com>, Kamal Mostafa <kamal@canonical.com>,
        Kyle Fazzari <git@status.e4ward.com>
Subject: [PATCH] Input: fix Cypress PS/2 Trackpad in Dell XPS12
Date: Thu, 21 Feb 2013 10:55:55 -0800
Message-Id: <1361472955-16759-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid firmware glitch in Cypress PS/2 Trackpad firmware version 11
(as observed in Dell XPS12) which prevents driver from recognizing
the trackpad.

BugLink: http://launchpad.net/bugs/1103594

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Cc: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cypress_ps2.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
index 1673dc6..f51765f 100644
--- a/drivers/input/mouse/cypress_ps2.c
+++ b/drivers/input/mouse/cypress_ps2.c
@@ -236,6 +236,13 @@ static int cypress_read_fw_version(struct psmouse *psmouse)
 	cytp->fw_version = param[2] & FW_VERSION_MASX;
 	cytp->tp_metrics_supported = (param[2] & TP_METRICS_MASK) ? 1 : 0;
 
+	/*
+	 * Trackpad fw_version 11 (in Dell XPS12) yields a bogus response to
+	 * CYTP_CMD_READ_TP_METRICS so do not try to use it. LP: #1103594.
+	 */
+	if (cytp->fw_version >= 11)
+		cytp->tp_metrics_supported = 0;
+
 	psmouse_dbg(psmouse, "cytp->fw_version = %d\n", cytp->fw_version);
 	psmouse_dbg(psmouse, "cytp->tp_metrics_supported = %d\n",
 		 cytp->tp_metrics_supported);
@@ -258,6 +265,9 @@ static int cypress_read_tp_metrics(struct psmouse *psmouse)
 	cytp->tp_res_x = cytp->tp_max_abs_x / cytp->tp_width;
 	cytp->tp_res_y = cytp->tp_max_abs_y / cytp->tp_high;
 
+	if (!cytp->tp_metrics_supported)
+		return 0;
+
 	memset(param, 0, sizeof(param));
 	if (cypress_send_ext_cmd(psmouse, CYTP_CMD_READ_TP_METRICS, param) == 0) {
 		/* Update trackpad parameters. */
@@ -315,18 +325,15 @@ static int cypress_read_tp_metrics(struct psmouse *psmouse)
 
 static int cypress_query_hardware(struct psmouse *psmouse)
 {
-	struct cytp_data *cytp = psmouse->private;
 	int ret;
 
 	ret = cypress_read_fw_version(psmouse);
 	if (ret)
 		return ret;
 
-	if (cytp->tp_metrics_supported) {
-		ret = cypress_read_tp_metrics(psmouse);
-		if (ret)
-			return ret;
-	}
+	ret = cypress_read_tp_metrics(psmouse);
+	if (ret)
+		return ret;
 
 	return 0;
 }
-- 
1.7.10.4

