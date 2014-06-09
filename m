Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaFIXrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:47:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:46352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaFIXrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:47:47 -0400
Message-ID: <5396479F.6030809@infradead.org>
Date: Mon, 09 Jun 2014 16:47:43 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 3/5] kbuild: Use relative path for $(objtree)
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz> <1399639944-20551-4-git-send-email-mmarek@suse.cz> <CAFLxGvyz-aX8rTveo9W3mqsQxPeg8cb7Oq59UiC1kMz4qTiYwg@mail.gmail.com> <538EEA3D.1080105@suse.cz> <538F1B41.3060904@suse.cz> <20140605155614.GA18376@sepie.suse.cz> <539625D1.2090905@infradead.org> <539631CC.9040002@suse.cz> <5396340B.6060804@infradead.org> <20140609223922.GA3409@pobox.suse.cz>
In-Reply-To: <20140609223922.GA3409@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/14 15:39, Michal Marek wrote:
> On Mon, Jun 09, 2014 at 03:24:11PM -0700, Randy Dunlap wrote:
>> On 06/09/14 15:14, Michal Marek wrote:
>>> Dne 9.6.2014 23:23, Randy Dunlap napsal(a):
>>>> On 06/05/14 08:56, Michal Marek wrote:
>>>>> From d4bc590f8716f7dde6b7bca319097ac30a8cb0b4 Mon Sep 17 00:00:00 2001
>>>>> From: Michal Marek <mmarek@suse.cz>
>>>>> Date: Thu, 5 Jun 2014 17:44:44 +0200
>>>>> Subject: [PATCH] um: Fix for relative objtree when generating x86 headers
>>>>>
>>>>> In an O= build, rely on the generated Makefile to call the main Makefile
>>>>> properly. When building in the source tree, we do not need to specify
>>>>> the -C and O= either. This fixes the problem when $(objtree) is a
>>>>> relative path and the -C changes the directory.
>>>>>
>>>>> Reported-by: Richard Weinberger <richard.weinberger@gmail.com>
>>>>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>>>>> ---
>>>>>  arch/um/Makefile | 3 +--
>>>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/um/Makefile b/arch/um/Makefile
>>>>> index 36e658a..e4b1a96 100644
>>>>> --- a/arch/um/Makefile
>>>>> +++ b/arch/um/Makefile
>>>>> @@ -111,8 +111,7 @@ endef
>>>>>  KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
>>>>>  
>>>>>  archheaders:
>>>>> -	$(Q)$(MAKE) -C '$(srctree)' KBUILD_SRC= \
>>>>> -		ARCH=$(HEADER_ARCH) O='$(objtree)' archheaders
>>>>> +	$(Q)$(MAKE) KBUILD_SRC= ARCH=$(HEADER_ARCH) archheaders
>>>>>  
>>>>>  archprepare: include/generated/user_constants.h
>>>>>  
>>>>>
>>>>
>>>> I still get this build error when building uml for i386:
>>>>
>>>>   CC      arch/x86/um/user-offsets.s
>>>> ../arch/x86/um/user-offsets.c:14:29: fatal error: asm/syscalls_32.h: No such file or directory
>>>> compilation terminated.
>>>> make[2]: *** [arch/x86/um/user-offsets.s] Error 1
>>>
>>> Thanks for testing the patch. I cannot reproduce it though:
>>>
>>>   make ARCH=um SUBARCH=i386 O=/dev/shm/li defconfig
>>>   make ARCH=um SUBARCH=i386 O=/dev/shm/li
>>
>> That doesn't work for me either.  Must be a difference somewhere else.
>> I am using linux-next of 20140606 (latest that I know of) with only your
>> recent patch applied to it.
> 
> I checked out next-20140606 and added the fix on top:
> 
> $ git cherry-pick d4bc590f8716f7dde6b7bca319097ac30a8cb0b4
> [test cfc8100] um: Fix for relative objtree when generating x86 headers
>  1 file changed, 1 insertion(+), 2 deletions(-)
> $ git rev-parse HEAD^{tree}
> 8fad860b10c2abc86b1ca820a1b9f2a9267e669b
> 
> The resulting tree id should be identical to yours (the commit id
> depends on time). It still works for me, however:
> 
> $ make mrproper
> ...
> $ make ARCH=um SUBARCH=i386 O=/dev/shm/li defconfig
>   GEN     ./Makefile
>   HOSTCC  scripts/kconfig/zconf.tab.o
>   HOSTLD  scripts/kconfig/conf
> *** Default configuration is based on 'i386_defconfig'
> #
> # configuration written to .config
> #
> $ make ARCH=um SUBARCH=i386 O=/dev/shm/li 
>   GEN     ./Makefile
> scripts/kconfig/conf --silentoldconfig arch/x86/um/Kconfig
>   CHK     include/generated/uapi/linux/version.h
>   WRAP    arch/um/include/generated/asm/scatterlist.h
>   SYSTBL  arch/x86/syscalls/../include/generated/asm/syscalls_32.h
>   SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_32.h
>   SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_64.h
>   SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_x32.h
>   CC      arch/x86/um/user-offsets.s
>   CHK     include/generated/user_constants.h
>   UPD     include/generated/user_constants.h
>   CHK     include/config/kernel.release
>   UPD     include/config/kernel.release
>   Using /labs/mmarek/linux-2.6 as source for kernel
>   GEN     ./Makefile
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   CC      kernel/bounds.s
>   GEN     include/generated/bounds.h
>   CC      arch/um/kernel/asm-offsets.s
>   GEN     include/generated/asm-offsets.h
>   CALL    /labs/mmarek/linux-2.6/scripts/checksyscalls.sh
>   HOSTCC  scripts/mod/mk_elfconfig
>   MKELF   scripts/mod/elfconfig.h
>   CC      scripts/mod/devicetable-offsets.s
>   GEN     scripts/mod/devicetable-offsets.h
>   HOSTCC  scripts/mod/file2alias.o
>   HOSTCC  scripts/mod/modpost.o
>   HOSTCC  scripts/mod/sumversion.o
>   HOSTLD  scripts/mod/modpost
>   CC      init/main.o
> 
> ... and so on. Can you please post the whole make V=1 log leading to the
> failure?

