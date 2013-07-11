Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3GKNyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:54:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab3GKNyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:54:52 -0400
Date: Thu, 11 Jul 2013 15:54:45 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Beulich <JBeulich@suse.com>, dt.tangr@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        James Hogan <james.hogan@imgtec.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        robert.richter@calxeda.com,
        "Yaakov (Cygwin/X)" <yselkowitz@users.sourceforge.net>,
        zzs0213@gmail.com,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] kbuild changes for v3.11-rc1
Message-ID: <20130711135445.GA21500@sepie.suse.cz>
References: <20130710133742.GA29368@emu.suse.cz>
 <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 07:11:53PM -0700, Linus Torvalds wrote:
> You need to start being more careful. And I would seriously suggest
> you start doing some explicit testing for this. You can do things like
> "find . -user root", and if that shows a single file in the kernel
> tree after a "make [modules_]install", then there's a problem.

Good idea. I added this after the *install calls in my test script.


> Commit d2aae8477cd00325bb7c7c7e95be488088900c48 is broken. It causes
> root to re-write "include/config/kernel.release".

Yeah. It also reveals another bug that we rewrite the kernel.release
file each time. This patch should fix it, but please do not apply it
yet:

>From f522eef24216f229c82b6bbb55f326814db2bac0 Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Thu, 11 Jul 2013 15:34:51 +0200
Subject: [PATCH] kbuild: Do not overwrite include/config/kernel.release
 needlessly

Use filechk to detect if the content changed or not.

diff --git a/Makefile b/Makefile
index 4e3575c..3aa232f 100644
--- a/Makefile
+++ b/Makefile
@@ -794,10 +794,13 @@ PHONY += $(vmlinux-dirs)
 $(vmlinux-dirs): prepare scripts
 	$(Q)$(MAKE) $(build)=$@
 
+define filechk_kernel.release
+	echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
+endef
+
 # Store (new) KERNELRELEASE string in include/config/kernel.release
 include/config/kernel.release: include/config/auto.conf FORCE
-	$(Q)rm -f $@
-	$(Q)echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))" > $@
+	$(call filechk,kernel.release)
 
 
 # Things we need to do before we recursively start building the kernel


> There is no excuse for this. That commit is shit. There's no way in
> hell that "make modules_install" should ever rebuild anything, so
> adding that kind of dependency is fundamentally wrong and broken.

We also run dozens of gcc checks during every make invocation, including
make install or make help, so there is some room for improvement. But at
least, these do not write to the source or object tree.

Michal
