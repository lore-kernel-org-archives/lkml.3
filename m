Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3F3IC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 04:02:58 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46939 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3F3ICy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 04:02:54 -0400
From: =?UTF-8?q?=E5=BC=A0=E5=BF=A0=E5=B1=B1?= <zzs0213@gmail.com>
To: <mmarek@suse.cz>
Cc: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?=E5=BC=A0=E5=BF=A0=E5=B1=B1?= <zzs0213@gmail.com>
Subject: [PATCH] let kbuild mkdir for dir/file.o
Date: Sun, 30 Jun 2013 16:01:09 +0800
Message-Id: <1372579269-6642-1-git-send-email-zzs0213@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <51CE11C2.5020406@suse.cz>
References: <51CE11C2.5020406@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When add a obj with dir to obj-y, like this

    obj-y += dir/file.o

The $(obj)/dir not created, this patch fix this.

When try to add a file(which in a subdir) to my board's obj-y, the build
progress crashed.

For example, I use at91rm9200ek board, and in kernel dir run:

  mkdir objtree
  make O=objtree at91rm9200-defconfig
  mkdir arch/arm/mach-at91/dir
  touch arch/arm/mach-at91/dir/file.c

and edit arch/arm/mach-at91/dir/file.c to add some code.
then edit arch/arm/mach-at91/Makefile, change the following line:

  obj-$(CONFIG_MACH_AT91RM9200EK) += board-rm9200ek.o

to:

  obj-$(CONFIG_MACH_AT91RM9200EK) += board-rm9200ek.o dir/file.o

Now build it:

  make O=objtree

Then the error appears:
  ...
  CC      arch/arm/mach-at91/board-rm9200dk.o
  CC      arch/arm/mach-at91/board-rm9200ek.o
  CC      arch/arm/mach-at91/dir/file.o
  linux-2.6/arch/arm/mach-at91/dir/file.c:5:
    fatal error: opening dependency file
    arch/arm/mach-at91/dir/.file.o.d: No such file or directory

Check the objtree:
  LANG=en ls objtree/arch/arm/mach-at91/dir
  ls: cannot access objtree/arch/arm/mach-at91/dir: No such file or directory

It's apparently that the target dir not created for file.o

Check kbuild source code. It seems that kbuild create dirs for that in
$(obj-dirs).  But if the dir need not to create a built-in.o, It should
never in  $(obj-dirs).

So I make this patch to make sure It in  $(obj-dirs)

this bug caused by commit
   f5fb976520a53f45f8bbf2e851f16b3b5558d485

Signed-off-by: 张忠山 <zzs0213@gmail.com>
---
 scripts/Makefile.lib |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 51bb3de..6bae5a9 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -63,7 +63,8 @@ multi-objs   := $(multi-objs-y) $(multi-objs-m)
 subdir-obj-y := $(filter %/built-in.o, $(obj-y))
 
 # $(obj-dirs) is a list of directories that contain object files
-obj-dirs := $(dir $(multi-objs) $(subdir-obj-y))
+__subdir-obj-y := $(foreach o,$(obj-y),$(if $(filter-out $(o),$(notdir $(o))),$(o)))
+obj-dirs := $(dir $(multi-objs) $(__subdir-obj-y))
 
 # Replace multi-part objects by their individual parts, look at local dir only
 real-objs-y := $(foreach m, $(filter-out $(subdir-obj-y), $(obj-y)), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))),$($(m:.o=-objs)) $($(m:.o=-y)),$(m))) $(extra-y)
-- 
1.7.9.5

