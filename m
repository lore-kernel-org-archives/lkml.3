Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab3IMIGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:06:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47951 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3IMIGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:06:05 -0400
Date: Fri, 13 Sep 2013 11:05:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Akhil Bhansali <abhansali@stec-inc.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 3/4] skd: use strncpy() as a cleanup
Message-ID: <20130913080539.GG19211@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code here is copying the version to inq.driver_version but we don't
want it to be NUL terminated.  Instead we pad the rest of the array with
spaces.  It's fewer lines to use strncpy() and maybe a little nicer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index f892d95..20ad843 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -2899,9 +2899,7 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
 			       volatile struct fit_comp_error_info *skerr,
 			       uint8_t *cdb, uint8_t *buf)
 {
-	unsigned ver_byte;
 	unsigned max_bytes;
-	char *ver = DRV_VER_COMPL;
 	struct driver_inquiry_data inq;
 	u16 val;
 
@@ -2945,12 +2943,8 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
 	/* Driver version, fixed lenth, padded with spaces on the right */
 	inq.driver_version_length = sizeof(inq.driver_version);
 	memset(&inq.driver_version, ' ', sizeof(inq.driver_version));
-	for (ver_byte = 0; ver_byte < sizeof(inq.driver_version); ver_byte++) {
-		if (ver[ver_byte] != 0)
-			inq.driver_version[ver_byte] = ver[ver_byte];
-		else
-			break;
-	}
+	strncpy(inq.driver_version, DRV_VER_COMPL,
+		min(sizeof(inq.driver_version), strlen(DRV_VER_COMPL)));
 
 	inq.page_length = cpu_to_be16((sizeof(inq) - 4));
 
