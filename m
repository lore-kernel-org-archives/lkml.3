Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3I3KeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:34:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43468 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3I3KMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 029/104] target: Fix trailing ASCII space usage in INQUIRY vendor+model
Date: Mon, 30 Sep 2013 11:10:06 +0100
Message-Id: <1380535881-9239-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit ee60bddba5a5f23e39598195d944aa0eb2d455e5 upstream.

This patch fixes spc_emulate_inquiry_std() to add trailing ASCII
spaces for INQUIRY vendor + model fields following SPC-4 text:

  "ASCII data fields described as being left-aligned shall have any
   unused bytes at the end of the field (i.e., highest offset) and
   the unused bytes shall be filled with ASCII space characters (20h)."

This addresses a problem with Falconstor NSS multipathing.

Reported-by: Tomas Molota <tomas.molota@lightstorm.sk>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ luis: backported to 3.5:
  - file rename: target_core_spc.c -> target_core_cdb.c
  - use dev->se_sub_dev->t10_wwn instead of dev->t10_wwn ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_cdb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index dd09f0f..1756838 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -97,9 +97,12 @@ target_emulate_inquiry_std(struct se_cmd *cmd, char *buf)
 
 	buf[7] = 0x2; /* CmdQue=1 */
 
-	snprintf(&buf[8], 8, "LIO-ORG");
-	snprintf(&buf[16], 16, "%s", dev->se_sub_dev->t10_wwn.model);
-	snprintf(&buf[32], 4, "%s", dev->se_sub_dev->t10_wwn.revision);
+	memcpy(&buf[8], "LIO-ORG ", 8);
+	memset(&buf[16], 0x20, 16);
+	memcpy(&buf[16], dev->se_sub_dev->t10_wwn.model,
+	       min_t(size_t, strlen(dev->se_sub_dev->t10_wwn.model), 16));
+	memcpy(&buf[32], dev->se_sub_dev->t10_wwn.revision,
+	       min_t(size_t, strlen(dev->se_sub_dev->t10_wwn.revision), 4));
 	buf[4] = 31; /* Set additional length to 31 */
 
 	return 0;
-- 
1.8.3.2

