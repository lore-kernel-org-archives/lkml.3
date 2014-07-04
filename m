Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaGDMiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:38:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaGDMiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:38:50 -0400
Date: Fri, 4 Jul 2014 14:38:47 +0200
From: Michal Marek <mmarek@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH] Fix compiler message generation
Message-ID: <20140704123847.GA3513@sepie.suse.cz>
References: <20140702124016.GA26965@sepie.suse.cz>
 <20140702105645.17220.92338.stgit@warthog.procyon.org.uk>
 <2690.1404308050@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2690.1404308050@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 02:34:10PM +0100, David Howells wrote:
> Michal Marek <mmarek@suse.cz> wrote:
> 
> > From 5b59dcacf358f143b9fb39d2f788142ab9ba3e00 Mon Sep 17 00:00:00 2001
> > From: Michal Marek <mmarek@suse.cz>
> > Date: Wed, 2 Jul 2014 14:28:26 +0200
> > Subject: [PATCH] kbuild: Print the name of the build directory
> > 
> > With commit 9da0763b (kbuild: Use relative path when building in a
> > subdir of the source tree), the compiler messages include relative
> > paths. These are however relative to the build directory, not the
> > directory where make was started. Print the "Entering directory ..."
> > message once, so that IDEs/editors can find the source files.
> > 
> > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > ---
> >  Makefile | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/Makefile b/Makefile
> > index 97b2861..40544a0 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -126,7 +126,10 @@ PHONY += $(MAKECMDGOALS) sub-make
> >  $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
> >  	@:
> >  
> > +# Fake the "Entering directory" message once, so that IDEs/editors are
> > +# able to understand relative filenames.
> >  sub-make: FORCE
> > +	@echo "make[1]: Entering directory \`$(KBUILD_OUTPUT)'"
> >  	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
> >  	KBUILD_SRC=$(CURDIR) \
> >  	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
> 
> Works for me with emacs.
> 
> Acked-by: David Howells <dhowells@redhat.com>

I found a regression today... after I had sent a pull request to Linus
yesterday :-/. The message is also printed by 'make -s', which is not
what the user expects from a silent mode. The following patch fixes it:


>From 066b7ed9558087a7957a1128f27d7a3462ff117f Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Fri, 4 Jul 2014 14:29:30 +0200
Subject: [PATCH] kbuild: Do not print the build directory with make -s

Commit c2e28dc9 (kbuild: Print the name of the build directory) prints
the name of the build directory for O= builds, but we should not be
doing this in make -s mode, so that commands like

  make -s O=<dir> kernelrelease

can be used by scripts. This matches the behavior of make itself, where
the -s option implies --no-print-directory.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 97 +++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 50 insertions(+), 47 deletions(-)

diff --git a/Makefile b/Makefile
index 40544a0..1a5f9f3 100644
--- a/Makefile
+++ b/Makefile
@@ -41,6 +41,29 @@ unexport GREP_OPTIONS
 # descending is started. They are now explicitly listed as the
 # prepare rule.
 
+# Beautify output
+# ---------------------------------------------------------------------------
+#
+# Normally, we echo the whole command before executing it. By making
+# that echo $($(quiet)$(cmd)), we now have the possibility to set
+# $(quiet) to choose other forms of output instead, e.g.
+#
+#         quiet_cmd_cc_o_c = Compiling $(RELDIR)/$@
+#         cmd_cc_o_c       = $(CC) $(c_flags) -c -o $@ $<
+#
+# If $(quiet) is empty, the whole command will be printed.
+# If it is set to "quiet_", only the short version will be printed.
+# If it is set to "silent_", nothing will be printed at all, since
+# the variable $(silent_cmd_cc_o_c) doesn't exist.
+#
+# A simple variant is to prefix commands with $(Q) - that's useful
+# for commands that shall be hidden in non-verbose mode.
+#
+#	$(Q)ln $@ :<
+#
+# If KBUILD_VERBOSE equals 0 then the above command will be hidden.
+# If KBUILD_VERBOSE equals 1 then the above command is displayed.
+#
 # To put more focus on warnings, be less verbose as default
 # Use 'make V=1' to see the full commands
 
@@ -51,6 +74,29 @@ ifndef KBUILD_VERBOSE
   KBUILD_VERBOSE = 0
 endif
 
+ifeq ($(KBUILD_VERBOSE),1)
+  quiet =
+  Q =
+else
+  quiet=quiet_
+  Q = @
+endif
+
+# If the user is running make -s (silent mode), suppress echoing of
+# commands
+
+ifneq ($(filter 4.%,$(MAKE_VERSION)),)	# make-4
+ifneq ($(filter %s ,$(firstword x$(MAKEFLAGS))),)
+  quiet=silent_
+endif
+else					# make-3.8x
+ifneq ($(filter s% -s%,$(MAKEFLAGS)),)
+  quiet=silent_
+endif
+endif
+
+export quiet Q KBUILD_VERBOSE
+
 # Call a source code checker (by default, "sparse") as part of the
 # C compilation.
 #
@@ -128,8 +174,11 @@ $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
 
 # Fake the "Entering directory" message once, so that IDEs/editors are
 # able to understand relative filenames.
+       echodir := @echo
+ quiet_echodir := @echo
+silent_echodir := @:
 sub-make: FORCE
-	@echo "make[1]: Entering directory \`$(KBUILD_OUTPUT)'"
+	$($(quiet)echodir) "make[1]: Entering directory \`$(KBUILD_OUTPUT)'"
 	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
 	KBUILD_SRC=$(CURDIR) \
 	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
@@ -292,52 +341,6 @@ endif
 export KBUILD_MODULES KBUILD_BUILTIN
 export KBUILD_CHECKSRC KBUILD_SRC KBUILD_EXTMOD
 
-# Beautify output
-# ---------------------------------------------------------------------------
-#
-# Normally, we echo the whole command before executing it. By making
-# that echo $($(quiet)$(cmd)), we now have the possibility to set
-# $(quiet) to choose other forms of output instead, e.g.
-#
-#         quiet_cmd_cc_o_c = Compiling $(RELDIR)/$@
-#         cmd_cc_o_c       = $(CC) $(c_flags) -c -o $@ $<
-#
-# If $(quiet) is empty, the whole command will be printed.
-# If it is set to "quiet_", only the short version will be printed.
-# If it is set to "silent_", nothing will be printed at all, since
-# the variable $(silent_cmd_cc_o_c) doesn't exist.
-#
-# A simple variant is to prefix commands with $(Q) - that's useful
-# for commands that shall be hidden in non-verbose mode.
-#
-#	$(Q)ln $@ :<
-#
-# If KBUILD_VERBOSE equals 0 then the above command will be hidden.
-# If KBUILD_VERBOSE equals 1 then the above command is displayed.
-
-ifeq ($(KBUILD_VERBOSE),1)
-  quiet =
-  Q =
-else
-  quiet=quiet_
-  Q = @
-endif
-
-# If the user is running make -s (silent mode), suppress echoing of
-# commands
-
-ifneq ($(filter 4.%,$(MAKE_VERSION)),)	# make-4
-ifneq ($(filter %s ,$(firstword x$(MAKEFLAGS))),)
-  quiet=silent_
-endif
-else					# make-3.8x
-ifneq ($(filter s% -s%,$(MAKEFLAGS)),)
-  quiet=silent_
-endif
-endif
-
-export quiet Q KBUILD_VERBOSE
-
 ifneq ($(CC),)
 ifeq ($(shell $(CC) -v 2>&1 | grep -c "clang version"), 1)
 COMPILER := clang
-- 
1.8.4.5

