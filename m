Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078Ab3FXTbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:31:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:47165 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FXTbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 01/32] init.h: remove __cpuinit sections from the kernel
Date: Mon, 24 Jun 2013 15:30:06 -0400
Message-ID: <1372102237-8757-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

As an interim step, we can dummy out the macros to be no-ops, and
this will allow us to avoid a giant tree-wide patch, and instead
we can feed in smaller chunks mainly via the arch/ trees.  This
is in keeping with commit 78d86c213f28193082b5d8a1a424044b7ba406f1
("init.h: Remove __dev* sections from the kernel")

We don't strictly need to dummy out the macros to do this, but if
we don't then some harmless section mismatch warnings may temporarily
result.  For example, notify_cpu_starting() and cpu_up() are arch
independent (kernel/cpu.c) and are flagged as __cpuinit.  And hence
the calling functions in the arch specific code are also expected
to be __cpuinit -- if not, then we get the section mismatch warning.

Two of the three __CPUINIT variants are not used whatsoever, and
so they are simply removed directly at this point in time.

[1] https://lkml.org/lkml/2013/5/20/589

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 include/linux/init.h | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 8618147..e73f2b7 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -93,13 +93,13 @@
 
 #define __exit          __section(.exit.text) __exitused __cold notrace
 
-/* Used for HOTPLUG_CPU */
-#define __cpuinit        __section(.cpuinit.text) __cold notrace
-#define __cpuinitdata    __section(.cpuinit.data)
-#define __cpuinitconst   __constsection(.cpuinit.rodata)
-#define __cpuexit        __section(.cpuexit.text) __exitused __cold notrace
-#define __cpuexitdata    __section(.cpuexit.data)
-#define __cpuexitconst   __constsection(.cpuexit.rodata)
+/* temporary, until all users are removed */
+#define __cpuinit
+#define __cpuinitdata
+#define __cpuinitconst
+#define __cpuexit
+#define __cpuexitdata
+#define __cpuexitconst
 
 /* Used for MEMORY_HOTPLUG */
 #define __meminit        __section(.meminit.text) __cold notrace
@@ -118,9 +118,8 @@
 #define __INITRODATA	.section	".init.rodata","a",%progbits
 #define __FINITDATA	.previous
 
-#define __CPUINIT        .section	".cpuinit.text", "ax"
-#define __CPUINITDATA    .section	".cpuinit.data", "aw"
-#define __CPUINITRODATA  .section	".cpuinit.rodata", "a"
+/* temporary, until all users are removed */
+#define __CPUINIT
 
 #define __MEMINIT        .section	".meminit.text", "ax"
 #define __MEMINITDATA    .section	".meminit.data", "aw"
-- 
1.8.1.2

