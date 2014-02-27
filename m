Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaB0TCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:02:14 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:51202 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaB0TCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:02:08 -0500
MIME-Version: 1.0
In-Reply-To: <1393445473-15068-2-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<1393445473-15068-2-git-send-email-matthew.garrett@nebula.com>
Date: Thu, 27 Feb 2014 11:02:07 -0800
X-Google-Sender-Auth: HMz0ujNCmJnauqmCUcRd27wJL0s
Message-ID: <CAGXu5jK1d9jDcFcw52WL1DJdz6sSgGf6ZAU9jJ3VzEr397O3zQ@mail.gmail.com>
Subject: Re: [PATCH 01/12] Add support for indicating that the booted kernel
 is externally trusted
From: Kees Cook <keescook@chromium.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 12:11 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> Provide a boolean runtime configuration option for restricting userspace's
> ability to modify the running kernel. This can be used when some external
> validation of the kernel's state has been performed.
>
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  Documentation/kernel-parameters.txt       |   6 ++
>  Documentation/security/trusted_kernel.txt |  35 ++++++++++
>  include/linux/security.h                  |   8 +++
>  security/Kconfig                          |   9 +++
>  security/Makefile                         |   1 +
>  security/trusted_kernel.c                 | 111 ++++++++++++++++++++++++++++++
>  6 files changed, 170 insertions(+)
>  create mode 100644 Documentation/security/trusted_kernel.txt
>  create mode 100644 security/trusted_kernel.c
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 7116fda..d82ba9e 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3271,6 +3271,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                         with respect to transparent hugepages.
>                         See Documentation/vm/transhuge.txt for more details.
>
> +       trusted_kernel  Indicate that the booted kernel has been verified to
> +                       be trustworthy and that userspace should be forbidden
> +                       from modifying it at runtime.
> +                       See Documentation/security/trusted_kernel.txt for more
> +                       details.
> +
>         tsc=            Disable clocksource stability checks for TSC.
>                         Format: <string>
>                         [x86] reliable: mark tsc clocksource as reliable, this
> diff --git a/Documentation/security/trusted_kernel.txt b/Documentation/security/trusted_kernel.txt
> new file mode 100644
> index 0000000..538d21d
> --- /dev/null
> +++ b/Documentation/security/trusted_kernel.txt
> @@ -0,0 +1,35 @@
> +Linux trusted kernel support
> +----------------------------
> +
> +Various mechanisms exist to ensure that a booted kernel is trusted by the
> +user or some external party (UEFI Secure Boot, Intel TXT, embedded platform
> +bootloaders). If userspace is able to modify the running kernel then this
> +trust can be subverted.
> +
> +The trusted kernel support modifies certain kernel interfaces such that
> +userspace is restricted from performing acts that would allow it to inject
> +untrusted code into the kernel. Userspace will be unable to perform direct
> +access to PCI devices, port IO access, access system memory directly via
> +/dev/mem and /dev/kmem, perform kexec_load(), use the userspace software
> +suspend mechanism, insert new ACPI code at runtime via the custom_method
> +interface or modify CPU MSRs (on x86). Certain drivers may also limit
> +additional interfaces.
> +
> +The trusted kernel feature may be enabled in multiple ways:
> +
> +1) Platform-specific code may automatically enable it when it detects that
> +the system has been booted appropriately
> +
> +2) The user or bootloader may pass the "trusted_kernel" kernel parameter
> +
> +3) Userspace may write "1" to the /sys/kernel/security/trusted_kernel
> +node. This must be done sufficiently early in the boot process that
> +untrusted userspace has no opportunity to modify the kernel.
> +
> +Once enabled. trusted kernel support may not be disabled without rebooting
> +the system.
> +
> +Note that this is a mechanism for the kernel to determine whether or not
> +it is externally trusted. Untrusted userspace can enable this option even
> +if the kernel is not trusted, and therefore userspace should not use this
> +value as an indication of whether or not the kernel is trustworthy.
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 5623a7f..3415968 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -3091,6 +3091,14 @@ static inline void security_audit_rule_free(void *lsmrule)
>  #endif /* CONFIG_SECURITY */
>  #endif /* CONFIG_AUDIT */
>
> +#ifdef CONFIG_SECURITY_TRUSTED_KERNEL
> +extern bool get_trusted_kernel(void);
> +extern int set_trusted_kernel(bool new_trusted_kernel);
> +#else
> +static inline bool get_trusted_kernel(void) { return 0; }
> +static inline int set_trusted_kernel(bool new_trusted_kernel) { return 0; }

Should set_trusted_kernel return -ENOTSUPP when the config is off?

