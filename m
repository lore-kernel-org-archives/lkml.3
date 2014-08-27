Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbaH0LD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:03:59 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:40471 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaH0LD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:03:58 -0400
Date: Wed, 27 Aug 2014 15:03:53 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] prctl: Return -EFAULT on auxv fetching failure
Message-ID: <20140827110353.GC8692@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan reported that returning bytes left if copy_from_user failed
is a bad option, return traditional -EFAULT instead.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
Dan, this is not for current linux-next, but for Andrew's -mm
queue, since he has prctl code already updated with v4 of the
former patch.

 kernel/sys.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1814,11 +1814,10 @@ static int prctl_set_mm_map(int opt, con
 
 	if (prctl_map.auxv_size) {
 		memset(user_auxv, 0, sizeof(user_auxv));
-		error = copy_from_user(user_auxv,
-				       (const void __user *)prctl_map.auxv,
-				       prctl_map.auxv_size);
-		if (error)
-			return error;
+		if (copy_from_user(user_auxv,
+				   (const void __user *)prctl_map.auxv,
+				   prctl_map.auxv_size))
+			return -EFAULT;
 
 		/* Last entry must be AT_NULL as specification requires */
 		user_auxv[AT_VECTOR_SIZE - 2] = AT_NULL;
