Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab3G3HpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:45:04 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56043 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab3G3HpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:45:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307300827010.2625@M2420>
References: <alpine.DEB.2.02.1307300827010.2625@M2420>
From: Peng Tao <bergwolf@gmail.com>
Date: Tue, 30 Jul 2013 15:44:40 +0800
Message-ID: <CA+a=Yy4FAOhKkwgzuCj-rtd9rE2jc8WOf=E8OMQ=o=JUrGgW1w@mail.gmail.com>
Subject: Re: [PATCH v2] staging/lustre: lloop depends on BLOCK
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <trivial@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 8:29 AM, Xiong Zhou <jencce.kernel@gmail.com> wrote:
> From: Xiong Zhou <jencce.kernel@gmail.com>
>
> In the lustre client driver, lloop depends on BLOCK. Add an
> option for this dependence. Last version of this patch makes
> LUSTRE_FS depends on BLOCK.
> Remove unnecessary jdb head files which depends on BLOCK.
>
Thanks for the patch. One minor comment below. Other than that, you can add
Reviewed-by: Peng Tao <tao.peng@emc.com>

> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
> ---
>  drivers/staging/lustre/lustre/Kconfig              |    7 ++++++-
>  drivers/staging/lustre/lustre/fld/fld_cache.c      |    1 -
>  drivers/staging/lustre/lustre/fld/fld_request.c    |    1 -
>  .../lustre/lustre/include/linux/lustre_compat25.h  |    2 ++
>  drivers/staging/lustre/lustre/llite/Makefile       |    2 +-
>  drivers/staging/lustre/lustre/lvfs/fsfilt.c        |    1 -
>  6 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
> index 0b45de0..4e898e4 100644
> --- a/drivers/staging/lustre/lustre/Kconfig
> +++ b/drivers/staging/lustre/lustre/Kconfig
> @@ -1,6 +1,6 @@
>  config LUSTRE_FS
>         tristate "Lustre file system client support"
> -       depends on STAGING && INET && BLOCK && m
> +       depends on INET && m
>         select LNET
>         select CRYPTO
>         select CRYPTO_CRC32
> @@ -53,3 +53,8 @@ config LUSTRE_TRANSLATE_ERRNOS
>         bool
>         depends on LUSTRE_FS && !X86
>         default true
> +
> +config LUSTRE_LLITE_LLOOP
> +       bool "Lustre virtual block device"
> +       depends on LUSTRE_FS && BLOCK
> +       default m
> diff --git a/drivers/staging/lustre/lustre/fld/fld_cache.c b/drivers/staging/lustre/lustre/fld/fld_cache.c
> index 347f2ae..8410107 100644
> --- a/drivers/staging/lustre/lustre/fld/fld_cache.c
> +++ b/drivers/staging/lustre/lustre/fld/fld_cache.c
> @@ -45,7 +45,6 @@
>
>  # include <linux/libcfs/libcfs.h>
>  # include <linux/module.h>
> -# include <linux/jbd.h>
>  # include <asm/div64.h>
>
>  #include <obd.h>
> diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
> index c99b945..049322a 100644
> --- a/drivers/staging/lustre/lustre/fld/fld_request.c
> +++ b/drivers/staging/lustre/lustre/fld/fld_request.c
> @@ -44,7 +44,6 @@
>
>  # include <linux/libcfs/libcfs.h>
>  # include <linux/module.h>
> -# include <linux/jbd.h>
>  # include <asm/div64.h>
>
>  #include <obd.h>
> diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
> index 426533b..c0156e3 100644
> --- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
> +++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
> @@ -111,12 +111,14 @@ static inline void ll_set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
>  #define TREE_READ_LOCK_IRQ(mapping)    spin_lock_irq(&(mapping)->tree_lock)
>  #define TREE_READ_UNLOCK_IRQ(mapping)  spin_unlock_irq(&(mapping)->tree_lock)
>
> +#ifdef CONFIG_BLOCK
>  static inline
>  int ll_unregister_blkdev(unsigned int dev, const char *name)
It is better to remove the wrapper and just call unregister_blkdev in
lloop.c. The wrapper exists to support old kernels in Lustre master
but doesn't make sense in upstream kernel.

Thanks,
Tao

>  {
>         unregister_blkdev(dev, name);
>         return 0;
>  }
> +#endif
>
>  #define ll_invalidate_bdev(a,b)         invalidate_bdev((a))
>
> diff --git a/drivers/staging/lustre/lustre/llite/Makefile b/drivers/staging/lustre/lustre/llite/Makefile
> index dff0c04..f493e07 100644
> --- a/drivers/staging/lustre/lustre/llite/Makefile
> +++ b/drivers/staging/lustre/lustre/llite/Makefile
> @@ -1,5 +1,5 @@
>  obj-$(CONFIG_LUSTRE_FS) += lustre.o
> -obj-$(CONFIG_LUSTRE_FS) += llite_lloop.o
> +obj-$(CONFIG_LUSTRE_LLITE_LLOOP) += llite_lloop.o
>  lustre-y := dcache.o dir.o file.o llite_close.o llite_lib.o llite_nfs.o \
>             rw.o lproc_llite.o namei.o symlink.o llite_mmap.o \
>             xattr.o remote_perm.o llite_rmtacl.o llite_capa.o \
> diff --git a/drivers/staging/lustre/lustre/lvfs/fsfilt.c b/drivers/staging/lustre/lustre/lvfs/fsfilt.c
> index 064445c..ce71f80 100644
> --- a/drivers/staging/lustre/lustre/lvfs/fsfilt.c
> +++ b/drivers/staging/lustre/lustre/lvfs/fsfilt.c
> @@ -35,7 +35,6 @@
>  #define DEBUG_SUBSYSTEM S_FILTER
>
>  #include <linux/fs.h>
> -#include <linux/jbd.h>
>  #include <linux/module.h>
>  #include <linux/kmod.h>
>  #include <linux/slab.h>
