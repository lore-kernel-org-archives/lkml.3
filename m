Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052Ab3ARHnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:43:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37665 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3ARHnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:43:23 -0500
Date: Fri, 18 Jan 2013 10:43:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] module: potential deadlock in error path
Message-ID: <20130118074309.GB31793@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We take the lock twice if we hit this goto.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/module.c b/kernel/module.c
index d25e359..2eefa7d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3239,8 +3239,10 @@ again:
 	mutex_lock(&module_mutex);
 	/* Find duplicate symbols (must be called under lock). */
 	err = verify_export_symbols(mod);
-	if (err < 0)
+	if (err < 0) {
+		mutex_unlock(&module_mutex);
 		goto ddebug_cleanup;
+	}
 
 	/* This relies on module_mutex for list integrity. */
 	module_bug_finalize(info->hdr, info->sechdrs, mod);
