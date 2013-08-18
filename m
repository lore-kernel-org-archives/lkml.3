Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab3HRUxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:53:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab3HRUdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 19/34] sparc32: add ucmpdi2
Date: Sun, 18 Aug 2013 13:34:32 -0700
Message-Id: <20130818203301.001916420@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Ravnborg <sam@ravnborg.org>

commit de36e66d5fa52bc6e2dacd95c701a1762b5308a7 upstream.

Based on copy from microblaze add ucmpdi2 implementation.
This fixes build of niu driver which failed with:

drivers/built-in.o: In function `niu_get_nfc':
niu.c:(.text+0x91494): undefined reference to `__ucmpdi2'

This driver will never be used on a sparc32 system,
but patch added to fix build breakage with all*config builds.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/lib/Makefile  |    2 +-
 arch/sparc/lib/ucmpdi2.c |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -15,7 +15,7 @@ lib-$(CONFIG_SPARC32) += divdi3.o udivdi
 lib-$(CONFIG_SPARC32) += copy_user.o locks.o
 lib-y                 += atomic_$(BITS).o
 lib-$(CONFIG_SPARC32) += lshrdi3.o ashldi3.o
-lib-$(CONFIG_SPARC32) += muldi3.o bitext.o cmpdi2.o
+lib-$(CONFIG_SPARC32) += muldi3.o bitext.o cmpdi2.o ucmpdi2.o
 
 lib-$(CONFIG_SPARC64) += copy_page.o clear_page.o bzero.o
 lib-$(CONFIG_SPARC64) += csum_copy.o csum_copy_from_user.o csum_copy_to_user.o
--- /dev/null
+++ b/arch/sparc/lib/ucmpdi2.c
@@ -0,0 +1,19 @@
+#include <linux/module.h>
+#include "libgcc.h"
+
+word_type __ucmpdi2(unsigned long long a, unsigned long long b)
+{
+	const DWunion au = {.ll = a};
+	const DWunion bu = {.ll = b};
+
+	if ((unsigned int) au.s.high < (unsigned int) bu.s.high)
+		return 0;
+	else if ((unsigned int) au.s.high > (unsigned int) bu.s.high)
+		return 2;
+	if ((unsigned int) au.s.low < (unsigned int) bu.s.low)
+		return 0;
+	else if ((unsigned int) au.s.low > (unsigned int) bu.s.low)
+		return 2;
+	return 1;
+}
+EXPORT_SYMBOL(__ucmpdi2);


