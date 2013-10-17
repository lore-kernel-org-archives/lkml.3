Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab3JQQoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:44:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35516 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab3JQQod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:44:33 -0400
Date: Thu, 17 Oct 2013 19:44:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tim Waugh <tim@cyberelk.net>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -resend] paride: underflow bug in pg_write()
Message-ID: <20131017164418.GH11731@mwanda>
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
---
I sent this originally Jul 31, 2013 but there was no response.

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
