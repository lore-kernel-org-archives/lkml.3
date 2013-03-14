Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3CNWBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:01:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3CNWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:01:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Turn off -Wmaybe-uninitialized when building with -Os
Date: Thu, 14 Mar 2013 23:01:35 +0100
Message-ID: <7534695.eTHcH0enMV@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-7-generic; KDE/4.10.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qeUzYebeZl3+ZdfT2hbVrJpRC5jE7DSvr/5viXSw66J
 LeTlsCLCKdZvbt7RGOeNrug+QFC/eKXETkA+C9XlLhNiST19wT
 epF5jN/013fQF98Qz1VBbMnmRoJnJeobGgQtEiErijavozLhBh
 hHm4nXVheKgZnnt+iFLbtjJ9cm/TfOPIWuhrYg2OxzH3xVOJZi
 fw2EyDF24xp+Lq1CQRRgZjjdxcfL8ZRAOC7KyNiD2O/W89YUWr
 f4gJVua/k8cHQOdseYUNpDdppzOBDQ0fLMCTME+fw6PXOAKcxu
 w3Cgq6OU/sDlDGNOn/UbtNGvUQGHwfR0X7UGncPJ/YbcRqYyAz
 CHoilSpQDGVShJMKZqL8=
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
Cc: stable@vger.kernel.org
--
I'd like to merge this for 3.9 and also for the stable kernels,
if people agree this is a good idea.

diff --git a/Makefile b/Makefile
index 10fb6c7..caea2d1 100644
--- a/Makefile
+++ b/Makefile
@@ -570,7 +570,7 @@ endif # $(dot-config)
 all: vmlinux
 
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
-KBUILD_CFLAGS	+= -Os
+KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
 else
 KBUILD_CFLAGS	+= -O2
 endif

