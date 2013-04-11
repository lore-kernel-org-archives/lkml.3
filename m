Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358Ab3DKUcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:32:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20087 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab3DKU0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:15 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=bRAdfqHWGMgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Js9sr0MTzmkA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=z11f-joXAAAA:8 a=QzHpnufsAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=jEp0ucaQiEUA:10 a=CJVq-v20pXUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202553.855737100@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 047/171 ] target/iscsi: Fix mutual CHAP auth on big-endian arches
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0047-target-iscsi-Fix-mutual-CHAP-auth-on-big-endian-arch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Andy Grover <agrover@redhat.com>

[ Upstream commit 7ac9ad11b2a5cf77a92b58ee6b672ad2fa155eb1 ]

See https://bugzilla.redhat.com/show_bug.cgi?id=916290

Used a temp var since we take its address in sg_init_one.

Signed-off-by: Andy Grover <agrover@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/target/iscsi/iscsi_target_auth.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index db0cf7c..a0fc7b9 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -166,6 +166,7 @@ static int chap_server_compute_md5(
 {
 	char *endptr;
 	unsigned long id;
+	unsigned char id_as_uchar;
 	unsigned char digest[MD5_SIGNATURE_SIZE];
 	unsigned char type, response[MD5_SIGNATURE_SIZE * 2 + 2];
 	unsigned char identifier[10], *challenge = NULL;
@@ -355,7 +356,9 @@ static int chap_server_compute_md5(
 		goto out;
 	}
 
-	sg_init_one(&sg, &id, 1);
+	/* To handle both endiannesses */
+	id_as_uchar = id;
+	sg_init_one(&sg, &id_as_uchar, 1);
 	ret = crypto_hash_update(&desc, &sg, 1);
 	if (ret < 0) {
 		pr_err("crypto_hash_update() failed for id\n");
-- 
1.7.10.4


