Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaESUge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:36:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36694 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaESUgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:36:32 -0400
Date: Mon, 19 May 2014 23:36:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] module: static checker complains about negative values
Message-ID: <20140519203626.GC5671@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cap "stat.size" at INT_MAX but we don't check for negative values so
my static checker complains.  At this point, you already have control of
the kernel and if you start passing negative values here then you
deserve what happens next.

On 64 bit systems the vmalloc() will definitely fail.  On 32 bit systems
we truncate the upper 32 bits away so that could succeed.  I haven't
followed it further than that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/module.c b/kernel/module.c
index 626d164..26e0d15 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2536,7 +2536,7 @@ static int copy_module_from_fd(int fd, struct load_info *info)
 	}
 
 	/* Don't hand 0 to vmalloc, it whines. */
-	if (stat.size == 0) {
+	if (stat.size <= 0) {
 		err = -EINVAL;
 		goto out;
 	}
