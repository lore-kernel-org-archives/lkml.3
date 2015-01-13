Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbbAMR6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:58:39 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:58655 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbbAMR6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:58:37 -0500
MIME-Version: 1.0
In-Reply-To: <1420566565-30531-1-git-send-email-salyzyn@android.com>
References: <1420566565-30531-1-git-send-email-salyzyn@android.com>
Date: Tue, 13 Jan 2015 09:58:36 -0800
X-Google-Sender-Auth: 8gvYNngZedvfGYBERu9U2-F31sI
Message-ID: <CAGXu5j+ESkVaz4S6X_JbcADP1174bgRH1+qdPYiYX8E8von3Vg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] pstore: add pmsg
From: Kees Cook <keescook@chromium.org>
To: Mark Salyzyn <salyzyn@android.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 9:49 AM, Mark Salyzyn <salyzyn@android.com> wrote:
> A secured user-space accessible pstore object. Writes
> to /dev/pmsg0 are appended to the buffer, on reboot
> the persistent contents are available in
> /sys/fs/pstore/pmsg-ramoops-[ID].
>
> One possible use is syslogd, or other daemon, can
> write messages, then on reboot provides a means to
> triage user-space activities leading up to a panic
> as a companion to the pstore dmesg or console logs.
>
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> ---
>  fs/pstore/Kconfig          |  10 +++++
>  fs/pstore/Makefile         |   2 +
>  fs/pstore/inode.c          |   3 ++
>  fs/pstore/internal.h       |   6 +++
>  fs/pstore/platform.c       |   1 +
>  fs/pstore/pmsg.c           | 101 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/pstore/ram.c            |  46 ++++++++++++++++++---
>  include/linux/pstore.h     |   1 +
>  include/linux/pstore_ram.h |   1 +
>  9 files changed, 166 insertions(+), 5 deletions(-)
>  create mode 100644 fs/pstore/pmsg.c
>
> diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
> index 983d951..916b8e2 100644
> --- a/fs/pstore/Kconfig
> +++ b/fs/pstore/Kconfig
> @@ -21,6 +21,16 @@ config PSTORE_CONSOLE
>           When the option is enabled, pstore will log all kernel
>           messages, even if no oops or panic happened.
>
> +config PSTORE_PMSG
> +       bool "Log user space messages"
> +       depends on PSTORE
> +       help
> +         When the option is enabled, pstore will export a character
> +         interface /dev/pmsg0 to log user space messages. On reboot
> +         data can be retrieved from /sys/fs/pstore/pmsg-ramoops-[ID].
> +
> +         If unsure, say N.
> +
>  config PSTORE_FTRACE
>         bool "Persistent function tracer"
>         depends on PSTORE
> diff --git a/fs/pstore/Makefile b/fs/pstore/Makefile
> index 4c9095c..e647d8e 100644
> --- a/fs/pstore/Makefile
> +++ b/fs/pstore/Makefile
> @@ -7,5 +7,7 @@ obj-y += pstore.o
>  pstore-objs += inode.o platform.o
>  obj-$(CONFIG_PSTORE_FTRACE)    += ftrace.o
>
> +obj-$(CONFIG_PSTORE_PMSG)      += pmsg.o
> +
>  ramoops-objs += ram.o ram_core.o
>  obj-$(CONFIG_PSTORE_RAM)       += ramoops.o
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index 1948567..a241d3e 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -361,6 +361,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>                 scnprintf(name, sizeof(name), "powerpc-common-%s-%lld",
>                           psname, id);
>                 break;
> +       case PSTORE_TYPE_PMSG:
> +               scnprintf(name, sizeof(name), "pmsg-%s-%lld", psname, id);
> +               break;
>         case PSTORE_TYPE_UNKNOWN:
>                 scnprintf(name, sizeof(name), "unknown-%s-%lld", psname, id);
>                 break;
> diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
> index 3b3d305..c36ba2c 100644
> --- a/fs/pstore/internal.h
> +++ b/fs/pstore/internal.h
> @@ -45,6 +45,12 @@ extern void pstore_register_ftrace(void);
>  static inline void pstore_register_ftrace(void) {}
>  #endif
>
> +#ifdef CONFIG_PSTORE_PMSG
> +extern void pstore_register_pmsg(void);
> +#else
> +static inline void pstore_register_pmsg(void) {}
> +#endif
> +
>  extern struct pstore_info *psinfo;
>
>  extern void    pstore_set_kmsg_bytes(int);
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 0a9b72c..15ee78c 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -447,6 +447,7 @@ int pstore_register(struct pstore_info *psi)
>         if ((psi->flags & PSTORE_FLAGS_FRAGILE) == 0) {
>                 pstore_register_console();
>                 pstore_register_ftrace();
> +               pstore_register_pmsg();
>         }
>
>         if (pstore_update_ms >= 0) {
> diff --git a/fs/pstore/pmsg.c b/fs/pstore/pmsg.c
> new file mode 100644
> index 0000000..d50d818
> --- /dev/null
> +++ b/fs/pstore/pmsg.c
> @@ -0,0 +1,101 @@
> +/*
> + * Copyright 2014  Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +#include <linux/fs.h>
> +#include <linux/uaccess.h>
> +#include "internal.h"
> +
> +static loff_t pmsg_lseek(struct file *file, loff_t offset, int orig)
> +{
> +       return file->f_pos = 0;
> +}
> +
> +static ssize_t write_pmsg(struct file *file, const char __user *buf,
> +                         size_t count, loff_t *ppos)
> +{
> +       size_t i;
> +
> +       if (!count)
> +               return 0;
> +
> +       if (!access_ok(VERIFY_READ, buf, count))
> +               return -EFAULT;
> +
> +       for (i = 0; i < count; ) {
> +               char buffer[512];

This feels like a lot of stack space to use for a buffer. Would it
maybe be better to either reduce the copy size or use a larger kmalloc
or vmalloc buffer to act as the bounce buffer to pass to write_buf?

> +               size_t c = min(count - i, sizeof(buffer));
> +               u64 id;
> +               long ret;
> +
> +               ret = __copy_from_user(buffer, buf + i, c);
> +               if (ret != 0)
> +                       return -EFAULT;
> +               psinfo->write_buf(PSTORE_TYPE_PMSG, 0, &id, 0, buffer, 0, c,
> +                                 psinfo);
> +
> +               i += c;
> +       }
> +       return count;
> +}
> +
> +static const struct file_operations pmsg_fops = {
> +       .owner          = THIS_MODULE,
> +       .llseek         = pmsg_lseek,
> +       .write          = write_pmsg,
> +};
> +
> +static struct class *pmsg_class;
> +static int pmsg_major;
> +#define PMSG_NAME "pmsg"
> +
> +static char *pmsg_devnode(struct device *dev, umode_t *mode)
> +{
> +       if (mode)
> +               *mode = 0220;
> +       return NULL;
> +}
> +
> +void pstore_register_pmsg(void)
> +{
> +       struct device *pmsg_device;
> +
> +       pmsg_major = register_chrdev(0, PMSG_NAME, &pmsg_fops);
> +       if (pmsg_major < 0) {
> +               pr_err("register_chrdev failed for pmsg\n");
> +               goto err;
> +       }
> +
> +       pmsg_class = class_create(THIS_MODULE, PMSG_NAME);
> +       if (IS_ERR(pmsg_class)) {
> +               pr_err("pmsg: device class file already in use\n");
> +               goto err_class;
> +       }
> +       pmsg_class->devnode = pmsg_devnode;
> +
> +       pmsg_device = device_create(pmsg_class, NULL, MKDEV(pmsg_major, 0),
> +                                       NULL, "%s%d", PMSG_NAME, 0);
> +       if (IS_ERR(pmsg_device)) {
> +               pr_err("pmsg: failed to create device\n");

Instead of mentioning pmsg directly here and in the pr_err()s above,
maybe set it via the pr_* defines:

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

And maybe use KBUILD_MODNAME instead of PMSG_NAME or vice versa?

> +               goto err_device;
> +       }
> +       return;
> +
> +err_device:
> +       class_destroy(pmsg_class);
> +err_class:
> +       unregister_chrdev(pmsg_major, PMSG_NAME);
> +err:
> +       return;
> +}
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 34ed8f8..39d1373 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -51,6 +51,10 @@ static ulong ramoops_ftrace_size = MIN_MEM_SIZE;
>  module_param_named(ftrace_size, ramoops_ftrace_size, ulong, 0400);
>  MODULE_PARM_DESC(ftrace_size, "size of ftrace log");
>
> +static ulong ramoops_pmsg_size = MIN_MEM_SIZE;
> +module_param_named(pmsg_size, ramoops_pmsg_size, ulong, 0400);
> +MODULE_PARM_DESC(pmsg_size, "size of user space message log");
> +
>  static ulong mem_address;
>  module_param(mem_address, ulong, 0400);
>  MODULE_PARM_DESC(mem_address,
> @@ -82,12 +86,14 @@ struct ramoops_context {
>         struct persistent_ram_zone **przs;
>         struct persistent_ram_zone *cprz;
>         struct persistent_ram_zone *fprz;
> +       struct persistent_ram_zone *mprz;
>         phys_addr_t phys_addr;
>         unsigned long size;
>         unsigned int memtype;
>         size_t record_size;
>         size_t console_size;
>         size_t ftrace_size;
> +       size_t pmsg_size;
>         int dump_oops;
>         struct persistent_ram_ecc_info ecc_info;
>         unsigned int max_dump_cnt;
> @@ -96,6 +102,7 @@ struct ramoops_context {
>         unsigned int dump_read_cnt;
>         unsigned int console_read_cnt;
>         unsigned int ftrace_read_cnt;
> +       unsigned int pmsg_read_cnt;
>         struct pstore_info pstore;
>  };
>
> @@ -109,6 +116,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
>         cxt->dump_read_cnt = 0;
>         cxt->console_read_cnt = 0;
>         cxt->ftrace_read_cnt = 0;
> +       cxt->pmsg_read_cnt = 0;
>         return 0;
>  }
>
> @@ -164,6 +172,12 @@ static int ramoops_read_kmsg_hdr(char *buffer, struct timespec *time,
>         return header_length;
>  }
>
> +static bool prz_ok(struct persistent_ram_zone *prz)
> +{
> +       return !!prz && !!(persistent_ram_old_size(prz) +
> +                          persistent_ram_ecc_string(prz, NULL, 0));
> +}

The addition of prz_ok() seems like a separate change?

> +
>  static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>                                    int *count, struct timespec *time,
>                                    char **buf, bool *compressed,
> @@ -178,13 +192,16 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>         prz = ramoops_get_next_prz(cxt->przs, &cxt->dump_read_cnt,
>                                    cxt->max_dump_cnt, id, type,
>                                    PSTORE_TYPE_DMESG, 1);
> -       if (!prz)
> +       if (!prz_ok(prz))
>                 prz = ramoops_get_next_prz(&cxt->cprz, &cxt->console_read_cnt,
>                                            1, id, type, PSTORE_TYPE_CONSOLE, 0);
> -       if (!prz)
> +       if (!prz_ok(prz))
>                 prz = ramoops_get_next_prz(&cxt->fprz, &cxt->ftrace_read_cnt,
>                                            1, id, type, PSTORE_TYPE_FTRACE, 0);
> -       if (!prz)
> +       if (!prz_ok(prz))
> +               prz = ramoops_get_next_prz(&cxt->mprz, &cxt->pmsg_read_cnt,
> +                                          1, id, type, PSTORE_TYPE_PMSG, 0);
> +       if (!prz_ok(prz))
>                 return 0;
>
>         if (!persistent_ram_old(prz))
> @@ -252,6 +269,11 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
>                         return -ENOMEM;
>                 persistent_ram_write(cxt->fprz, buf, size);
>                 return 0;
> +       } else if (type == PSTORE_TYPE_PMSG) {
> +               if (!cxt->mprz)
> +                       return -ENOMEM;
> +               persistent_ram_write(cxt->mprz, buf, size);
> +               return 0;
>         }
>
>         if (type != PSTORE_TYPE_DMESG)
> @@ -309,6 +331,9 @@ static int ramoops_pstore_erase(enum pstore_type_id type, u64 id, int count,
>         case PSTORE_TYPE_FTRACE:
>                 prz = cxt->fprz;
>                 break;
> +       case PSTORE_TYPE_PMSG:
> +               prz = cxt->mprz;
> +               break;
>         default:
>                 return -EINVAL;
>         }
> @@ -435,7 +460,7 @@ static int ramoops_probe(struct platform_device *pdev)
>                 goto fail_out;
>
>         if (!pdata->mem_size || (!pdata->record_size && !pdata->console_size &&
> -                       !pdata->ftrace_size)) {
> +                       !pdata->ftrace_size && !pdata->pmsg_size)) {
>                 pr_err("The memory size and the record/console size must be "
>                         "non-zero\n");
>                 goto fail_out;
> @@ -447,6 +472,8 @@ static int ramoops_probe(struct platform_device *pdev)
>                 pdata->console_size = rounddown_pow_of_two(pdata->console_size);
>         if (pdata->ftrace_size && !is_power_of_2(pdata->ftrace_size))
>                 pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
> +       if (pdata->pmsg_size && !is_power_of_2(pdata->pmsg_size))
> +               pdata->pmsg_size = rounddown_pow_of_two(pdata->pmsg_size);
>
>         cxt->size = pdata->mem_size;
>         cxt->phys_addr = pdata->mem_address;
> @@ -454,12 +481,14 @@ static int ramoops_probe(struct platform_device *pdev)
>         cxt->record_size = pdata->record_size;
>         cxt->console_size = pdata->console_size;
>         cxt->ftrace_size = pdata->ftrace_size;
> +       cxt->pmsg_size = pdata->pmsg_size;
>         cxt->dump_oops = pdata->dump_oops;
>         cxt->ecc_info = pdata->ecc_info;
>
>         paddr = cxt->phys_addr;
>
> -       dump_mem_sz = cxt->size - cxt->console_size - cxt->ftrace_size;
> +       dump_mem_sz = cxt->size - cxt->console_size - cxt->ftrace_size
> +                       - cxt->pmsg_size;
>         err = ramoops_init_przs(dev, cxt, &paddr, dump_mem_sz);
>         if (err)
>                 goto fail_out;
> @@ -474,6 +503,10 @@ static int ramoops_probe(struct platform_device *pdev)
>         if (err)
>                 goto fail_init_fprz;
>
> +       err = ramoops_init_prz(dev, cxt, &cxt->mprz, &paddr, cxt->pmsg_size, 0);
> +       if (err)
> +               goto fail_init_mprz;
> +
>         cxt->pstore.data = cxt;
>         /*
>          * Console can handle any buffer size, so prefer LOG_LINE_MAX. If we
> @@ -517,6 +550,8 @@ fail_buf:
>         kfree(cxt->pstore.buf);
>  fail_clear:
>         cxt->pstore.bufsize = 0;
> +       kfree(cxt->mprz);
> +fail_init_mprz:
>         kfree(cxt->fprz);
>  fail_init_fprz:
>         kfree(cxt->cprz);
> @@ -574,6 +609,7 @@ static void ramoops_register_dummy(void)
>         dummy_data->record_size = record_size;
>         dummy_data->console_size = ramoops_console_size;
>         dummy_data->ftrace_size = ramoops_ftrace_size;
> +       dummy_data->pmsg_size = ramoops_pmsg_size;
>         dummy_data->dump_oops = dump_oops;
>         /*
>          * For backwards compatibility ramoops.ecc=1 means 16 bytes ECC
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> index ece0c6b..8884f6e 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -39,6 +39,7 @@ enum pstore_type_id {
>         PSTORE_TYPE_PPC_RTAS    = 4,
>         PSTORE_TYPE_PPC_OF      = 5,
>         PSTORE_TYPE_PPC_COMMON  = 6,
> +       PSTORE_TYPE_PMSG        = 7,
>         PSTORE_TYPE_UNKNOWN     = 255
>  };
>
> diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
> index 4af3fdc..9c9d6c1 100644
> --- a/include/linux/pstore_ram.h
> +++ b/include/linux/pstore_ram.h
> @@ -81,6 +81,7 @@ struct ramoops_platform_data {
>         unsigned long   record_size;
>         unsigned long   console_size;
>         unsigned long   ftrace_size;
> +       unsigned long   pmsg_size;
>         int             dump_oops;
>         struct persistent_ram_ecc_info ecc_info;
>  };
> --
> 2.2.0.rc0.207.ga3a616c
>

Some nits above. Overall, this seems like a fine idea. Would it make
sense to enforce a single opener for these writes to avoid
interleaving?

-Kees

-- 
Kees Cook
Chrome OS Security
