Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab3FCWNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:13:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23918 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101Ab3FCWMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:38 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=KRzPvbhR7qkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gkifgL1Z3PQA:10 a=CbDCq_QkAAAA:8 a=VwQbUJbxAAAA:8 a=z11f-joXAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=E3yz0KKPV6YA:10 a=CJVq-v20pXUA:10 a=jeBq3FmKZ4MA:10 a=CjYXQKFBhWSymi5A:21 a=X5CC4MxToUbXtVCp:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221200.647918318@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Shlomo Pongratz <shlomop@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [49/65] iscsi-target: Fix processing of OOO commands
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0049-iscsi-target-Fix-processing-of-OOO-commands.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Shlomo Pongratz <shlomop@mellanox.com>

[ Upstream commit 3eccfdb01da58fbd0f789ae6ca61cee3769e26de ]

Fix two issues in OOO commands processing done at iscsit_attach_ooo_cmdsn.

Handle command serial numbers wrap around by using iscsi_sna_lt and not regular comparisson.

The routine iterates until it finds an entry whose serial number is greater than the serial number of
the new one, thus the new entry should be inserted before that entry and not after.

Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/target/iscsi/iscsi_target_erl1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 3df8a2c..a0b78d6 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -819,7 +819,7 @@ static int iscsit_attach_ooo_cmdsn(
 		/*
 		 * CmdSN is greater than the tail of the list.
 		 */
-		if (ooo_tail->cmdsn < ooo_cmdsn->cmdsn)
+		if (iscsi_sna_lt(ooo_tail->cmdsn, ooo_cmdsn->cmdsn))
 			list_add_tail(&ooo_cmdsn->ooo_list,
 					&sess->sess_ooo_cmdsn_list);
 		else {
@@ -829,11 +829,12 @@ static int iscsit_attach_ooo_cmdsn(
 			 */
 			list_for_each_entry(ooo_tmp, &sess->sess_ooo_cmdsn_list,
 						ooo_list) {
-				if (ooo_tmp->cmdsn < ooo_cmdsn->cmdsn)
+				if (iscsi_sna_lt(ooo_tmp->cmdsn, ooo_cmdsn->cmdsn))
 					continue;
 
+				/* Insert before this entry */
 				list_add(&ooo_cmdsn->ooo_list,
-					&ooo_tmp->ooo_list);
+					ooo_tmp->ooo_list.prev);
 				break;
 			}
 		}
-- 
1.7.10.4


