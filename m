Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3BKMd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:33:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60533 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab3BKMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:33:57 -0500
Date: Mon, 11 Feb 2013 04:33:43 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-c2823ae46fb1641cc691c3dcc0eeb4356fce267a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1360456781-32462-11-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-11-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Add the 'lockdep'
  user-space utility
Git-Commit-ID: c2823ae46fb1641cc691c3dcc0eeb4356fce267a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:33:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2823ae46fb1641cc691c3dcc0eeb4356fce267a
Gitweb:     http://git.kernel.org/tip/c2823ae46fb1641cc691c3dcc0eeb4356fce267a
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sat, 9 Feb 2013 19:39:41 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:12:41 +0100

liblockdep: Add the 'lockdep' user-space utility

This is a simple wrapper to make using liblockdep on existing
applications much easier.

After running 'make && make install', it becomes quite simple to
test things with liblockdep. For example, to try it on perf:

	lockdep perf

No other integration required.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: jamie.iles@oracle.com
Cc: penberg@kernel.org
Cc: acme@ghostprotocols.net
Cc: paulus@samba.org
Cc: namhyung@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1360456781-32462-11-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/Makefile | 12 ++++++++----
 tools/lib/lockdep/lockdep  |  3 +++
 2 files changed, 11 insertions(+), 4 deletions(-)

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