sure.  I did mkdir /tmp/O then
make ARCH=um SUBARCH=i386 O=/tmp/O defconfig
make ARCH=um SUBARCH=i386 V=1 O=/tmp/O


make -C /tmp/O \
KBUILD_SRC=/local/lnx/next/linux-next-20140606 \
KBUILD_EXTMOD="" -f /local/lnx/next/linux-next-20140606/Makefile \

make -f /local/lnx/next/linux-next-20140606/Makefile silentoldconfig
make -f /local/lnx/next/linux-next-20140606/scripts/Makefile.build obj=scripts/basic
rm -f .tmp_quiet_recordmcount
ln -fsn /local/lnx/next/linux-next-20140606 source
/bin/sh /local/lnx/next/linux-next-20140606/scripts/mkmakefile \
    /local/lnx/next/linux-next-20140606 . 3 15
  GEN     ./Makefile
mkdir -p include/linux include/config
make -f /local/lnx/next/linux-next-20140606/scripts/Makefile.build obj=scripts/kconfig silentoldconfig
mkdir -p include/generated
scripts/kconfig/conf --silentoldconfig arch/x86/um/Kconfig
set -e; : '  CHK     include/generated/uapi/linux/version.h'; mkdir -p include/generated/uapi/linux/; 	(echo \#define LINUX_VERSION_CODE 200448; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < /local/lnx/next/linux-next-20140606/Makefile > include/generated/uapi/linux/version.h.tmp; if [ -r include/generated/uapi/linux/version.h ] && cmp -s include/generated/uapi/linux/version.h include/generated/uapi/linux/version.h.tmp; then rm -f include/generated/uapi/linux/version.h.tmp; else : '  UPD     include/generated/uapi/linux/version.h'; mv -f include/generated/uapi/linux/version.h.tmp include/generated/uapi/linux/version.h; fi
make -f /local/lnx/next/linux-next-20140606/scripts/Makefile.build obj=scripts/basic
(cat /dev/null; ) > scripts/basic/modules.order
rm -f .tmp_quiet_recordmcount
make -f /local/lnx/next/linux-next-20140606/scripts/Makefile.asm-generic \
            src=asm obj=arch/um/include/generated/asm
  echo "#include <asm-generic/barrier.h>" >arch/um/include/generated/asm/barrier.h
  echo "#include <asm-generic/bug.h>" >arch/um/include/generated/asm/bug.h
  echo "#include <asm-generic/clkdev.h>" >arch/um/include/generated/asm/clkdev.h
  echo "#include <asm-generic/cputime.h>" >arch/um/include/generated/asm/cputime.h
  echo "#include <asm-generic/current.h>" >arch/um/include/generated/asm/current.h
  echo "#include <asm-generic/delay.h>" >arch/um/include/generated/asm/delay.h
  echo "#include <asm-generic/device.h>" >arch/um/include/generated/asm/device.h
  echo "#include <asm-generic/emergency-restart.h>" >arch/um/include/generated/asm/emergency-restart.h
  echo "#include <asm-generic/exec.h>" >arch/um/include/generated/asm/exec.h
  echo "#include <asm-generic/ftrace.h>" >arch/um/include/generated/asm/ftrace.h
  echo "#include <asm-generic/futex.h>" >arch/um/include/generated/asm/futex.h
  echo "#include <asm-generic/hardirq.h>" >arch/um/include/generated/asm/hardirq.h
  echo "#include <asm-generic/hash.h>" >arch/um/include/generated/asm/hash.h
  echo "#include <asm-generic/hw_irq.h>" >arch/um/include/generated/asm/hw_irq.h
  echo "#include <asm-generic/io.h>" >arch/um/include/generated/asm/io.h
  echo "#include <asm-generic/irq_regs.h>" >arch/um/include/generated/asm/irq_regs.h
  echo "#include <asm-generic/kdebug.h>" >arch/um/include/generated/asm/kdebug.h
  echo "#include <asm-generic/mcs_spinlock.h>" >arch/um/include/generated/asm/mcs_spinlock.h
  echo "#include <asm-generic/mutex.h>" >arch/um/include/generated/asm/mutex.h
  echo "#include <asm-generic/param.h>" >arch/um/include/generated/asm/param.h
  echo "#include <asm-generic/pci.h>" >arch/um/include/generated/asm/pci.h
  echo "#include <asm-generic/percpu.h>" >arch/um/include/generated/asm/percpu.h
  echo "#include <asm-generic/preempt.h>" >arch/um/include/generated/asm/preempt.h
  echo "#include <asm-generic/scatterlist.h>" >arch/um/include/generated/asm/scatterlist.h
  echo "#include <asm-generic/sections.h>" >arch/um/include/generated/asm/sections.h
  echo "#include <asm-generic/switch_to.h>" >arch/um/include/generated/asm/switch_to.h
  echo "#include <asm-generic/topology.h>" >arch/um/include/generated/asm/topology.h
  echo "#include <asm-generic/trace_clock.h>" >arch/um/include/generated/asm/trace_clock.h
  echo "#include <asm-generic/xor.h>" >arch/um/include/generated/asm/xor.h
make -f /local/lnx/next/linux-next-20140606/scripts/Makefile.asm-generic \
            src=uapi/asm obj=arch/um/include/generated/uapi/asm
make KBUILD_SRC= ARCH=x86 archheaders
make -C /local/lnx/next/linux-next-20140606 O=/tmp/O/. archheaders
make -C /tmp/O \
KBUILD_SRC=/local/lnx/next/linux-next-20140606 \
KBUILD_EXTMOD="" -f /local/lnx/next/linux-next-20140606/Makefile \
archheaders
make -f /local/lnx/next/linux-next-20140606/scripts/Makefile.build obj=arch/x86/syscalls all
make -f /local/lnx/next/linux-next-20140606/scripts/Makefile.build obj=scripts build_unifdef
  gcc -Wp,-MD,scripts/.unifdef.d -Iscripts -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer   -I/local/lnx/next/linux-next-20140606/tools/include -o scripts/unifdef /local/lnx/next/linux-next-20140606/scripts/unifdef.c  
make -f /local/lnx/next/linux-next-20140606/scripts/Makefile.build obj=arch/x86/um arch/x86/um/user-offsets.s
  gcc -Wp,-MD,arch/x86/um/.user-offsets.s.d  -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -Wno-maybe-uninitialized -m32 -funit-at-a-time -march=i686 -Wa,-mtune=generic32 -mpreferred-stack-boundary=2 -ffreestanding -D__arch_um__ -Dvmap=kernel_vmap -Din6addr_loopback=kernel_in6addr_loopback -Din6addr_any=kernel_in6addr_any -Dstrrchr=kernel_strrchr -D_LARGEFILE64_SOURCE  -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -DCC_HAVE_ASM_GOTO -I/local/lnx/next/linux-next-20140606/arch/um/include/shared -I/local/lnx/next/linux-next-20140606/arch/x86/um/shared -I/local/lnx/next/linux-next-20140606/arch/um/include/shared/skas  -D_FILE_OFFSET_BITS=64 -idira
fter include -D_GNU_SOURCE -D_LARGEFILE64_SOURCE -Iarch/x86/include/generated  -fverbose-asm -S -o arch/x86/um/user-offsets.s /local/lnx/next/linux-next-20140606/arch/x86/um/user-offsets.c
/local/lnx/next/linux-next-20140606/arch/x86/um/user-offsets.c:14:29: fatal error: asm/syscalls_32.h: No such file or directory
compilation terminated.
make[2]: *** [arch/x86/um/user-offsets.s] Error 1
make[1]: *** [arch/x86/um/user-offsets.s] Error 2
make: *** [sub-make] Error 2



> 
>>> Also, you pointed out i386 -- Does it mean that the fix worked for you
>>> on x86_64?
>>
>> Yes, it did work on x86_64 for some reason.
> 
> That's great. I will push the fix, since at least on scenario is confirmed to
> work.


-- 
~Randy
