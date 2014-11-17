Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaKQFML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 00:12:11 -0500
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:61750 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbaKQFMJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 00:12:09 -0500
From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V4 linux-next RESEND 2] bfa: replace 2
 kzalloc/copy_from_user by memdup_user
Thread-Topic: [PATCH V4 linux-next RESEND 2] bfa: replace 2
 kzalloc/copy_from_user by memdup_user
Thread-Index: AQHQADvO/bHQKLvWKUSLTcWGklbMaJxkSO0w
Date: Mon, 17 Nov 2014 05:11:46 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59FD4166@avmb2.qlogic.org>
References: <1415990998-29659-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1415990998-29659-1-git-send-email-fabf@skynet.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7624 signatures=670576
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1411170048
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch looks good. 
Thanks!
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: Fabian Frederick [mailto:fabf@skynet.be] 
Sent: 15 November 2014 00:20
To: linux-kernel
Cc: Joe Perches; Greg Kroah-Hartman; One Thousand Gnomes; Fabian Frederick; Anil Gurumurthy; Sudarsana Kalluru; James E.J. Bottomley; linux-scsi
Subject: [PATCH V4 linux-next RESEND 2] bfa: replace 2 kzalloc/copy_from_user by memdup_user

This patch also removes unnecessary printk(KERN_INFO

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V4: remove blank line after memdup_user
V3: memdup_user first argument is already void __user * (thanks to Joe Perches)
    typo in title
V2: Remove printk(KERN_INFO (suggested by Alan)

 drivers/scsi/bfa/bfad_debugfs.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c index 8e83d04..74a307c 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -260,18 +260,9 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = kzalloc(nbytes, GFP_KERNEL);
-
-	if (!kern_buf) {
-		printk(KERN_INFO "bfad[%d]: Failed to allocate buffer\n",
-				bfad->inst_no);
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
-		kfree(kern_buf);
-		return -ENOMEM;
-	}
+	kern_buf = memdup_user(buf, nbytes);
+	if (IS_ERR(kern_buf))
+		return PTR_ERR(kern_buf);
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &len);
 	if (rc < 2) {
@@ -336,18 +327,9 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = kzalloc(nbytes, GFP_KERNEL);
-
-	if (!kern_buf) {
-		printk(KERN_INFO "bfad[%d]: Failed to allocate buffer\n",
-				bfad->inst_no);
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
-		kfree(kern_buf);
-		return -ENOMEM;
-	}
+	kern_buf = memdup_user(buf, nbytes);
+	if (IS_ERR(kern_buf))
+		return PTR_ERR(kern_buf);
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &val);
 	if (rc < 2) {
--
1.9.3

