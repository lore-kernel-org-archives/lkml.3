Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3CAFYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:24:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31610 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3CAFYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:24:00 -0500
Date: Fri, 1 Mar 2013 08:21:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] i2o: check copy_from_user() size parameter
Message-ID: <20130301052155.GC2669@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the size of the copy so we don't corrupt memory.  Hopefully
this can only be called by root, but fixing this makes the static
checkers happier.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index 5451bef..a60c188 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -687,6 +687,11 @@ static int i2o_cfg_passthru32(struct file *file, unsigned cmnd,
 		}
 		size = size >> 16;
 		size *= 4;
+		if (size > sizeof(rmsg)) {
+			rcode = -EINVAL;
+			goto sg_list_cleanup;
+		}
+
 		/* Copy in the user's I2O command */
 		if (copy_from_user(rmsg, user_msg, size)) {
 			rcode = -EFAULT;
@@ -922,6 +927,11 @@ static int i2o_cfg_passthru(unsigned long arg)
 		}
 		size = size >> 16;
 		size *= 4;
+		if (size > sizeof(rmsg)) {
+			rcode = -EFAULT;
+			goto sg_list_cleanup;
+		}
+
 		/* Copy in the user's I2O command */
 		if (copy_from_user(rmsg, user_msg, size)) {
 			rcode = -EFAULT;
