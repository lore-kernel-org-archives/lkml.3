Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab3IKHjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:39:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3IKHjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:39:08 -0400
Date: Wed, 11 Sep 2013 10:38:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Miller <mike.miller@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: iss_storagedev@hp.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Moritz Muehlenhoff <jmm@debian.org>
Subject: [patch -resend] cciss: info leak in cciss_ioctl32_passthru()
Message-ID: <20130911073832.GB25349@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603092645.GD16171@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arg64 struct has a hole after ->buf_size which isn't cleared.
Or if any of the calls to copy_from_user() fail then that would
cause an information leak as well.

This was assigned CVE-2013-2147.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6374dc1..34971aa 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1189,6 +1189,7 @@ static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |=
 	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
