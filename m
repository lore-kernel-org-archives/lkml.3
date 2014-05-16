Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaEPWwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:52:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaEPWwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:52:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sumit Saxena <sumit.saxena@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.4 1/9] SCSI: megaraid: missing bounds check in mimd_to_kioc()
Date: Fri, 16 May 2014 15:55:24 -0700
Message-Id: <20140516225458.642634316@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140516225458.512693003@linuxfoundation.org>
References: <20140516225458.512693003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3de2260140417759c669d391613d583baf03b0cf upstream.

pthru32->dataxferlen comes from the user so we need to check that it's
not too large so we don't overflow the buffer.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_mm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -486,6 +486,8 @@ mimd_to_kioc(mimd_t __user *umimd, mraid
 
 	pthru32->dataxferaddr	= kioc->buf_paddr;
 	if (kioc->data_dir & UIOC_WR) {
+		if (pthru32->dataxferlen > kioc->xferlen)
+			return -EINVAL;
 		if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
 						pthru32->dataxferlen)) {
 			return (-EFAULT);


