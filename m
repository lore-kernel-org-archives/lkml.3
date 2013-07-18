Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab3GRQlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:41:23 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:46721 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab3GRQlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:41:21 -0400
Date: Thu, 18 Jul 2013 18:41:16 +0200
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com
Subject: [PATCH] perf tools: Build docs with 'make all'
Message-ID: <20130718164116.GM8731@rric.localhost>
References: <1370964158-4135-1-git-send-email-rric@kernel.org>
 <tip-107de3724eff5a6fa6474a4d2aa5460b63749ebf@git.kernel.org>
 <20130712093909.GD8731@rric.localhost>
 <20130716145036.GH8731@rric.localhost>
 <20130717153118.GC2071@ghostprotocols.net>
 <20130717154001.GA4454@pd.tnic>
 <20130717161051.GJ8731@rric.localhost>
 <20130718121924.GL8731@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718121924.GL8731@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

On 18.07.13 14:19:24, Robert Richter wrote:
> No issues noticed, accept that doc is built when running the 'install'
> target, not 'all'.
> 
> Will look at this.

see patch below that fixes the above.

-Robert



>From 3bf424ea33526fefbce9f95d4ccfaffd36016a21 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@linaro.org>
Date: Thu, 18 Jul 2013 17:57:20 +0200
Subject: [PATCH] perf tools: Build docs with 'make all'

Build documentation with 'make all', not 'make install'. We use the
new target try-man for this which is similar implemented as
try-install-man. Thus, building the doc is skipped if tools for this
are missing.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 tools/perf/Documentation/Makefile | 6 ++++--
 tools/perf/Makefile               | 7 +++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index 5a37a7c..47df22d 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -182,6 +182,8 @@ ifdef missing_tools
 	$(error "You need to install $(missing_tools) for man pages")
 endif
 
+do-man: man
+
 do-install-man: man
 	$(INSTALL) -d -m 755 $(DESTDIR)$(man1dir)
 #	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
@@ -192,11 +194,11 @@ do-install-man: man
 
 install-man: check-man-tools man
 
-try-install-man:
+try-install-man try-man:
 ifdef missing_tools
 	$(warning Please install $(missing_tools) to have the man pages installed)
 else
-	$(MAKE) do-install-man
+	$(MAKE) $(patsubst try-%,do-%,$@)
 endif
 
 install-info: info
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1d718a9..8781de7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -522,7 +522,7 @@ export INSTALL SHELL_PATH
 
 SHELL = $(SHELL_PATH)
 
-all: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(OTHER_PROGRAMS)
+all: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(OTHER_PROGRAMS) try-man
 
 please_set_SHELL_PATH_to_a_more_modern_shell:
 	@$$(:)
@@ -710,9 +710,12 @@ endif
 
 DOC_TARGETS := doc man html info pdf
 
-INSTALL_DOC_TARGETS := $(patsubst %,install-%,$(DOC_TARGETS)) try-install-man
+INSTALL_DOC_TARGETS := $(patsubst %,install-%,$(DOC_TARGETS))
 INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
 
+DOC_TARGETS	    += try-man
+INSTALL_DOC_TARGETS += try-install-man
+
 # 'make doc' should call 'make -C Documentation all'
 $(DOC_TARGETS):
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) $(@:doc=all)
-- 
1.8.3.2

