Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaIAP0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:26:50 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51209 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaIAP0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:26:48 -0400
Message-ID: <54048FDA.7020904@gmail.com>
Date: Mon, 01 Sep 2014 23:25:14 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH] arch/microblaze/include/asm/uaccess.h: Use pr_devel()
 instead of pr_debug()
References: <53E10590.3070703@gmail.com>
In-Reply-To: <53E10590.3070703@gmail.com>
X-Forwarded-Message-Id: <53E10590.3070703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




-------- Original Message --------
Subject: [PATCH] arch/microblaze/include/asm/uaccess.h: Use pr_devel() instead of pr_debug()
Date: Wed, 06 Aug 2014 00:25:52 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
To: monstr@monstr.eu
CC: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>

When DYNAMIC_DEBUG enabled, pr_debug() depends on KBUILD_MODNAME which
also depends on the modules number in Makefile. The related information
in "scripts/Makefile.lib" line 94:

  # $(modname_flags) #defines KBUILD_MODNAME as the name of the module it will
  # end up in (or would, if it gets compiled in)
  # Note: Files that end up in two or more modules are compiled without the
  #       KBUILD_MODNAME definition. The reason is that any made-up name would
  #       differ in different configs.

For this case, 'radio-si470x-i2c.o' and 'radio-si470x-common.o' are in
one line, so cause compiling issue. And 'uaccess.h' is a common shared
header (not specially for drivers), so use pr_devel() instead of is OK.

The related error with allmodconfig:

    CC [M]  drivers/media/radio/si470x/radio-si470x-i2c.o
    CC [M]  drivers/media/radio/si470x/radio-si470x-common.o
  In file included from include/linux/printk.h:257:0,
                   from include/linux/kernel.h:13,
                   from drivers/media/radio/si470x/radio-si470x.h:29,
                   from drivers/media/radio/si470x/radio-si470x-common.c:115:
  ./arch/microblaze/include/asm/uaccess.h: In function 'access_ok':
  include/linux/dynamic_debug.h:66:14: error: 'KBUILD_MODNAME' undeclared (first use in this function)
     .modname = KBUILD_MODNAME,   \
                ^
  include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
    DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
    ^
  include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
    dynamic_pr_debug(fmt, ##__VA_ARGS__)
    ^
  ./arch/microblaze/include/asm/uaccess.h:101:3: note: in expansion of macro 'pr_debug'
     pr_debug("ACCESS fail: %s at 0x%08x (size 0x%x), seg 0x%08x\n",
     ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/microblaze/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index 0aa0057..59a89a6 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -98,13 +98,13 @@ static inline int access_ok(int type, const void __user *addr,	
 
 	if ((get_fs().seg < ((unsigned long)addr)) ||
 			(get_fs().seg < ((unsigned long)addr + size - 1))) {
-		pr_debug("ACCESS fail: %s at 0x%08x (size 0x%x), seg 0x%08x\n",
+		pr_devel("ACCESS fail: %s at 0x%08x (size 0x%x), seg 0x%08x\n",
 			type ? "WRITE" : "READ ", (__force u32)addr, (u32)size,
 			(u32)get_fs().seg);
 		return 0;
 	}
 ok:
-	pr_debug("ACCESS OK: %s at 0x%08x (size 0x%x), seg 0x%08x\n",
+	pr_devel("ACCESS OK: %s at 0x%08x (size 0x%x), seg 0x%08x\n",
 			type ? "WRITE" : "READ ", (__force u32)addr, (u32)size,
 			(u32)get_fs().seg);
 	return 1;
-- 
1.7.11.7


