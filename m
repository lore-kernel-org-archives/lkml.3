Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3CDUg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:36:27 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:41236 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab3CDUg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:36:26 -0500
Date: Mon, 4 Mar 2013 21:36:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Howells <dhowells@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, davej@redhat.com
Subject: [PATCH - Regression] kbuild: fix make headers_check with make 3.80
Message-ID: <20130304203624.GA10846@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 10b63956 ("UAPI: Plumb the UAPI Kbuilds into the user header
installation and checking") introduced a dependency of make 3.81
due to use of $(or ...)

We do not want to lift the requirement to gmake 3.81 just yet...
Included are a straightforward conversion to $(if ...)

Bisected-and-tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 25f216a..477d137 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -14,7 +14,7 @@ kbuild-file := $(srctree)/$(obj)/Kbuild
 include $(kbuild-file)
 
 # called may set destination dir (when installing to asm/)
-_dst := $(or $(destination-y),$(dst),$(obj))
+_dst := $(if $(destination-y),$(destination-y),$(if $(dst),$(dst),$(obj)))
 
 old-kbuild-file := $(srctree)/$(subst uapi/,,$(obj))/Kbuild
 ifneq ($(wildcard $(old-kbuild-file)),)
@@ -48,13 +48,14 @@ all-files     := $(header-y) $(genhdr-y) $(wrapper-files)
 output-files  := $(addprefix $(installdir)/, $(all-files))
 
 input-files   := $(foreach hdr, $(header-y), \
-		   $(or \
+		   $(if $(wildcard $(srcdir)/$(hdr)), \
 			$(wildcard $(srcdir)/$(hdr)), \
-			$(wildcard $(oldsrcdir)/$(hdr)), \
-			$(error Missing UAPI file $(srcdir)/$(hdr)) \
+			$(if $(wildcard $(oldsrcdir)/$(hdr)), \
+				$(wildcard $(oldsrcdir)/$(hdr)), \
+				$(error Missing UAPI file $(srcdir)/$(hdr))) \
 		   )) \
 		 $(foreach hdr, $(genhdr-y), \
-		   $(or \
+		   $(if	$(wildcard $(gendir)/$(hdr)), \
 			$(wildcard $(gendir)/$(hdr)), \
 			$(error Missing generated UAPI file $(gendir)/$(hdr)) \
 		   ))
