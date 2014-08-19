Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaHSHev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:34:51 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:52689 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbaHSHet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:34:49 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] kbuild: handle the dependency of multi-objs hostprogs appropriately
Date: Tue, 19 Aug 2014 16:34:21 +0900
Message-Id: <1408433663-17435-3-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408433663-17435-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1408433663-17435-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assume we have a Makefile like:

hostprogs-y := foo bar
foo-objs := foo1.o foo2.o
bar-objs := bar1.o bar2.o

Without this commit, the host program foo depends on all of
foo1.o foo2.o bar1.o bar2.o.

This commit allows to handle the dependency of each host program
separately.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 scripts/Makefile.host | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index ab5980f..133edfa 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -96,8 +96,9 @@ quiet_cmd_host-cmulti	= HOSTLD  $@
       cmd_host-cmulti	= $(HOSTCC) $(HOSTLDFLAGS) -o $@ \
 			  $(addprefix $(obj)/,$($(@F)-objs)) \
 			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
-$(host-cmulti): $(obj)/%: $(host-cobjs) FORCE
+$(host-cmulti): FORCE
 	$(call if_changed,host-cmulti)
+$(call multi_depend, $(host-cmulti), , -objs)
 
 # Create .o file from a single .c file
 # host-cobjs -> .o
@@ -113,8 +114,9 @@ quiet_cmd_host-cxxmulti	= HOSTLD  $@
 			  $(foreach o,objs cxxobjs,\
 			  $(addprefix $(obj)/,$($(@F)-$(o)))) \
 			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
-$(host-cxxmulti): $(obj)/%: $(host-cobjs) $(host-cxxobjs) FORCE
+$(host-cxxmulti): FORCE
 	$(call if_changed,host-cxxmulti)
+$(call multi_depend, $(host-cxxmulti), , -objs -cxxobjs)
 
 # Create .o file from a single .cc (C++) file
 quiet_cmd_host-cxxobjs	= HOSTCXX $@
-- 
1.9.1

