Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaHTNJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:09:38 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:65068 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaHTNJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:09:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdX4HXf91RcuxzdU=HRvqtikBd=7Q62msQUMGVFuHuJ4+g@mail.gmail.com>
References: <1408483010-32689-1-git-send-email-bobby.prani@gmail.com> <CAMuHMdX4HXf91RcuxzdU=HRvqtikBd=7Q62msQUMGVFuHuJ4+g@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 20 Aug 2014 09:09:04 -0400
Message-ID: <CAJhHMCBzRy_-nKmW3Wpsck9KhzoL1JCkaNvok1JOFU0r44m19Q@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc: Make SPU_FS depend on SPARSEMEM
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "open list:CELL BROADBAND EN..." <linuxppc-dev@lists.ozlabs.org>,
        "open list:CELL BROADBAND EN..." <cbe-oss-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        Geoff Levand <geoffrey.levand@am.sony.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 3:49 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:

> Is this a randconfig kernel?

Yes, randconfig with ARCH=powerpc.

>
> config ARCH_SPARSEMEM_DEFAULT
>        def_bool y
>        depends on (SMP && PPC_PSERIES) || PPC_PS3
>
> Why is this not enabled? !SMP? !PPC_PSERIES? !PPC_PS3?

This was indeed enabled, but that does not do much. We will need
CONFIG_SPARSEMEM which depends on CONFIG_SPARSEMEM_MANUAL which was
not enabled.


>
> If PPC_CELL is enabled, this issue was introduced by
>
> commit 78bde53e351bc89cff85d1c2c7e6d7c2ffdf120d
> Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date:   Tue Feb 13 11:46:06 2007 +1100
>
>     [POWERPC] spufs: remove need for struct page for SPEs
>
>     This patch removes the need for struct page for SPE local store
>     and registers from spufs. It also makes the locking much more
>     obvious and no longer relying on the truncate logic black magic
>     for protecting against races between unmap_mapping_range() and
>     new pages faulted in. It does so by switching to a nopfn() handler
>     and using the new vm_insert_pfn() to setup the PTEs itself while
>     holding a lock on the SPE.
>
>     The nice thing is that this patch actually removes a lot more code
>     than it adds :-)
>
>     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Signed-off-by: Paul Mackerras <paulus@samba.org>
>
>
> Another question: why does SPU_FS select MEMORY_HOTPLUG?

Not really sure :(

>
> commit 4da30d15b6d5036b0d96422d6946ca758111fae3
> Author: Geoff Levand <geoffrey.levand@am.sony.com>
> Date:   Fri Jun 23 20:57:49 2006 +0200
>
>     [POWERPC] spufs: fix memory hotplug dependency
>
>     spufs_base.c calls __add_pages, which depends on CONFIG_MEMORY_HOTPLUG.
>
>     Moved the selection of CONFIG_MEMORY_HOTPLUG from CONFIG_SPUFS_MMAP
>     to CONFIG_SPU_FS.
>
>     Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
>     Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
>     Signed-off-by: Paul Mackerras <paulus@samba.org>
>
> However, the call to __add_pages() has been moved a few times afterwards,
> to be finally removed in the aforementioned commit
> 78bde53e351bc89cff85d1c2c7e6d7c2ffdf120d.
>
> Does it still build/work if you just drop the "select MEMORY_HOTPLUG"?

I should have saved the config file :(. I think it will build since
the problem was that hotplug-memory.o needs CONFIG_SPARSEMEM.



-- 
Pranith
