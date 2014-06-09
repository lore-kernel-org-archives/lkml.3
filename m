Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbaFIWj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:39:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933117AbaFIWjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:39:25 -0400
Date: Tue, 10 Jun 2014 00:39:22 +0200
From: Michal Marek <mmarek@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 3/5] kbuild: Use relative path for $(objtree)
Message-ID: <20140609223922.GA3409@pobox.suse.cz>
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz> <1399639944-20551-4-git-send-email-mmarek@suse.cz> <CAFLxGvyz-aX8rTveo9W3mqsQxPeg8cb7Oq59UiC1kMz4qTiYwg@mail.gmail.com> <538EEA3D.1080105@suse.cz> <538F1B41.3060904@suse.cz> <20140605155614.GA18376@sepie.suse.cz> <539625D1.2090905@infradead.org> <539631CC.9040002@suse.cz> <5396340B.6060804@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5396340B.6060804@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 03:24:11PM -0700, Randy Dunlap wrote:
> On 06/09/14 15:14, Michal Marek wrote:
> > Dne 9.6.2014 23:23, Randy Dunlap napsal(a):
> >> On 06/05/14 08:56, Michal Marek wrote:
> >>> From d4bc590f8716f7dde6b7bca319097ac30a8cb0b4 Mon Sep 17 00:00:00 2001
> >>> From: Michal Marek <mmarek@suse.cz>
> >>> Date: Thu, 5 Jun 2014 17:44:44 +0200
> >>> Subject: [PATCH] um: Fix for relative objtree when generating x86 headers
> >>>
> >>> In an O= build, rely on the generated Makefile to call the main Makefile
> >>> properly. When building in the source tree, we do not need to specify
> >>> the -C and O= either. This fixes the problem when $(objtree) is a
> >>> relative path and the -C changes the directory.
> >>>
> >>> Reported-by: Richard Weinberger <richard.weinberger@gmail.com>
> >>> Signed-off-by: Michal Marek <mmarek@suse.cz>
> >>> ---
> >>>  arch/um/Makefile | 3 +--
> >>>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>>
> >>> diff --git a/arch/um/Makefile b/arch/um/Makefile
> >>> index 36e658a..e4b1a96 100644
> >>> --- a/arch/um/Makefile
> >>> +++ b/arch/um/Makefile
> >>> @@ -111,8 +111,7 @@ endef
> >>>  KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
> >>>  
> >>>  archheaders:
> >>> -	$(Q)$(MAKE) -C '$(srctree)' KBUILD_SRC= \
> >>> -		ARCH=$(HEADER_ARCH) O='$(objtree)' archheaders
> >>> +	$(Q)$(MAKE) KBUILD_SRC= ARCH=$(HEADER_ARCH) archheaders
> >>>  
> >>>  archprepare: include/generated/user_constants.h
> >>>  
> >>>
> >>
> >> I still get this build error when building uml for i386:
> >>
> >>   CC      arch/x86/um/user-offsets.s
> >> ../arch/x86/um/user-offsets.c:14:29: fatal error: asm/syscalls_32.h: No such file or directory
> >> compilation terminated.
> >> make[2]: *** [arch/x86/um/user-offsets.s] Error 1
> > 
> > Thanks for testing the patch. I cannot reproduce it though:
> > 
> >   make ARCH=um SUBARCH=i386 O=/dev/shm/li defconfig
> >   make ARCH=um SUBARCH=i386 O=/dev/shm/li
> 
> That doesn't work for me either.  Must be a difference somewhere else.
> I am using linux-next of 20140606 (latest that I know of) with only your
> recent patch applied to it.

I checked out next-20140606 and added the fix on top:

$ git cherry-pick d4bc590f8716f7dde6b7bca319097ac30a8cb0b4
[test cfc8100] um: Fix for relative objtree when generating x86 headers
 1 file changed, 1 insertion(+), 2 deletions(-)
$ git rev-parse HEAD^{tree}
8fad860b10c2abc86b1ca820a1b9f2a9267e669b

The resulting tree id should be identical to yours (the commit id
depends on time). It still works for me, however:

$ make mrproper
...
$ make ARCH=um SUBARCH=i386 O=/dev/shm/li defconfig
  GEN     ./Makefile
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
*** Default configuration is based on 'i386_defconfig'
#
# configuration written to .config
#
$ make ARCH=um SUBARCH=i386 O=/dev/shm/li 
  GEN     ./Makefile
scripts/kconfig/conf --silentoldconfig arch/x86/um/Kconfig
  CHK     include/generated/uapi/linux/version.h
  WRAP    arch/um/include/generated/asm/scatterlist.h
  SYSTBL  arch/x86/syscalls/../include/generated/asm/syscalls_32.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_32.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_x32.h
  CC      arch/x86/um/user-offsets.s
  CHK     include/generated/user_constants.h
  UPD     include/generated/user_constants.h
  CHK     include/config/kernel.release
  UPD     include/config/kernel.release
  Using /labs/mmarek/linux-2.6 as source for kernel
  GEN     ./Makefile
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/um/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    /labs/mmarek/linux-2.6/scripts/checksyscalls.sh
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  CC      scripts/mod/devicetable-offsets.s
  GEN     scripts/mod/devicetable-offsets.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  CC      init/main.o

... and so on. Can you please post the whole make V=1 log leading to the
failure?


> > Also, you pointed out i386 -- Does it mean that the fix worked for you
> > on x86_64?
> 
> Yes, it did work on x86_64 for some reason.

That's great. I will push the fix, since at least on scenario is confirmed to
work.

Thanks,
Michal
