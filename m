Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaDOBlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:41:10 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39475 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaDOBlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:41:08 -0400
Message-ID: <534C8E2D.9020506@hitachi.com>
Date: Tue, 15 Apr 2014 10:41:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: Move instruction decoder data into header
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-2-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1397497450-6440-2-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/15 2:44), Sasha Levin wrote:
> Right now we generate data for the instruction decoder and place it
> as a code file which gets #included directly (yuck).
> 
> Instead, make it a header which will also be usable by other code
> that wants to use the data in there.

Hmm, making the generated data into a header file may clone
the data table instances for each object file. Since the inat
table is not so small, I think we'd better just export the tables.

Thank you,

> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  arch/x86/Makefile       |    6 ++++++
>  arch/x86/lib/Makefile   |    8 +++++---
>  arch/x86/lib/inat.c     |    2 +-
>  arch/x86/tools/Makefile |    8 ++++----
>  4 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 602f57e..26eee4e 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -178,6 +178,12 @@ archscripts: scripts_basic
>  	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
>  
>  ###
> +# inat instruction table generation
> +
> +archprepare:
> +	$(Q)$(MAKE) $(build)=arch/x86/lib inat_tables
> +
> +###
>  # Syscall table generation
>  
>  archheaders:
> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> index eabcb6e..3014da8 100644
> --- a/arch/x86/lib/Makefile
> +++ b/arch/x86/lib/Makefile
> @@ -7,12 +7,12 @@ inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
>  quiet_cmd_inat_tables = GEN     $@
>        cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
>  
> -$(obj)/inat-tables.c: $(inat_tables_script) $(inat_tables_maps)
> +$(obj)/../include/generated/asm/inat-tables.h: $(inat_tables_script) $(inat_tables_maps)
>  	$(call cmd,inat_tables)
>  
> -$(obj)/inat.o: $(obj)/inat-tables.c
> +$(obj)/inat.o: $(obj)/../include/generated/asm/inat-tables.h
>  
> -clean-files := inat-tables.c
> +clean-files := ../include/asm/inat-tables.h
>  
>  obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
>  
> @@ -44,3 +44,5 @@ else
>          lib-y += copy_user_64.o copy_user_nocache_64.o
>  	lib-y += cmpxchg16b_emu.o
>  endif
> +
> +inat_tables: $(obj)/../include/generated/asm/inat-tables.h
> diff --git a/arch/x86/lib/inat.c b/arch/x86/lib/inat.c
> index c1f01a8..641a996 100644
> --- a/arch/x86/lib/inat.c
> +++ b/arch/x86/lib/inat.c
> @@ -21,7 +21,7 @@
>  #include <asm/insn.h>
>  
>  /* Attribute tables are generated from opcode map */
> -#include "inat-tables.c"
> +#include <asm/inat-tables.h>
>  
>  /* Attribute search APIs */
>  insn_attr_t inat_get_opcode_attribute(insn_byte_t opcode)
> diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
> index e812034..e34e7e3 100644
> --- a/arch/x86/tools/Makefile
> +++ b/arch/x86/tools/Makefile
> @@ -28,14 +28,14 @@ posttest: $(obj)/test_get_len vmlinux $(obj)/insn_sanity
>  hostprogs-y	+= test_get_len insn_sanity
>  
>  # -I needed for generated C source and C source which in the kernel tree.
> -HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/uapi/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/uapi/
> +HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/uapi/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/uapi/ -I$(srctree)/arch/x86/include/generated/
>  
> -HOSTCFLAGS_insn_sanity.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/
> +HOSTCFLAGS_insn_sanity.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/ -I$(srctree)/arch/x86/include/generated/
>  
>  # Dependencies are also needed.
> -$(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
> +$(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/include/generated/asm/inat-tables.h
>  
> -$(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
> +$(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/include/generated/asm/inat-tables.h
>  
>  HOST_EXTRACFLAGS += -I$(srctree)/tools/include
>  hostprogs-y	+= relocs
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


