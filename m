Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3DWQbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:31:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50637 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab3DWQbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:31:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/21] Turn off -Wmaybe-uninitialized when building with -Os
Date: Tue, 23 Apr 2013 18:30:33 +0200
Message-Id: <1366734653-488286-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Au/3/CW7U3E4IVrv4g3CLU1GVV3goXI1L6KNhDXTDgl
 IcGqhxy2/y/4zBsOqdMYpyYeuNn2ZGyFxaDi5Bi6Ea+Z7P4TdE
 t1XC6TDXer7Ci/kVJJIDGRWmCEKe1qTg6z6wl0bINqW9MNuKZo
 ndM3RHDAtg4ayz8nz5/wTkTSuuGxUtDxXth1YlQJnYktbdyYNj
 aDezd1CAo3GZ9SV9jVPsBilf29G35AGtTdpPTO73PYmPIMtrHj
 p4dYO2m+OAoJS5hWU+SqbRp3UYp0MAJJJleDZzSwDCz2QbyV2A
 Wlrj6vPCol06kDDRT3HnRHDMLegfhBBo1DCoYcED29vdGP7Fi6
 ucmrugTBhBL+mOTb4DrodxEvuC4UM2xbFcW18+DvR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc-4.7 and higher add a lot of false positive warnings about
potential uses of uninitialized warnings, but only when optimizing
for size (-Os). This is the default when building allyesconfig,
which turns on CONFIG_CC_OPTIMIZE_FOR_SIZE.

In order to avoid getting a lot of patches that initialize such
variables and accidentally hide real errors along the way, let's
just turn off this warning on the respective gcc versions
when building with size optimizations. The -Wmaybe-uninitialized
option was introduced in the same gcc version (4.7) that is now
causing the false positives, so there is no effect on older compilers.

A side effect is that when building with CONFIG_CC_OPTIMIZE_FOR_SIZE,
we might now see /fewer/ warnings about possibly uninitialized
warnings than with -O2, but that is still much better than seeing
warnings known to be bogus.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 46263d8..dc87b2e 100644
--- a/Makefile
+++ b/Makefile
@@ -571,7 +571,7 @@ endif # $(dot-config)
 all: vmlinux
 
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
-KBUILD_CFLAGS	+= -Os
+KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
 else
 KBUILD_CFLAGS	+= -O2
 endif
-- 
1.8.1.2

