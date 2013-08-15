Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab3HOSlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:41:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40661 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab3HOSk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:40:58 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default
Date: Thu, 15 Aug 2013 21:37:31 +0300
Message-Id: <1376591851-31854-1-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common error type found in forward-ported/backported patches is missing headers.
One recent example (files and function names are mangled):

    void foo(){}
    EXPORT_SYMBOL(foo);

gave only warning

    foo.c:12345678:5: warning: function declaration isn't a prototype [-Wstrict-prototypes]
    void foo(){}
         ^

    foo.c:12345679:5: warning: data definition has no type or storage class [enabled by default]
    EXPORT_SYMBOL(foo);
    foo.c:12345679:5: warning: type defaults to 'int' in declaration of 'EXORT_SYMBOL' [-Werror=implicit-int]

Now it's a fata error. Tested on x86_64 allyesconfig.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 Makefile | 5 +++++
 1 file changed, 5 insertions(+)

Change since v1:
 - use 'cc-option' to respect old gccs
 - fix typos. Thanks to Oleg Verych

diff --git a/Makefile b/Makefile
index 6e48848..53f4776 100644
--- a/Makefile
+++ b/Makefile
@@ -374,6 +374,11 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -Werror-implicit-function-declaration \
 		   -Wno-format-security \
 		   -fno-delete-null-pointer-checks
+
+# not universally available, but nice to have ones
+KBUILD_CFLAGS   +=  $(call cc-option,-Werror=implicit-int) \
+		    $(call cc-option,-Werror=strict-prototypes)
+
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
 KBUILD_AFLAGS   := -D__ASSEMBLY__
-- 
1.8.3.2

