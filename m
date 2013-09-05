Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab3IEU3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:29:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618Ab3IEU2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Molota <tomas.molota@lightstorm.sk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 6/7] target: Fix trailing ASCII space usage in INQUIRY vendor+model
Date: Thu,  5 Sep 2013 13:28:39 -0700
Message-Id: <20130905202758.355249110@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202757.642048278@linuxfoundation.org>
References: <20130905202757.642048278@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_cdb.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -117,11 +117,12 @@ target_emulate_inquiry_std(struct se_cmd
 		return 0;
 	}
 
-	snprintf((unsigned char *)&buf[8], 8, "LIO-ORG");
-	snprintf((unsigned char *)&buf[16], 16, "%s",
-		 &DEV_T10_WWN(dev)->model[0]);
-	snprintf((unsigned char *)&buf[32], 4, "%s",
-		 &DEV_T10_WWN(dev)->revision[0]);
+	memcpy(&buf[8], "LIO-ORG ", 8);
+	memset(&buf[16], 0x20, 16);
+	memcpy(&buf[16], dev->se_sub_dev->t10_wwn.model,
+	       min_t(size_t, strlen(dev->se_sub_dev->t10_wwn.model), 16));
+	memcpy(&buf[32], dev->se_sub_dev->t10_wwn.revision,
+	       min_t(size_t, strlen(dev->se_sub_dev->t10_wwn.revision), 4));
 	buf[4] = 31; /* Set additional length to 31 */
 	return 0;
 }


