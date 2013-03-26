Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3CZXff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:35:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3CZWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 54/98] target/iscsi: Fix mutual CHAP auth on big-endian arches
Date: Tue, 26 Mar 2013 15:42:43 -0700
Message-Id: <20130326224248.155383340@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Grover <agrover@redhat.com>

commit 7ac9ad11b2a5cf77a92b58ee6b672ad2fa155eb1 upstream.

See https://bugzilla.redhat.com/show_bug.cgi?id=916290

Used a temp var since we take its address in sg_init_one.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_auth.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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


