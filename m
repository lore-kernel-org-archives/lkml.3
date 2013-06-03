Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3FCJ1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:27:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22987 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3FCJ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:27:07 -0400
Date: Mon, 3 Jun 2013 12:26:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] cciss: info leak in cciss_ioctl32_passthru()
Message-ID: <20130603092645.GD16171@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arg64 struct has a hole after ->buf_size which isn't cleared.
Or if any of the calls to copy_from_user() fail then that would
cause an information leak as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6374dc1..34971aa 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1201,6 +1201,7 @@ static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |=
 	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
