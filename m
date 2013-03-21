Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab3CUIY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:24:26 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:55636 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab3CUIXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:23:11 -0400
Subject: [PATCH RFC 3/5] kconfig: simplity linking cross-module glue objects
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Cochran <richardcochran@gmail.com>
Date: Thu, 21 Mar 2013 12:23:05 +0400
Message-ID: <20130321082305.21557.69305.stgit@zurg>
In-Reply-To: <20130321082256.21557.68351.stgit@zurg>
References: <20130321082256.21557.68351.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some synax sugar for makefiles to simplify conditional linking
cross-module glue objects into composite modules.

For example: there two tristate config options MODULE_A and MODULE_B.
Module-B wants to use some code from Module-A. Code of Module-A is available
from Module-B if MODULE_A=y or if MODULE_A=m and MODULE_B=m.

This patch allows to write this construction in makefile:

obj-$(CONFIG_MODULE_A) += module_a.o
obj-$(CONFIG_MODULE_B) += module_b.o
module_b-y += core_b.o
module_b-$(CONFIG_MODULE_A) += glue_a_b.o

After that glue_a_b will be linked into module_b.o iff module-A is available.
Objects from module_b-m will be linked only if CONFIG_MODULE_B=m.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
---
 Documentation/kbuild/makefiles.txt |   14 ++++++++++++++
 scripts/Makefile.build             |   16 ++++++++++++----
 scripts/Makefile.lib               |    8 ++++----
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 5198b74..dcdf424 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -224,6 +224,20 @@ more details, with real examples.
 	kbuild will build an ext2.o file for you out of the individual
 	parts and then link this into built-in.o, as you would expect.
 
+	Kbuild also includes objects listed in variable $(<module_name>-m)
+	if it builds composite objects as module (obj-m) and ignores them
+	for built-in modules (obj-y). This allows to implement flexible
+	dependence between two modules.
+
+	Example:
+		obj-$(CONFIG_MODULE_A) += module_a.o
+		obj-$(CONFIG_MODULE_B) += module_b.o
+		module_b-y += core_b.o
+		module_b-$(CONFIG_MODULE_A) += glue_a_b.o
+
+	In this example, glue_a_b.o will be used only if module_a is available
+	from module_b, this is true if CONFIG_MODULE_A=y or they both are =m.
+
 --- 3.4 Objects which export symbols
 
 	No special notation is required in the makefiles for
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 0e801c3..1c89dbf 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -421,16 +421,24 @@ endif
 #    <composite-object>-objs := <list of .o files>
 #  or
 #    <composite-object>-y    := <list of .o files>
-link_multi_deps =                     \
+#  or (for modules)
+#    <composite-object>-m    := <list of .o files>
+link_multi_deps-y =                   \
 $(filter $(addprefix $(obj)/,         \
 $($(subst $(obj)/,,$(@:.o=-objs)))    \
 $($(subst $(obj)/,,$(@:.o=-y)))), $^)
- 
+
+link_multi_deps-m =                   \
+$(filter $(addprefix $(obj)/,         \
+$($(subst $(obj)/,,$(@:.o=-objs)))    \
+$($(subst $(obj)/,,$(@:.o=-y)))       \
+$($(subst $(obj)/,,$(@:.o=-m)))), $^)
+
 quiet_cmd_link_multi-y = LD      $@
-cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps) $(cmd_secanalysis)
+cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps-y) $(cmd_secanalysis)
 
 quiet_cmd_link_multi-m = LD [M]  $@
-cmd_link_multi-m = $(cmd_link_multi-y)
+cmd_link_multi-m = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps-m) $(cmd_secanalysis)
 
 # We would rather have a list of rules like
 # 	foo.o: $(foo-objs)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 07125e6..b1ce3e4 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -48,14 +48,14 @@ subdir-ym	:= $(sort $(subdir-y) $(subdir-m))
 
 # if $(foo-objs) exists, foo.o is a composite object 
 multi-used-y := $(sort $(foreach m,$(obj-y), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))), $(m))))
-multi-used-m := $(sort $(foreach m,$(obj-m), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))), $(m))))
+multi-used-m := $(sort $(foreach m,$(obj-m), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y)) $($(m:.o=-m))), $(m))))
 multi-used   := $(multi-used-y) $(multi-used-m)
 single-used-m := $(sort $(filter-out $(multi-used-m),$(obj-m)))
 
 # Build list of the parts of our composite objects, our composite
 # objects depend on those (obviously)
 multi-objs-y := $(foreach m, $(multi-used-y), $($(m:.o=-objs)) $($(m:.o=-y)))
-multi-objs-m := $(foreach m, $(multi-used-m), $($(m:.o=-objs)) $($(m:.o=-y)))
+multi-objs-m := $(foreach m, $(multi-used-m), $($(m:.o=-objs)) $($(m:.o=-y)) $($(m:.o=-m)))
 multi-objs   := $(multi-objs-y) $(multi-objs-m)
 
 # $(subdir-obj-y) is the list of objects in $(obj-y) which uses dir/ to
@@ -67,7 +67,7 @@ obj-dirs := $(dir $(multi-objs) $(subdir-obj-y))
 
 # Replace multi-part objects by their individual parts, look at local dir only
 real-objs-y := $(foreach m, $(filter-out $(subdir-obj-y), $(obj-y)), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))),$($(m:.o=-objs)) $($(m:.o=-y)),$(m))) $(extra-y)
-real-objs-m := $(foreach m, $(obj-m), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))),$($(m:.o=-objs)) $($(m:.o=-y)),$(m)))
+real-objs-m := $(foreach m, $(obj-m), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y)) $($(m:.o=-m))),$($(m:.o=-objs)) $($(m:.o=-y)) $($(m:.o=-m)),$(m)))
 
 # Add subdir path
 
@@ -163,7 +163,7 @@ dtc_cpp_flags  = -Wp,-MD,$(depfile) -nostdinc                            \
 
 # Finds the multi-part object the current object will be linked into
 modname-multi = $(sort $(foreach m,$(multi-used),\
-		$(if $(filter $(subst $(obj)/,,$*.o), $($(m:.o=-objs)) $($(m:.o=-y))),$(m:.o=))))
+		$(if $(filter $(subst $(obj)/,,$*.o), $($(m:.o=-objs)) $($(m:.o=-y)) $($(m:.o=-m))),$(m:.o=))))
 
 ifdef REGENERATE_PARSERS
 

