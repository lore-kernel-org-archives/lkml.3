Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811Ab3FCWcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:32:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759854Ab3FCWaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:30:15 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=8aC3U0inCSEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ZcwOBv32gsYA:10 a=7mOBRU54AAAA:8 a=FBHGMhGWAAAA:8 a=vggBfdFIAAAA:8 a=gUd917i3lTiZiqr_J0AA:9 a=hkODgbchuuYA:10 a=_RhRFcbxBZMA:10 a=WeOa-AV5lc8A:10 a=j9nzo_0lS1QA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221202.386543094@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Jeroen Roovers <jer@gentoo.org>,
        John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [59/65] parisc: make default cross compiler search more robust (v3)
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0059-parisc-make-default-cross-compiler-search-more-robus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 6880b0150a7c25fd75c5ece80abc49ebf53c38c1 ]

People/distros vary how they prefix the toolchain name for 64bit builds.
Rather than enforce one convention over another, add a for loop which
does a search for all the general prefixes.

For 64bit builds, we now search for (in order):
	hppa64-unknown-linux-gnu
	hppa64-linux-gnu
	hppa64-linux

For 32bit builds, we look for:
	hppa-unknown-linux-gnu
	hppa-linux-gnu
	hppa-linux
	hppa2.0-unknown-linux-gnu
	hppa2.0-linux-gnu
	hppa2.0-linux
	hppa1.1-unknown-linux-gnu
	hppa1.1-linux-gnu
	hppa1.1-linux

This patch was initiated by Mike Frysinger, with feedback from Jeroen
Roovers, John David Anglin and Helge Deller.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Jeroen Roovers <jer@gentoo.org>
Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/parisc/Makefile |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 47cec3c..130fdd7 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -23,25 +23,21 @@ NM		= sh $(srctree)/arch/parisc/nm
 CHECKFLAGS	+= -D__hppa__=1
 LIBGCC		= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
-MACHINE		:= $(shell uname -m)
-NATIVE		:= $(if $(filter parisc%,$(MACHINE)),1,0)
-
 ifdef CONFIG_64BIT
 UTS_MACHINE	:= parisc64
 CHECKFLAGS	+= -D__LP64__=1 -m64
-WIDTH		:= 64
-
-# FIXME: if no default set, should really try to locate dynamically
-ifeq ($(CROSS_COMPILE),)
-CROSS_COMPILE	:= hppa64-linux-gnu-
-endif
+CC_ARCHES	= hppa64
 else # 32-bit
-WIDTH		:=
+CC_ARCHES	= hppa hppa2.0 hppa1.1
 endif
 
-# attempt to help out folks who are cross-compiling
-ifeq ($(NATIVE),1)
-CROSS_COMPILE	:= hppa$(WIDTH)-linux-
+ifneq ($(SUBARCH),$(UTS_MACHINE))
+	ifeq ($(CROSS_COMPILE),)
+		CC_SUFFIXES = linux linux-gnu unknown-linux-gnu
+		CROSS_COMPILE := $(call cc-cross-prefix, \
+			$(foreach a,$(CC_ARCHES), \
+			$(foreach s,$(CC_SUFFIXES),$(a)-$(s)-)))
+	endif
 endif
 
 OBJCOPY_FLAGS =-O binary -R .note -R .comment -S
-- 
1.7.10.4


