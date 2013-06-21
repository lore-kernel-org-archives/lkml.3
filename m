Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423106Ab3FUGVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:21:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43795 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423047Ab3FUGVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:21:22 -0400
Date: Fri, 21 Jun 2013 09:21:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joshua Morris <josh.h.morris@us.ibm.com>
Cc: Philip Kelleher <pjk1939@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] rsxx: returning bytes remaining instead of -EFAULT
Message-ID: <20130621062111.GC10873@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to/from_user() returns the number of bytes remaining to be copied.
We should return -EFAULT here instead.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index 6e85e21..102dc60 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -199,9 +199,8 @@ static ssize_t rsxx_cram_read(struct file *fp, char __user *ubuf,
 	if (st)
 		return st;
 
-	st = copy_to_user(ubuf, buf, cnt);
-	if (st)
-		return st;
+	if (copy_to_user(ubuf, buf, cnt))
+		return -EFAULT;
 
 	info->offset += cnt;
 
@@ -222,9 +221,8 @@ static ssize_t rsxx_cram_write(struct file *fp, const char __user *ubuf,
 	if (!buf)
 		return -ENOMEM;
 
-	st = copy_from_user(buf, ubuf, cnt);
-	if (st)
-		return st;
+	if (copy_from_user(buf, ubuf, cnt))
+		return -EFAULT;
 
 	info->f_pos = (u32)*ppos + info->offset;
 
