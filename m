Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942Ab3BJAmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 19:42:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45262 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760886Ab3BJAkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 19:40:08 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 11/11] liblockdep: preload helper
Date: Sat,  9 Feb 2013 19:39:41 -0500
Message-Id: <1360456781-32462-11-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple wrapper to make using liblockdep on existing applications
much easier.

After running 'make && make install', it becomes quite simple to test things
with liblockdep. For example, to try it on perf:

	lockdep perf

No other integration required.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/Makefile | 12 ++++++++----
 tools/lib/lockdep/lockdep  |  3 +++
 2 files changed, 11 insertions(+), 4 deletions(-)
 create mode 100755 tools/lib/lockdep/lockdep

diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index 245f8ba..b22122f 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -34,7 +34,9 @@ DESTDIR ?=
 DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
 
 prefix ?= /usr/local
-bindir_relative = lib
+libdir_relative = lib
+libdir = $(prefix)/$(libdir_relative)
+bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
 
 export DESTDIR DESTDIR_SQ INSTALL
@@ -90,13 +92,14 @@ objtree		:= $(CURDIR)
 src		:= $(srctree)
 obj		:= $(objtree)
 
-export prefix bindir src obj
+export prefix libdir bindir src obj
 
 # Shell quotes
+libdir_SQ = $(subst ','\'',$(libdir))
 bindir_SQ = $(subst ','\'',$(bindir))
-bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
 
 LIB_FILE = liblockdep.a liblockdep.so
+BIN_FILE = lockdep
 
 CONFIG_INCLUDES =
 CONFIG_LIBS	=
@@ -229,7 +232,8 @@ define do_install
 endef
 
 install_lib: all_cmd
-	$(Q)$(call do_install,$(LIB_FILE),$(bindir_SQ))
+	$(Q)$(call do_install,$(LIB_FILE),$(libdir_SQ))
+	$(Q)$(call do_install,$(BIN_FILE),$(bindir_SQ))
 
 install: install_lib
 
diff --git a/tools/lib/lockdep/lockdep b/tools/lib/lockdep/lockdep
new file mode 100755
index 0000000..a805c81
--- /dev/null
+++ b/tools/lib/lockdep/lockdep
@@ -0,0 +1,3 @@
+#! /bin/bash
+
+LD_PRELOAD="liblockdep.so $LD_PRELOAD" "$@"
-- 
1.8.1.2

