Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3IAURR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 16:17:17 -0400
Received: from smtp.bbn.com ([128.33.1.81]:38566 "EHLO smtp.bbn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3IAURP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 16:17:15 -0400
X-Greylist: delayed 1077 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Sep 2013 16:17:15 EDT
X-Submitted: to socket.bbn.com (Postfix) with ESMTPSA id 51BB13FFAE
From: Richard Hansen <rhansen@bbn.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Richard Hansen <rhansen@bbn.com>
Subject: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
Date: Sun,  1 Sep 2013 15:58:57 -0400
Message-Id: <1378065537-7222-1-git-send-email-rhansen@bbn.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the flags parameter, POSIX says "Either MS_ASYNC or MS_SYNC shall
be specified, but not both." [1]  There was already a test for the
"both" condition.  Add a test to ensure that the caller specified one
of the flags; fail with EINVAL if neither are specified.

Without this change, specifying neither is the same as specifying
flags=MS_ASYNC because nothing in msync() is conditioned on the
MS_ASYNC flag.  This has not always been true, and there's no good
reason to believe that this behavior would have persisted
indefinitely.

The msync(2) man page (as currently written in man-pages.git) is
silent on the behavior if both flags are unset, so this change should
not break an application written by somone who carefully reads the
Linux man pages or the POSIX spec.

[1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/msync.html

Signed-off-by: Richard Hansen <rhansen@bbn.com>
Reported-by: Greg Troxel <gdt@ir.bbn.com>
Reviewed-by: Greg Troxel <gdt@ir.bbn.com>
---
 mm/msync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/msync.c b/mm/msync.c
index 632df45..472ad3e 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -42,6 +42,8 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 		goto out;
 	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
 		goto out;
+	if (!(flags & (MS_ASYNC | MS_SYNC)))
+		goto out;
 	error = -ENOMEM;
 	len = (len + ~PAGE_MASK) & PAGE_MASK;
 	end = start + len;
-- 
1.8.4

