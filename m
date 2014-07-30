Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaG3G0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:26:30 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:20557 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbaG3G03 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:26:29 -0400
From: Nilesh Javali <nilesh.javali@qlogic.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Vikas Chaudhary" <vikas.chaudhary@qlogic.com>,
        Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: qla4xxx: ql4_mbx.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
Thread-Topic: [PATCH] scsi: qla4xxx: ql4_mbx.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
Thread-Index: AQHPqartC/6vmequq0ixuVr9rXsurZu4Kt8Q
Date: Wed, 30 Jul 2014 06:26:21 +0000
Message-ID: <058691E078642A44B7C96BB0B1DB4F2446C29A25@avmb2.qlogic.org>
References: <1406473062-12509-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1406473062-12509-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7514 signatures=670489
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1407300083
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Nilesh Javali <nilesh.javali@qlogic.com>


-----Original Message-----
From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se] 
Sent: Sunday, July 27, 2014 8:28 PM
To: Vikas Chaudhary; Dept-Eng iSCSI Driver
Cc: Rickard Strandqvist; James E.J. Bottomley; linux-scsi; linux-kernel
Subject: [PATCH] scsi: qla4xxx: ql4_mbx.c: Cleaning up missing null-terminate in conjunction with strncpy

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And in some cases modified to copy one character less than the overall length, as the entire area is already zeroed.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c index 0a3312c..2b2756e 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1620,8 +1620,8 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha, char *username, char *password,
 		goto exit_get_chap;
 	}
 
-	strncpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
-	strncpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
+	strlcpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
+	strlcpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
 	chap_table->cookie = __constant_cpu_to_le16(CHAP_VALID_COOKIE);
 
 exit_get_chap:
@@ -1663,8 +1663,8 @@ int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
 	else
 		chap_table->flags |= BIT_7; /* local */
 	chap_table->secret_len = strlen(password);
-	strncpy(chap_table->secret, password, MAX_CHAP_SECRET_LEN);
-	strncpy(chap_table->name, username, MAX_CHAP_NAME_LEN);
+	strncpy(chap_table->secret, password, MAX_CHAP_SECRET_LEN - 1);
+	strncpy(chap_table->name, username, MAX_CHAP_NAME_LEN - 1);
 	chap_table->cookie = __constant_cpu_to_le16(CHAP_VALID_COOKIE);
 
 	if (is_qla40XX(ha)) {
@@ -1742,8 +1742,8 @@ int qla4xxx_get_uni_chap_at_index(struct scsi_qla_host *ha, char *username,
 		goto exit_unlock_uni_chap;
 	}
 
-	strncpy(password, chap_table->secret, MAX_CHAP_SECRET_LEN);
-	strncpy(username, chap_table->name, MAX_CHAP_NAME_LEN);
+	strlcpy(password, chap_table->secret, MAX_CHAP_SECRET_LEN);
+	strlcpy(username, chap_table->name, MAX_CHAP_NAME_LEN);
 
 	rval = QLA_SUCCESS;
 
@@ -2295,7 +2295,7 @@ int qla4_8xxx_set_param(struct scsi_qla_host *ha, int param)
 	if (param == SET_DRVR_VERSION) {
 		mbox_cmd[1] = SET_DRVR_VERSION;
 		strncpy((char *)&mbox_cmd[2], QLA4XXX_DRIVER_VERSION,
-			MAX_DRVR_VER_LEN);
+			MAX_DRVR_VER_LEN - 1);
 	} else {
 		ql4_printk(KERN_ERR, ha, "%s: invalid parameter 0x%x\n",
 			   __func__, param);
--
1.7.10.4

