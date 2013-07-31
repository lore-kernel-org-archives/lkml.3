Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab3GaJI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:08:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32656 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab3GaJIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:08:53 -0400
Date: Wed, 31 Jul 2013 12:08:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tim Waugh <tim@cyberelk.net>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] paride: underflow bug in pg_write()
Message-ID: <20130731090836.GE8210@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test here can underflow so we pass bogus lengths to the hardware.
It's a static checker fix and I don't know the impact.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index 4a27b1d..2ce3dfd 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -581,7 +581,7 @@ static ssize_t pg_write(struct file *filp, const char __user *buf, size_t count,
 
 	if (hdr.magic != PG_MAGIC)
 		return -EINVAL;
-	if (hdr.dlen > PG_MAX_DATA)
+	if (hdr.dlen < 0 || hdr.dlen > PG_MAX_DATA)
 		return -EINVAL;
 	if ((count - hs) > PG_MAX_DATA)
 		return -EINVAL;
