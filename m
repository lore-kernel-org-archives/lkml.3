Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021AbaBDVUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:20:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934439AbaBDVMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.13 132/140] SCSI: qla4xxx: overflow in qla4xxx_set_chap_entry()
Date: Tue,  4 Feb 2014 13:11:59 -0800
Message-Id: <20140204211040.736192545@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3c60cfd73966797746530768d66597d025a69804 upstream.

We should cap the size of memcpy() because it comes from the network
and can't be trusted.

Fixes: 26ffd7b45fe9 ('[SCSI] qla4xxx: Add support to set CHAP entries')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla4xxx/ql4_os.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -802,6 +802,7 @@ static int qla4xxx_set_chap_entry(struct
 	int type;
 	int rem = len;
 	int rc = 0;
+	int size;
 
 	memset(&chap_rec, 0, sizeof(chap_rec));
 
@@ -816,12 +817,14 @@ static int qla4xxx_set_chap_entry(struct
 			chap_rec.chap_type = param_info->value[0];
 			break;
 		case ISCSI_CHAP_PARAM_USERNAME:
-			memcpy(chap_rec.username, param_info->value,
-			       param_info->len);
+			size = min_t(size_t, sizeof(chap_rec.username),
+				     param_info->len);
+			memcpy(chap_rec.username, param_info->value, size);
 			break;
 		case ISCSI_CHAP_PARAM_PASSWORD:
-			memcpy(chap_rec.password, param_info->value,
-			       param_info->len);
+			size = min_t(size_t, sizeof(chap_rec.password),
+				     param_info->len);
+			memcpy(chap_rec.password, param_info->value, size);
 			break;
 		case ISCSI_CHAP_PARAM_PASSWORD_LEN:
 			chap_rec.password_length = param_info->value[0];


