Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaBOVZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 16:25:16 -0500
Received: from asavdk4.altibox.net ([109.247.116.15]:45320 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaBOVZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 16:25:14 -0500
Date: Sat, 15 Feb 2014 22:24:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        hjl.tools@gmail.com
Subject: Re: Updated Link-Time-Optimization patchkit
Message-ID: <20140215212443.GA27575@ravnborg.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
 <20140215133814.GA287@x4>
 <20140215174424.GB32005@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215174424.GB32005@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi.

On Sat, Feb 15, 2014 at 06:44:24PM +0100, Andi Kleen wrote:
> On Sat, Feb 15, 2014 at 02:38:14PM +0100, Markus Trippelsdorf wrote:
> > On 2014.02.14 at 22:21 +0100, Andi Kleen wrote:
> > > This is the updated LTO patchkit for 3.14-rc2.  LTO allows
> > > the compiler to do global optimization over the whole kernel.
> > 
> > It is mildly annoying that one couldn't use vanilla binutils. Have you
> > already opened bugs on sourceware.org/bugzilla/ to get this fixed for
> > gold and ld.bfd?
> 
> The problem is supporting "pass through" of both pure (.S) assembler code and
> LTO through ld -r, because the kernel makefiles use ld -r heavily.
> Standard binutils would throw all the assembler away when in plugin LTO
> mode.

Long time ago I looked at eliminating the use of -r in the kernel build.
I lost the patch - but the attached patch managed to build
a "make defconfig; make" kernel.

I have not event tried boot with this - it only managed to build!

What the patch does is for each directory visited a built-in.link file is created
which is really a linker script.
It uses INPUT (file file file) to specify all the object files.
And in the final link the files are all read and the link is performed.

This limit the depth to 10 levels due to a restriction in ld.
The binutils people have suggested some other methods that I did not look into.

Half of the patch is fixes to the security makefiles which I
will submit anyway as this needs to be cleaned up indendent on
this patch.

The patch drops $(cmd_secanalysis) because I did not look into this.

If this could make it easier to enable LTO then this would be
a nice win.

	Sam



diff --git a/Makefile b/Makefile
index 933e1de..204ee3c 100644
--- a/Makefile
+++ b/Makefile
@@ -788,12 +788,12 @@ vmlinux-alldirs	:= $(sort $(vmlinux-dirs) $(patsubst %/,%,$(filter %/, \
 		     $(core-n) $(core-) $(drivers-n) $(drivers-) \
 		     $(net-n)  $(net-)  $(libs-n)    $(libs-))))
 
-init-y		:= $(patsubst %/, %/built-in.o, $(init-y))
-core-y		:= $(patsubst %/, %/built-in.o, $(core-y))
-drivers-y	:= $(patsubst %/, %/built-in.o, $(drivers-y))
-net-y		:= $(patsubst %/, %/built-in.o, $(net-y))
+init-y		:= $(patsubst %/, %/built-in.link, $(init-y))
+core-y		:= $(patsubst %/, %/built-in.link, $(core-y))
+drivers-y	:= $(patsubst %/, %/built-in.link, $(drivers-y))
+net-y		:= $(patsubst %/, %/built-in.link, $(net-y))
 libs-y1		:= $(patsubst %/, %/lib.a, $(libs-y))
-libs-y2		:= $(patsubst %/, %/built-in.o, $(libs-y))
+libs-y2		:= $(patsubst %/, %/built-in.link, $(libs-y))
 libs-y		:= $(libs-y1) $(libs-y2)
 
 # Externally visible symbols (used by link-vmlinux.sh)
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5d859c..6f01526 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -135,7 +135,7 @@ lib-target := $(obj)/lib.a
 endif
 
 ifneq ($(strip $(obj-y) $(obj-m) $(obj-n) $(obj-) $(subdir-m) $(lib-target)),)
-builtin-target := $(obj)/built-in.o
+builtin-target := $(obj)/built-in.link
 endif
 
 modorder-target := $(obj)/modules.order
@@ -378,10 +378,7 @@ $(sort $(subdir-obj-y)): $(subdir-ym) ;
 ifdef builtin-target
 quiet_cmd_link_o_target = LD      $@
 # If the list of objects to link is empty, just create an empty built-in.o
-cmd_link_o_target = $(if $(strip $(obj-y)),\
-		      $(LD) $(ld_flags) -r -o $@ $(filter $(obj-y), $^) \
-		      $(cmd_secanalysis),\
-		      rm -f $@; $(AR) rcs$(KBUILD_ARFLAGS) $@)
+cmd_link_o_target = $(if $(filter $(obj-y), $^), echo INPUT\($(filter $(obj-y), $^)\) > $@, echo "/* empty */" > $@)
 
 $(builtin-target): $(obj-y) FORCE
 	$(call if_changed,link_o_target)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 49392ec..3ea37c2 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -39,7 +39,7 @@ __subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
 subdir-y	+= $(__subdir-y)
 __subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
 subdir-m	+= $(__subdir-m)
-obj-y		:= $(patsubst %/, %/built-in.o, $(obj-y))
+obj-y		:= $(patsubst %/, %/built-in.link, $(obj-y))
 obj-m		:= $(filter-out %/, $(obj-m))
 
 # Subdirectories we need to descend into
@@ -60,7 +60,7 @@ multi-objs   := $(multi-objs-y) $(multi-objs-m)
 
 # $(subdir-obj-y) is the list of objects in $(obj-y) which uses dir/ to
 # tell kbuild to descend
-subdir-obj-y := $(filter %/built-in.o, $(obj-y))
+subdir-obj-y := $(filter %/built-in.link, $(obj-y))
 
 # $(obj-dirs) is a list of directories that contain object files
 obj-dirs := $(dir $(multi-objs) $(obj-y))
diff --git a/security/Makefile b/security/Makefile
index a5918e0..05f1c93 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -16,14 +16,14 @@ obj-$(CONFIG_MMU)			+= min_addr.o
 # Object file lists
 obj-$(CONFIG_SECURITY)			+= security.o capability.o
 obj-$(CONFIG_SECURITYFS)		+= inode.o
-obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
-obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
+obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/
+obj-$(CONFIG_SECURITY_SMACK)		+= smack/
 obj-$(CONFIG_AUDIT)			+= lsm_audit.o
-obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
-obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
-obj-$(CONFIG_SECURITY_YAMA)		+= yama/built-in.o
+obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/
+obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/
+obj-$(CONFIG_SECURITY_YAMA)		+= yama/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
 subdir-$(CONFIG_INTEGRITY)		+= integrity
-obj-$(CONFIG_INTEGRITY)			+= integrity/built-in.o
+obj-$(CONFIG_INTEGRITY)			+= integrity/
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index 0f9cffb..0793f48 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -10,6 +10,6 @@ obj-$(CONFIG_INTEGRITY_ASYMMETRIC_KEYS) += digsig_asymmetric.o
 integrity-y := iint.o
 
 subdir-$(CONFIG_IMA)			+= ima
-obj-$(CONFIG_IMA)			+= ima/built-in.o
+obj-$(CONFIG_IMA)			+= ima/
 subdir-$(CONFIG_EVM)			+= evm
-obj-$(CONFIG_EVM)			+= evm/built-in.o
+obj-$(CONFIG_EVM)			+= evm/
