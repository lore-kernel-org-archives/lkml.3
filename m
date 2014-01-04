Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaADWFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 17:05:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaADWE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 17:04:59 -0500
Date: Sat, 4 Jan 2014 14:04:19 -0800
From: tip-bot for David Woodhouse <tipbot@zytor.com>
Message-ID: <tip-e24df921af484e9b7095ee06d236dabdb3bd9c1c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
In-Reply-To: <1388788242.2391.75.camel@shinybook.infradead.org>
References: <1388788242.2391.75.camel@shinybook.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, boot: Use .code16 instead of .code16gcc
Git-Commit-ID: e24df921af484e9b7095ee06d236dabdb3bd9c1c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 04 Jan 2014 14:04:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e24df921af484e9b7095ee06d236dabdb3bd9c1c
Gitweb:     http://git.kernel.org/tip/e24df921af484e9b7095ee06d236dabdb3bd9c1c
Author:     David Woodhouse <dwmw2@infradead.org>
AuthorDate: Fri, 3 Jan 2014 22:30:42 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 4 Jan 2014 13:59:06 -0800

x86, boot: Use .code16 instead of .code16gcc

This reverts commit 28b48688 ("x86, boot: use .code16gcc instead
of .code16").

Versions of binutils older than 2.16 are already not working, so this
workaround is no longer necessary either.  At the same time, some of
the transformations that .code16gcc does can be *extremely*
counterintuitive to a human programmer.

[ hpa: folded ret -> retl and call -> calll fixes from followup patch ]

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1388788242.2391.75.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/bioscall.S |  2 +-
 arch/x86/boot/copy.S     | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/boot/bioscall.S b/arch/x86/boot/bioscall.S
index 1dfbf64..5077937 100644
--- a/arch/x86/boot/bioscall.S
+++ b/arch/x86/boot/bioscall.S
@@ -13,7 +13,7 @@
  * touching registers they shouldn't be.
  */
 
-	.code16gcc
+	.code16
 	.text
 	.globl	intcall
 	.type	intcall, @function
diff --git a/arch/x86/boot/copy.S b/arch/x86/boot/copy.S
index 11f272c..1eb7d29 100644
--- a/arch/x86/boot/copy.S
+++ b/arch/x86/boot/copy.S
@@ -14,7 +14,7 @@
  * Memory copy routines
  */
 
-	.code16gcc
+	.code16
 	.text
 
 GLOBAL(memcpy)
@@ -30,7 +30,7 @@ GLOBAL(memcpy)
 	rep; movsb
 	popw	%di
 	popw	%si
-	ret
+	retl
 ENDPROC(memcpy)
 
 GLOBAL(memset)
@@ -45,25 +45,25 @@ GLOBAL(memset)
 	andw	$3, %cx
 	rep; stosb
 	popw	%di
-	ret
+	retl
 ENDPROC(memset)
 
 GLOBAL(copy_from_fs)
 	pushw	%ds
 	pushw	%fs
 	popw	%ds
-	call	memcpy
+	calll	memcpy
 	popw	%ds
-	ret
+	retl
 ENDPROC(copy_from_fs)
 
 GLOBAL(copy_to_fs)
 	pushw	%es
 	pushw	%fs
 	popw	%es
-	call	memcpy
+	calll	memcpy
 	popw	%es
-	ret
+	retl
 ENDPROC(copy_to_fs)
 
 #if 0 /* Not currently used, but can be enabled as needed */
@@ -71,17 +71,17 @@ GLOBAL(copy_from_gs)
 	pushw	%ds
 	pushw	%gs
 	popw	%ds
-	call	memcpy
+	calll	memcpy
 	popw	%ds
-	ret
+	retl
 ENDPROC(copy_from_gs)
 
 GLOBAL(copy_to_gs)
 	pushw	%es
 	pushw	%gs
 	popw	%es
-	call	memcpy
+	calll	memcpy
 	popw	%es
-	ret
+	retl
 ENDPROC(copy_to_gs)
 #endif