> +#endif /* CONFIG_TRUSTED_KERNEL */
> +
>  #ifdef CONFIG_SECURITYFS
>
>  extern struct dentry *securityfs_create_file(const char *name, umode_t mode,
> diff --git a/security/Kconfig b/security/Kconfig
> index beb86b5..c0462c9 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -70,6 +70,15 @@ config SECURITY_PATH
>           implement pathname based access controls.
>           If you are unsure how to answer this question, answer N.
>
> +config SECURITY_TRUSTED_KERNEL
> +        bool "Support for indicating that the kernel is trusted"
> +       depends on SECURITY
> +       help
> +         This enables support for adding a set of additional kernel security
> +         restrictions at runtime.
> +         See Documentation/security/trusted_kernel.txt for further
> +          information.
> +
>  config INTEL_TXT
>         bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
>         depends on HAVE_INTEL_TXT
> diff --git a/security/Makefile b/security/Makefile
> index a5918e0..72af305 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_MMU)                     += min_addr.o
>  # Object file lists
>  obj-$(CONFIG_SECURITY)                 += security.o capability.o
>  obj-$(CONFIG_SECURITYFS)               += inode.o
> +obj-$(CONFIG_SECURITY_TRUSTED_KERNEL)  += trusted_kernel.o
>  obj-$(CONFIG_SECURITY_SELINUX)         += selinux/built-in.o
>  obj-$(CONFIG_SECURITY_SMACK)           += smack/built-in.o
>  obj-$(CONFIG_AUDIT)                    += lsm_audit.o
> diff --git a/security/trusted_kernel.c b/security/trusted_kernel.c
> new file mode 100644
> index 0000000..2808113
> --- /dev/null
> +++ b/security/trusted_kernel.c
> @@ -0,0 +1,111 @@
> +/*
> + *  trusted_kernel.c - support for generic kernel lockdown
> + *
> + *  Copyright Nebula, Inc <matthew.garrett@nebula.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/security.h>
> +#include <linux/uaccess.h>
> +
> +static bool trusted_kernel;
> +
> +bool get_trusted_kernel(void)
> +{
> +       return trusted_kernel;
> +}
> +EXPORT_SYMBOL(get_trusted_kernel);
> +
> +int set_trusted_kernel(bool new_trusted_kernel)
> +{
> +       if (trusted_kernel == true && new_trusted_kernel == false)
> +               return -EINVAL;
> +
> +       trusted_kernel = new_trusted_kernel;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(set_trusted_kernel);
> +
> +static ssize_t trusted_kernel_read(struct file *filp, char __user *buf,
> +                                  size_t count, loff_t *ppos)
> +{
> +       char tmpbuf[2];
> +       ssize_t length;
> +
> +       length = scnprintf(tmpbuf, sizeof(tmpbuf), "%d", trusted_kernel);
> +       return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> +}
> +
> +static ssize_t trusted_kernel_write(struct file *file, const char __user *buf,
> +                                   size_t count, loff_t *ppos)
> +{
> +       char *page = NULL;
> +       ssize_t length;
> +       int new_trusted_kernel;
> +
> +       length = -ENOMEM;
> +       if (count >= PAGE_SIZE)
> +               goto out;
> +
> +       length = -EINVAL;
> +       if (*ppos != 0)
> +               goto out;
> +
> +       length = -ENOMEM;
> +       page = (char *)get_zeroed_page(GFP_KERNEL);
> +       if (!page)
> +               goto out;
> +
> +       length = -EFAULT;
> +       if (copy_from_user(page, buf, count))
> +               goto out;
> +
> +       length = -EINVAL;
> +       if (sscanf(page, "%d", &new_trusted_kernel) != 1)
> +               goto out;
> +
> +       length = set_trusted_kernel(!!new_trusted_kernel);
> +       if (length)
> +               goto out;
> +
> +       length = count;
> +out:
> +       free_page((unsigned long) page);
> +       return length;
> +}
> +
> +static const struct file_operations trusted_kernel_fops = {
> +       .read   = trusted_kernel_read,
> +       .write  = trusted_kernel_write,
> +       .llseek = generic_file_llseek,
> +};
> +
> +static __init int setup_trusted_kernel(void)
> +{
> +       struct dentry *trusted_kernel_file;
> +
> +       trusted_kernel_file = securityfs_create_file("trusted_kernel",
> +                                                    S_IWUSR | S_IRUGO,
> +                                                    NULL, NULL,
> +                                                    &trusted_kernel_fops);
> +
> +       if (IS_ERR(trusted_kernel_file))
> +               return PTR_ERR(trusted_kernel_file);
> +
> +       return 0;
> +}
> +late_initcall(setup_trusted_kernel);
> +
> +static int __init enable_trusted_kernel(char *__str)
> +{
> +       trusted_kernel = true;
> +       return 1;
> +}
> +__setup("trusted_kernel", enable_trusted_kernel);
> --
> 1.8.5.3
>

Thanks for reposting this. I'm looking forward to adding
"trusted_kernel" to the Chrome OS kernel cmdline. :)

Please consider the series:

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
