Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaAOLqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:46:08 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:46031 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaAOLqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:46:04 -0500
Date: Wed, 15 Jan 2014 12:45:57 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] compat: fix sys_fanotify_mark
Message-ID: <20140115114557.GC6638@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011511-4966-0000-0000-000008131FD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

91c2e0bcae72 "unify compat fanotify_mark(2), switch to COMPAT_SYSCALL_DEFINE"
added a new unified compat fanotify_mark syscall to be used by all
architectures.
Unfortunately the unified version merges the split mask parameter in a
wrong way: the lower and higher word got swapped.

This was discovered with glibc's tst-fanotify test case.

Reported-by: Andreas Krebbel <krebbel@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: stable@vger.kernel.org # v3.10+
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/notify/fanotify/fanotify_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index e44cb6427df3..6663511ab33a 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -888,9 +888,9 @@ COMPAT_SYSCALL_DEFINE6(fanotify_mark,
 {
 	return sys_fanotify_mark(fanotify_fd, flags,
 #ifdef __BIG_ENDIAN
-				((__u64)mask1 << 32) | mask0,
-#else
 				((__u64)mask0 << 32) | mask1,
+#else
+				((__u64)mask1 << 32) | mask0,
 #endif
 				 dfd, pathname);
 }
-- 
1.8.4.5

