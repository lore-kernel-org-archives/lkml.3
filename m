Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3EQVi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:38:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3EQViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>, Jeroen Roovers <jer@gentoo.org>,
        John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [ 100/102] parisc: make default cross compiler search more robust (v3)
Date: Fri, 17 May 2013 14:36:55 -0700
Message-Id: <20130517213254.783306218@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 6880b0150a7c25fd75c5ece80abc49ebf53c38c1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/Makefile |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -23,24 +23,21 @@ NM		= sh $(srctree)/arch/parisc/nm
 CHECKFLAGS	+= -D__hppa__=1
 LIBGCC		= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
-MACHINE		:= $(shell uname -m)
-NATIVE		:= $(if $(filter parisc%,$(MACHINE)),1,0)
-
 ifdef CONFIG_64BIT
 UTS_MACHINE	:= parisc64
 CHECKFLAGS	+= -D__LP64__=1 -m64
-WIDTH		:= 64
+CC_ARCHES	= hppa64
 else # 32-bit
-WIDTH		:=
+CC_ARCHES	= hppa hppa2.0 hppa1.1
 endif
 
-# attempt to help out folks who are cross-compiling
-ifeq ($(NATIVE),1)
-CROSS_COMPILE	:= hppa$(WIDTH)-linux-
-else
- ifeq ($(CROSS_COMPILE),)
- CROSS_COMPILE	:= hppa$(WIDTH)-linux-gnu-
- endif
+ifneq ($(SUBARCH),$(UTS_MACHINE))
+	ifeq ($(CROSS_COMPILE),)
+		CC_SUFFIXES = linux linux-gnu unknown-linux-gnu
+		CROSS_COMPILE := $(call cc-cross-prefix, \
+			$(foreach a,$(CC_ARCHES), \
+			$(foreach s,$(CC_SUFFIXES),$(a)-$(s)-)))
+	endif
 endif
 
 OBJCOPY_FLAGS =-O binary -R .note -R .comment -S


