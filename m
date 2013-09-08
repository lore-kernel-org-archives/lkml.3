Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab3IHDlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:41:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56066 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756827Ab3IHDTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Tomas Molota" <tomas.molota@lightstorm.sk>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.109719891@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [119/121] target: Fix trailing ASCII space usage in  INQUIRY
 vendor+model
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2, based on Nicholas's versions for 3.0 and 3.4]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_cdb.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -127,11 +127,12 @@ target_emulate_inquiry_std(struct se_cmd
 		goto out;
 	}
 
-	snprintf((unsigned char *)&buf[8], 8, "LIO-ORG");
-	snprintf((unsigned char *)&buf[16], 16, "%s",
-		 &dev->se_sub_dev->t10_wwn.model[0]);
-	snprintf((unsigned char *)&buf[32], 4, "%s",
-		 &dev->se_sub_dev->t10_wwn.revision[0]);
+	memcpy(&buf[8], "LIO-ORG ", 8);
+	memset(&buf[16], 0x20, 16);
+	memcpy(&buf[16], dev->se_sub_dev->t10_wwn.model,
+	       min_t(size_t, strlen(dev->se_sub_dev->t10_wwn.model), 16));
+	memcpy(&buf[32], dev->se_sub_dev->t10_wwn.revision,
+	       min_t(size_t, strlen(dev->se_sub_dev->t10_wwn.revision), 4));
 	buf[4] = 31; /* Set additional length to 31 */
 
 out:

