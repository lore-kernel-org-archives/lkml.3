Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaHTHtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:49:31 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35003 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaHTHt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <1408483010-32689-1-git-send-email-bobby.prani@gmail.com>
References: <1408483010-32689-1-git-send-email-bobby.prani@gmail.com>
Date: Wed, 20 Aug 2014 09:49:27 +0200
X-Google-Sender-Auth: jr24UL263jzkCMOPy_C6TaaNyoA
Message-ID: <CAMuHMdX4HXf91RcuxzdU=HRvqtikBd=7Q62msQUMGVFuHuJ4+g@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc: Make SPU_FS depend on SPARSEMEM
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "open list:CELL BROADBAND EN..." <linuxppc-dev@lists.ozlabs.org>,
        "open list:CELL BROADBAND EN..." <cbe-oss-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranith,

On Tue, Aug 19, 2014 at 11:16 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> SPU_FS unconditionally enables MEMORY_HOTPLUG, which will fail to build if
> SPARSEMEM=n.
>
> Make SPU_FS depend on SPARSEMEM so that hotplug-memory.c does not fail to
> compile.
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  arch/powerpc/platforms/cell/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/platforms/cell/Kconfig b/arch/powerpc/platforms/cell/Kconfig
> index 9978f59..832872e 100644
> --- a/arch/powerpc/platforms/cell/Kconfig
> +++ b/arch/powerpc/platforms/cell/Kconfig
> @@ -60,7 +60,7 @@ menu "Cell Broadband Engine options"
>  config SPU_FS
>         tristate "SPU file system"
>         default m
> -       depends on PPC_CELL
> +       depends on PPC_CELL && SPARSEMEM
>         select SPU_BASE
>         select MEMORY_HOTPLUG
>         help
> --
> 1.9.1

Is this a randconfig kernel?

config ARCH_SPARSEMEM_DEFAULT
       def_bool y
       depends on (SMP && PPC_PSERIES) || PPC_PS3

Why is this not enabled? !SMP? !PPC_PSERIES? !PPC_PS3?

If PPC_CELL is enabled, this issue was introduced by

commit 78bde53e351bc89cff85d1c2c7e6d7c2ffdf120d
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Tue Feb 13 11:46:06 2007 +1100

    [POWERPC] spufs: remove need for struct page for SPEs

    This patch removes the need for struct page for SPE local store
    and registers from spufs. It also makes the locking much more
    obvious and no longer relying on the truncate logic black magic
    for protecting against races between unmap_mapping_range() and
    new pages faulted in. It does so by switching to a nopfn() handler
    and using the new vm_insert_pfn() to setup the PTEs itself while
    holding a lock on the SPE.

    The nice thing is that this patch actually removes a lot more code
    than it adds :-)

    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>


Another question: why does SPU_FS select MEMORY_HOTPLUG?

commit 4da30d15b6d5036b0d96422d6946ca758111fae3
Author: Geoff Levand <geoffrey.levand@am.sony.com>
Date:   Fri Jun 23 20:57:49 2006 +0200

    [POWERPC] spufs: fix memory hotplug dependency

    spufs_base.c calls __add_pages, which depends on CONFIG_MEMORY_HOTPLUG.

    Moved the selection of CONFIG_MEMORY_HOTPLUG from CONFIG_SPUFS_MMAP
    to CONFIG_SPU_FS.

    Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
    Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

However, the call to __add_pages() has been moved a few times afterwards,
to be finally removed in the aforementioned commit
78bde53e351bc89cff85d1c2c7e6d7c2ffdf120d.

Does it still build/work if you just drop the "select MEMORY_HOTPLUG"?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
