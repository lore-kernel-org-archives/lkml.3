Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaGLUZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:25:05 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:37173 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaGLUZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:25:00 -0400
Subject: [PATCH v2] lib/Kconfig.debug: introduce CONFIG_CC_STACK_USAGE
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Sun, 13 Jul 2014 00:24:50 +0400
Message-ID: <20140712202449.16082.46103.stgit@zurg>
In-Reply-To: <20140712200136.15788.17192.stgit@zurg>
References: <20140712200136.15788.17192.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds option for collecting stack usage statistics
via gcc option '-fstack-usage' (needs gcc 4.6 or newer).
For each .o file gcc dumps stack-frame sizes into .su file.

File format:
<file>:<line>:<column>:<function>	<size>	<qualifiers>

select.c:870:5:do_sys_poll	1040	static
rtnetlink.c:1880:12:rtnl_newlink        552     dynamic
random.c:1334:1:random_read	664     dynamic,bounded

Quote from the gcc manpage about qualifiers:

    The qualifier "static" means that the function
    manipulates the stack statically: a fixed number of bytes
    are allocated for the frame on function entry and
    released on function exit; no stack adjustments are
    otherwise made in the function.  The second field is this
    fixed number of bytes.

    The qualifier "dynamic" means that the function
    manipulates the stack dynamically: in addition to the
    static allocation described above, stack adjustments are
    made in the body of the function, for example to push/pop
    arguments around function calls.  If the qualifier
    "bounded" is also present, the amount of these
    adjustments is bounded at compile time and the second
    field is an upper bound of the total amount of stack used
    by the function.  If it is not present, the amount of
    these adjustments is not bounded at compile time and the
    second field only represents the bounded part.

In comparison to the scripts/checkstack.pl this method is more accurate.
It takes into account function arguments, push/pop pairs, frame
pointers and saved return address. It gives information about all
functions except purely assember (for example sha1_transform_avx2).

Also this patch adds make target 'stack-usage' which combines all .su
files into one sorted 'stack-usage'. Also prints top 100 and all unbounded
dynamic stack frames.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 .gitignore        |    3 +++
 Makefile          |   23 ++++++++++++++++++++++-
 lib/Kconfig.debug |    9 +++++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index f4c0b09..96b8984 100644
--- a/.gitignore
+++ b/.gitignore
@@ -85,6 +85,9 @@ GTAGS
 *~
 \#*#
 
+*.su
+/stack-usage
+
 #
 # Leavings from module signing
 #
diff --git a/Makefile b/Makefile
index 2167084..29fe588 100644
--- a/Makefile
+++ b/Makefile
@@ -635,6 +635,11 @@ ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
 
+ifdef CONFIG_CC_STACK_USAGE
+KBUILD_CFLAGS += $(call cc-option,-fstack-usage)
+endif
+CLEAN_FILES += stack-usage
+
 # Handle stack protector mode.
 ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
@@ -1228,6 +1233,7 @@ help:
 	 echo  ''
 	@echo  'Static analysers'
 	@echo  '  checkstack      - Generate a list of stack hogs'
+	@echo  '  stack-usage     - Alternative list of stack hogs'
 	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
 	@echo  '  versioncheck    - Sanity check on version.h usage'
 	@echo  '  includecheck    - Check for duplicate included header files'
@@ -1376,7 +1382,7 @@ clean: $(clean-dirs)
 	$(call cmd,rmfiles)
 	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
-		-o -name '*.ko.*' \
+		-o -name '*.ko.*' -o -name '*.su' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
 		-o -name modules.builtin -o -name '.tmp_*.o.*' \
@@ -1432,6 +1438,21 @@ checkstack:
 	$(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
 	$(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
 
+quiet_cmd_cc_stack_usage = SORTING $@
+cmd_cc_stack_usage = find -name '*.su' | xargs cat | sort -k 2 -n -r > $@
+
+stack-usage: FORCE
+ifndef CONFIG_CC_STACK_USAGE
+	$(Q)echo >&2 'Please rebuild with CONFIG_CC_STACK_USAGE=y' && false
+endif
+	$(call cmd,cc_stack_usage)
+	$(Q)echo ''
+	$(Q)echo 'Unbounded dynamic stack frames:'
+	$(Q)grep '\bdynamic$$' $@ || true
+	$(Q)echo ''
+	$(Q)echo 'Top 100 stack frames:'
+	$(Q)head -100 < $@
+
 kernelrelease:
 	@echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7a638aa..3b30853 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -170,6 +170,15 @@ config FRAME_WARN
 	  Setting it to 0 disables the warning.
 	  Requires gcc 4.4
 
+config CC_STACK_USAGE
+	bool "Collect statistics about stack usage (needs gcc 4.6)"
+	help
+	  This enables gcc option -fstack-usage which saves information
+	  about stack frames in per-function basis into '.su' files.
+
+	  Run 'make stack-usage' after building kernel and modules to
+	  combine all information in one file.
+
 config STRIP_ASM_SYMS
 	bool "Strip assembler-generated symbols during link"
 	default n

