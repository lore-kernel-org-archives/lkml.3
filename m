Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaHGT45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:56:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaHGT44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:56:56 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Konstantin Khlebnikov <koct9i@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Fix handling of backslashes in *.cmd files
Date: Thu,  7 Aug 2014 21:56:24 +0200
Message-Id: <1407441384-31614-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <20140807170800.GA1542@ravnborg.org>
References: <20140807170800.GA1542@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c353acba ("kbuild: make: fix if_changed when command contains
backslashes") attempted to handle backslashes in *.cmd files, but it
only handled double backslashes for some reason. Changing make-cmd to also
handle single backslashes fixes rebuilds with dash, but it breaks bash
again. The reason is that the two shells disagree about the
interpretation of backslash sequences in the echo builtin. The way out
of this is to print the command with printf '%s\n'. While at it,
document what the individual parts of make-cmd do and why.

Reported-and-tested-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/Kbuild.include | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 122f95c..8a9a4e1 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -215,11 +215,13 @@ else
 arg-check = $(if $(strip $(cmd_$@)),,1)
 endif
 
-# >'< substitution is for echo to work,
-# >$< substitution to preserve $ when reloading .cmd file
-# note: when using inline perl scripts [perl -e '...$$t=1;...']
-# in $(cmd_xxx) double $$ your perl vars
-make-cmd = $(subst \\,\\\\,$(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1))))))
+# Replace >$< with >$$< to preserve $ when reloading the .cmd file
+# (needed for make)
+# Replace >#< with >\#< to avoid starting a comment in the .cmd file
+# (needed for make)
+# Replace >'< with >'\''< to be able to enclose the whole string in '...'
+# (needed for the shell)
+make-cmd = $(call escsq,$(subst \#,\\\#,$(subst $$,$$$$,$(cmd_$(1)))))
 
 # Find any prerequisites that is newer than target or that does not exist.
 # PHONY targets skipped in both cases.
@@ -230,7 +232,7 @@ any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
 if_changed = $(if $(strip $(any-prereq) $(arg-check)),                       \
 	@set -e;                                                             \
 	$(echo-cmd) $(cmd_$(1));                                             \
-	echo 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
+	printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
 
 # Execute the command and also postprocess generated .d dependencies file.
 if_changed_dep = $(if $(strip $(any-prereq) $(arg-check) ),                  \
-- 
1.8.4.5

