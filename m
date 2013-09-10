Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3IJW55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:57:57 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46429 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3IJW5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <1378849471-10521-15-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
	<1378849471-10521-15-git-send-email-vgoyal@redhat.com>
Date: Tue, 10 Sep 2013 18:57:55 -0400
X-Google-Sender-Auth: nKAk0C9PAVYmku7LgMyhZ2GoouY
Message-ID: <CA+5PVA7seT-Au6Qsr-svbG38-ohCUrw2=W6CoO5XWqy2Avjg6A@mail.gmail.com>
Subject: Re: [PATCH 14/16] kexec: Export sysfs attributes for secureboot and
 secure modules to user space
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        kexec <kexec@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, d.kasatkin@samsung.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 5:44 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> User space kexec-tools need to know whether to verify signature of kernel
> image being loaded. This patch exports two knobs to user space. One is
> for knowing if  secureboot is enabled, this knob will be set to 1 if secure
> boot is enabled. Other knob is secure_module_enabled. This knob will be set
> to 1 if secure modules is one.
>
> kexec-tools will verify signature of kernel image if either secureboot is
> enabled or secure modules is enabled. The only difference between two is
> that kexec-tools will set secureboot on in bootparams being passed to
> second kernel if secureboot is on in first kernel.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  kernel/ksysfs.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
> index 6ada93c..7262245 100644
> --- a/kernel/ksysfs.c
> +++ b/kernel/ksysfs.c
> @@ -18,6 +18,8 @@
>  #include <linux/stat.h>
>  #include <linux/sched.h>
>  #include <linux/capability.h>
> +#include <linux/efi.h>
> +#include <linux/module.h>
>
>  #define KERNEL_ATTR_RO(_name) \
>  static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
> @@ -101,6 +103,25 @@ static ssize_t kexec_crash_loaded_show(struct kobject *kobj,
>  }
>  KERNEL_ATTR_RO(kexec_crash_loaded);
>
> +static ssize_t secureboot_enabled_show(struct kobject *kobj,
> +                                      struct kobj_attribute *attr, char *buf)
> +{
> +       /* TODO: Change it once secureboot patches are in */
> +       return sprintf(buf, "%d\n", 1);
> +}
> +KERNEL_ATTR_RO(secureboot_enabled);

You're defaulting this to enabled, even on machines where SB isn't
possible.  I realize there are TODOs there, but you might want to
default it to off if you really intend this on going upstream before
any of the other secure_* infrastructure does.

> +
> +static ssize_t secure_modules_enabled_show(struct kobject *kobj,
> +                                      struct kobj_attribute *attr, char *buf)
> +{
> +       /*
> +        * TODO: Change it once secure_modules() or secure_level() patches
> +        * are in
> +        */
> +       return sprintf(buf, "%d\n", 1);
> +}
> +KERNEL_ATTR_RO(secure_modules_enabled);
> +

Similarly, this should either default to off, or just return the value
of sig_enforce.  You can replace the open coded sig_enforce with
secure_modules if/when it goes upstream.

josh
