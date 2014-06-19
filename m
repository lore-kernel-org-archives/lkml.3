Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbaFSOoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:44:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39580 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435AbaFSOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:44:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Makefile: version.h macros KERNEL_EXTRAVERSION, LINUX_EXTRAVERSION_CODE
Date: Thu, 19 Jun 2014 07:44:18 -0700
Message-Id: <1403189058-24103-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds new macro KERNEL_EXTRAVERSION(a,b,c,d) and value
LINUX_EXTRAVERSION_CODE to version.h, allowing ranged version checks of
extended-stable versions that use a numeric EXTRAVERSION value.

The new KERNEL_EXTRAVERSION(a,b,c,d) works like KERNEL_VERSION(a,b,c)...
If EXTRAVERSION is set to ".{integer}" (the common extended-stable kernel
version number scheme) then {integer} corresponds to KERNEL_EXTRAVERSION's
fourth arg.  If EXTRAVERSION is blank or a non-".{integer}" string like
"-rc5", that corresponds to a fourth parameter of 0.

Example usage:

  #if ( LINUX_EXTRAVERSION_CODE >= KERNEL_EXTRAVERSION(3,13,11,5) )
      // compiles for (3.13.11 with "EXTRAVERSION = .5") or greater value
  #endif

Cc: stable@vger.kernel.org
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 97b2861..e579628 100644
--- a/Makefile
+++ b/Makefile
@@ -953,10 +953,15 @@ define filechk_utsrelease.h
 	(echo \#define UTS_RELEASE \"$(KERNELRELEASE)\";)
 endef
 
+extraversionnum := $(shell \
+	echo "$(EXTRAVERSION)" | sed -n '/\.\([0-9]*\).*/s//\1/p')
 define filechk_version.h
 	(echo \#define LINUX_VERSION_CODE $(shell                         \
 	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
-	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
+	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'; \
+	echo \#define LINUX_EXTRAVERSION_CODE $(shell                      \
+	expr $(VERSION) \* 268435456 + 0$(PATCHLEVEL) \* 1048576 + 0$(SUBLEVEL) \* 4096 + 0$(extraversionnum)); \
+	echo '#define KERNEL_EXTRAVERSION(a,b,c,d) (((a)<<28) + ((b)<<20) + ((c)<<12) + (d))';)
 endef
 
 $(version_h): $(srctree)/Makefile FORCE
-- 
1.9.1

