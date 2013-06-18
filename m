Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3FRHFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:05:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25619 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3FRHFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:05:42 -0400
Date: Tue, 18 Jun 2013 10:05:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] fbmem: return -EFAULT on copy_to_user() failure
Message-ID: <20130618070529.GA12329@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns the number of bytes remaining to be copied.
put_user() returns -EFAULT on error.

This function ORs a bunch of stuff together and returns jumbled non-zero
values on error.  It should return -EFAULT.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 098bfc6..9217be3 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1305,7 +1305,9 @@ static int do_fscreeninfo_to_user(struct fb_fix_screeninfo *fix,
 	err |= copy_to_user(fix32->reserved, fix->reserved,
 			    sizeof(fix->reserved));
 
-	return err;
+	if (err)
+		return -EFAULT;
+	return 0;
 }
 
 static int fb_get_fscreeninfo(struct fb_info *info, unsigned int cmd,
