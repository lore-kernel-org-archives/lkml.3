Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3EIDTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 23:19:01 -0400
Received: from ozlabs.org ([203.10.76.45]:39549 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab3EIDTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 23:19:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        <linux-kbuild@vger.kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Build failures due to commit ea4054a2384 (handle huge number of modules)
In-Reply-To: <20130508213007.GA11946@roeck-us.net>
References: <20130508213007.GA11946@roeck-us.net>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 09 May 2013 10:26:00 +0930
Message-ID: <8761ytnf8f.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> writes:
> Hi all,
>
> I started seeing build failures such as the following in the last week or so.
>
> make[2]: [__modpost] Error 1
>
> followed by lots of messages such as
>
> gcc: error: arch/x86/crypto/ablk_helper.mod.c: No such file or directory
> gcc: fatal error: no input files
>
> (at least if I run make -i)

Hmm, weird!  Looks like __modules contains something it shouldn't.  We
changed from:

        __modules := $(sort $(shell grep -h '\.ko$$' /dev/null $(wildcard $(MODVERDIR)/*.mod)))

To:

        MODLISTCMD := find $(MODVERDIR) -name '*.mod' | xargs -r grep -h '\.ko$$' | sort -u
        __modules := $(shell $(MODLISTCMD))

They give the same results for me:

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 8dcdca2..1ca358d 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -62,8 +62,14 @@ modulesymfile := $(firstword $(KBUILD_EXTMOD))/Module.symvers
 # Step 1), find all modules listed in $(MODVERDIR)/
 MODLISTCMD := find $(MODVERDIR) -name '*.mod' | xargs -r grep -h '\.ko$$' | sort -u
 __modules := $(shell $(MODLISTCMD))
+__old_modules := $(sort $(shell grep -h '\.ko$$' /dev/null $(wildcard $(MODVERDIR)/*.mod)))
 modules   := $(patsubst %.o,%.ko, $(wildcard $(__modules:.ko=.o)))
 
+.PHONY: dump_modules
+dump_modules:
+	@echo $(__modules) > __modules.list
+	@echo $(__old_modules) > __old_modules.list
+
 # Stop after building .o files if NOFINAL is set. Makes compile tests quicker
 _modpost: $(if $(KBUILD_MODPOST_NOFINAL), $(modules:.ko:.o),$(modules))
 
@@ -84,7 +90,7 @@ quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
       cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$$/.o/' | $(modpost) -s -T -
 
 PHONY += __modpost
-__modpost: $(modules:.ko=.o) FORCE
+__modpost: $(modules:.ko=.o) dump_modules FORCE
 	$(call cmd,modpost) $(wildcard vmlinux)
 
 quiet_cmd_kernel-mod = MODPOST $@

> After reverting commit ea4054a238 (modpost: handle huge numbers of modules)
> everything is fine.
>
> This happens with multiple gcc versions and target platforms (arm, x86_64,
> i386, powerpc). Host kernel version is 3.8.10, system is Ubuntu 12.10.
>
> Does anyone else see this problem ? Any idea what might be wrong ?

Assuming it happens with a clean tree, please send the .config, and I'll
see if I can reproduce...

Thanks,
Rusty.
