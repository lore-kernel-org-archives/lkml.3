Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3CHMDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:03:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41919 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab3CHMDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:03:47 -0500
Date: Fri, 8 Mar 2013 15:02:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] scsi_transport_sas: check for allocation failure
Message-ID: <20130308120215.GB18712@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static checkers complain that this allocation isn't checked.  We
should return zero if the allocation fails.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1b68142..a022997 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -379,9 +379,12 @@ sas_tlr_supported(struct scsi_device *sdev)
 {
 	const int vpd_len = 32;
 	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
-	char *buffer = kzalloc(vpd_len, GFP_KERNEL);
+	char *buffer;
 	int ret = 0;
 
+	buffer = kzalloc(vpd_len, GFP_KERNEL);
+	if (!buffer)
+		goto out;
 	if (scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
 		goto out;
 
