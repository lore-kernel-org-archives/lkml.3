Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaHSHet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:34:49 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:42627 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbaHSHer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:34:47 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] kbuild: handle multi-objs dependency appropriately
Date: Tue, 19 Aug 2014 16:34:20 +0900
Message-Id: <1408433663-17435-2-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408433663-17435-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1408433663-17435-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment in scripts/Makefile.build says as follows:

  We would rather have a list of rules like
        foo.o: $(foo-objs)
  but that's not so easy, so we rather make all composite objects depend
  on the set of all their parts

This commit makes it possible!

For example, assume a Makefile like this

  obj-m = foo.o bar.o
  foo-objs := foo1.o foo2.o
  bar-objs := bar1.o bar2.o

Without this patch, foo.o depends on all of
foo1.o foo2.o bar1.o bar2.o.
It looks funny that foo.o is regenerated when bar1.c is updated.

Now we can handle the dependency of foo.o and bar.o separately.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 scripts/Makefile.build | 10 ++++------
 scripts/Makefile.lib   |  9 +++++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index bf3e677..5b09d36 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -382,16 +382,14 @@ cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps) $(cmd_secanalys
 quiet_cmd_link_multi-m = LD [M]  $@
 cmd_link_multi-m = $(cmd_link_multi-y)
 
-# We would rather have a list of rules like
-# 	foo.o: $(foo-objs)
-# but that's not so easy, so we rather make all composite objects depend
-# on the set of all their parts
-$(multi-used-y) : %.o: $(multi-objs-y) FORCE
+$(multi-used-y): FORCE
 	$(call if_changed,link_multi-y)
+$(call multi_depend, $(multi-used-y), .o, -objs -y)
 
-$(multi-used-m) : %.o: $(multi-objs-m) FORCE
+$(multi-used-m): FORCE
 	$(call if_changed,link_multi-m)
 	@{ echo $(@:.o=.ko); echo $(link_multi_deps); } > $(MODVERDIR)/$(@F:.o=.mod)
+$(call multi_depend, $(multi-used-m), .o, -objs -y)
 
 targets += $(multi-used-y) $(multi-used-m)
 
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 260bf8a..54be19a 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -159,6 +159,15 @@ dtc_cpp_flags  = -Wp,-MD,$(depfile).pre.tmp -nostdinc                    \
 modname-multi = $(sort $(foreach m,$(multi-used),\
 		$(if $(filter $(subst $(obj)/,,$*.o), $($(m:.o=-objs)) $($(m:.o=-y))),$(m:.o=))))
 
+# Useful for describing the dependency of composite objects
+# Usage:
+#   $(call multi_depend, multi_used_targets, suffix_to_remove, suffix_to_add)
+define multi_depend
+$(foreach m, $(notdir $1), \
+	$(eval $(obj)/$m: \
+	$(addprefix $(obj)/, $(foreach s, $3, $($(m:%$(strip $2)=%$(s)))))))
+endef
+
 ifdef REGENERATE_PARSERS
 
 # GPERF
-- 
1.9.1

