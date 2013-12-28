Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3L1BXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 20:23:47 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33311 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3L1BXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 20:23:46 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] compat_readv: Remove bogus area verify
Date: Fri, 27 Dec 2013 19:23:18 -0600
Message-Id: <1388193798-1966-1-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compat_do_readv_writev() function was doing a verify_area on the
incoming iov, but the nr_segs value is not checked.  If someone passes
in a -1 for nr_segs, for instance, the function should return an EINVAL.
However, it returns a EFAULT because the verify_area fails because it
is checking an array of size MAX_UINT.  The check is bogus, anyway,
because the next check, compat_rw_copy_check_uvector(), will do all
the necessary checking, anyway.  The non-compat do_readv_writev()
function doesn't do this check, so I think it's safe to just remove
the code.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 fs/read_write.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 58e440d..1193ffd 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -901,10 +901,6 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 	io_fn_t fn;
 	iov_fn_t fnv;
 
-	ret = -EFAULT;
-	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
-		goto out;
-
 	ret = compat_rw_copy_check_uvector(type, uvector, nr_segs,
 					       UIO_FASTIOV, iovstack, &iov);
 	if (ret <= 0)
-- 
1.8.3.1

