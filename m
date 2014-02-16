Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaBPUhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:37:47 -0500
Received: from asavdk3.altibox.net ([109.247.116.14]:37900 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaBPUhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:37:46 -0500
Date: Sun, 16 Feb 2014 21:37:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        mmarek@suse.cz, Cary Coutant <ccoutant@google.com>,
        Alan Modra <amodra@gmail.com>
Subject: [RFC] kbuild: drop use of "ld -r" for intermediate links of vmlinux
Message-ID: <20140216203724.GA19216@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The approach today is that all files that ends up in vmlinux are
linked directory by directory using "ld -r".

The following patch moves away from all the intermediate links
and do one huge link of all the .o files used for the final vmlinux.

The trick used is that for each directory a linker script is
generated that name all the file to be linked - and for
sub-directories this is just the linker script for that directory.

The file continue to be named "built-in.o" but it is really a linker script.

A limitation using linker scripts like this is that this introduces
a maximum depth of 10 levels (ld limitation when using INPUT).
And the final link will for a kernel likely involves > 1000 .o files.

For now this is an experimental path - and I have not even tried
to boot the kernel (as this is not simple in my current setup).

Feedback from the binutils people would be great if this is
actually a good way to get rid of the use of "ld -r" in the kernel.
Copied a few binutils people to hopefully get some feedback.

A typical file looks like this:

$cat kernel/built-in.o
INPUT(kernel/fork.o kernel/exec_domain.o ... kernel/locking/built-in.o ...)

kernel/locking/built-in.o is another linker script that again reference some .o files.

The background for this patch was that the LTO patch-kit that Andi Kleen is
working on referenced a thread in binutils mailing list that complained
about the use of "ld -r" in the kernel build and that LTO support for
"ld -r" builds would likely not be accepted in binutils.

I had woked on the following some years ago and recreated the patch.
I recall the idea is from someone else - but have long lost memory of
from where I saw it.

	Sam


diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a48abea..b6ca48a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -249,14 +249,6 @@ config DEBUG_SECTION_MISMATCH
 	    the analysis would not catch the illegal reference.
 	    This option tells gcc to inline less (but it does result in
 	    a larger kernel).
-	  - Run the section mismatch analysis for each module/built-in.o file.
-	    When we run the section mismatch analysis on vmlinux.o, we
-	    lose valueble information about where the mismatch was
-	    introduced.
-	    Running the analysis for each module/built-in.o file
-	    tells where the mismatch happens much closer to the
-	    source. The drawback is that the same mismatch is
-	    reported at least twice.
 	  - Enable verbose reporting from modpost in order to help resolve
 	    the section mismatches that are reported.
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5d859c..a568276 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -158,11 +158,6 @@ ifneq ($(KBUILD_CHECKSRC),0)
   endif
 endif
 
-# Do section mismatch analysis for each module/built-in.o
-ifdef CONFIG_DEBUG_SECTION_MISMATCH
-  cmd_secanalysis = ; scripts/mod/modpost $@
-endif
-
 # Compile C sources (.c)
 # ---------------------------------------------------------------------------
 
@@ -378,10 +373,9 @@ $(sort $(subdir-obj-y)): $(subdir-ym) ;
 ifdef builtin-target
 quiet_cmd_link_o_target = LD      $@
 # If the list of objects to link is empty, just create an empty built-in.o
-cmd_link_o_target = $(if $(strip $(obj-y)),\
-		      $(LD) $(ld_flags) -r -o $@ $(filter $(obj-y), $^) \
-		      $(cmd_secanalysis),\
-		      rm -f $@; $(AR) rcs$(KBUILD_ARFLAGS) $@)
+cmd_link_o_target = $(if $(filter $(obj-y), $^),                   \
+			echo INPUT\($(filter $(obj-y), $^)\) > $@, \
+			echo "/* empty */" > $@)
 
 $(builtin-target): $(obj-y) FORCE
 	$(call if_changed,link_o_target)
@@ -428,10 +422,10 @@ $($(subst $(obj)/,,$(@:.o=-objs)))    \
 $($(subst $(obj)/,,$(@:.o=-y)))), $^)
  
 quiet_cmd_link_multi-y = LD      $@
-cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps) $(cmd_secanalysis)
+cmd_link_multi-y = echo INPUT\($(link_multi_deps)\) > $@
 
 quiet_cmd_link_multi-m = LD [M]  $@
-cmd_link_multi-m = $(cmd_link_multi-y)
+cmd_link_multi-m = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps)
 
 # We would rather have a list of rules like
 # 	foo.o: $(foo-objs)
