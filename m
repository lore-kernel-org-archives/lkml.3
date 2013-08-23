Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab3HWR7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:59:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58704 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730Ab3HWR7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:59:41 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v3] Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default
Date: Fri, 23 Aug 2013 20:55:33 +0300
Message-Id: <1377280533-15349-1-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <CAMuHMdXRb2K+WSfFGK=SASTU=+fUZ3XRQQ-+5xoDS=04HG92OQ@mail.gmail.com>
References: <CAMuHMdXRb2K+WSfFGK=SASTU=+fUZ3XRQQ-+5xoDS=04HG92OQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common error fount in forward-ported/backported patches is missing headers.
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

Now it's a fatal error. Tested on x86_64 allyesconfig.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Makefile | 6 +++++++
 1 file changed, 6 insertions(+)

Change since v2:
 - moved CFLAGS checks lower to catch $(CROSS) case
   as suggested by Geert
 - added comments as other warning options do

Change since v1:
 - use 'cc-option' to respect old gccs
 - fix typos. Thanks to Oleg Verych

diff --git a/Makefile b/Makefile
index a5a55f4..f5f36e1 100644
--- a/Makefile
+++ b/Makefile
@@ -659,6 +660,12 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
 # conserve stack if available
 KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
 
+# disallog errors like 'EXPORT_GPL(foo);' with missing header
+KBUILD_CFLAGS   += $(call cc-option,-Werror=implicit-int)
+
+# require functions to have argumens in prototypes, not empty 'int foo()'
+KBUILD_CFLAGS   += $(call cc-option,-Werror=strict-prototypes)
+
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
-- 
1.8.3.2

