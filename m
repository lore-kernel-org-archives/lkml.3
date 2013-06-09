Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab3FICev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:34:51 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35608 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3FICem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:34:42 -0400
From: Daniel Tang <dt.tangr@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Daniel Tang <dt.tangr@gmail.com>
Subject: [PATCH 2/2] Fix a build warning in scripts/mod/file2alias.c
Date: Sun,  9 Jun 2013 12:33:55 +1000
Message-Id: <1370745235-12951-2-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1370745235-12951-1-git-send-email-dt.tangr@gmail.com>
References: <1370745235-12951-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems, __used is already defined in sys/cdefs.h and causes
a build warning:

scripts/mod/file2alias.c:85:1: warning: "__used" redefined
In file included from /usr/include/stdio.h:64,
                 from scripts/mod/modpost.h:1,
		                  from scripts/mod/file2alias.c:13:
				  /usr/include/sys/cdefs.h:146:1: warning: this is the location of the previous definition

This adds an extra check before defining the __used macro to see if
the macro was already defined elsewhere.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 scripts/mod/file2alias.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 45f9a33..ab55456 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -79,10 +79,12 @@ struct devtable **__start___devtable, **__stop___devtable;
 extern struct devtable *__start___devtable[], *__stop___devtable[];
 #endif /* __MACH__ */
 
-#if __GNUC__ == 3 && __GNUC_MINOR__ < 3
-# define __used			__attribute__((__unused__))
-#else
-# define __used			__attribute__((__used__))
+#if !defined(__used)
+# if __GNUC__ == 3 && __GNUC_MINOR__ < 3
+#  define __used			__attribute__((__unused__))
+# else
+#  define __used			__attribute__((__used__))
+# endif
 #endif
 
 /* Define a variable f that holds the value of field f of struct devid
-- 
1.8.1.3

