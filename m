Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3IKE5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3IKE4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:45 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=pDyNW5_ZZjwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=il89Ef1dU68A:10 a=z11f-joXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=CJVq-v20pXUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042934.435068767@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tomas Molota <tomas.molota@lightstorm.sk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [251/251] target: Fix trailing ASCII space usage in INQUIRY vendor+model
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0251-target-Fix-trailing-ASCII-space-usage-in-INQUIRY-ven.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

[ Upstream commit ee60bddba5a5f23e39598195d944aa0eb2d455e5 ]

This patch fixes spc_emulate_inquiry_std() to add trailing ASCII
spaces for INQUIRY vendor + model fields following SPC-4 text:

  "ASCII data fields described as being left-aligned shall have any
   unused bytes at the end of the field (i.e., highest offset) and
   the unused bytes shall be filled with ASCII space characters (20h)."

This addresses a problem with Falconstor NSS multipathing.

Reported-by: Tomas Molota <tomas.molota@lightstorm.sk>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/target/target_core_spc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 6fd434d..290041b 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -100,9 +100,12 @@ static int spc_emulate_inquiry_std(struct se_cmd *cmd, char *buf)
 
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
1.7.10.4


