Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081AbaE2OSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:18:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59351 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933197AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 019/103] SCSI: megaraid: missing bounds check in mimd_to_kioc()
Date: Thu, 29 May 2014 15:48:04 +0200
Message-Id: <ef57e93eaa37b483191b5949b816d22ae441b45a.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3de2260140417759c669d391613d583baf03b0cf upstream.

pthru32->dataxferlen comes from the user so we need to check that it's
not too large so we don't overflow the buffer.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/megaraid/megaraid_mm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index dfffd0f37916..a70692779a16 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -486,6 +486,8 @@ mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
 
 	pthru32->dataxferaddr	= kioc->buf_paddr;
 	if (kioc->data_dir & UIOC_WR) {
+		if (pthru32->dataxferlen > kioc->xferlen)
+			return -EINVAL;
 		if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
 						pthru32->dataxferlen)) {
 			return (-EFAULT);
-- 
1.9.3

