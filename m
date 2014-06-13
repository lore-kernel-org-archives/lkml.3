Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaFMLnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:43:11 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:44121 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaFMLnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <1402606833-9825-2-git-send-email-keescook@chromium.org>
References: <1402606833-9825-1-git-send-email-keescook@chromium.org>
	<1402606833-9825-2-git-send-email-keescook@chromium.org>
Date: Fri, 13 Jun 2014 07:43:08 -0400
X-Google-Sender-Auth: 4BU0x1V-AzeM2mjhqRc7I5QjASE
Message-ID: <CA+5PVA5KpE8SX5tB3VsCXVaBm6P_-ZpLPZpBHqBS0cQ9ApzsPA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] hibernate: create "nohibernate" boot parameter
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Kees Cook <keescook@chromium.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86 <x86@kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-doc@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 5:00 PM, Kees Cook <keescook@chromium.org> wrote:
> To support using kernel features that are not compatible with hibernation,
> this creates the "nohibernate" kernel boot parameter to disable both
> hibernation and resume. This allows hibernation support to be a boot-time
> choice instead of only a compile-time choice.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

This looks really useful.  We have a similar mechanism in Fedora to
disable hibernation for Secure Boot purposes, but this is much more
generic.  Other than the rather minor comment below, I think it looks
good.

> ---
>  Documentation/kernel-parameters.txt |    3 +++
>  include/linux/suspend.h             |    2 ++
>  kernel/power/hibernate.c            |   31 ++++++++++++++++++++++++++++++-
>  kernel/power/main.c                 |    6 ++----
>  kernel/power/user.c                 |    3 +++
>  5 files changed, 40 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 6eaa9cdb7094..f8f0466b8b1d 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2184,6 +2184,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                         in certain environments such as networked servers or
>                         real-time systems.
>
> +       nohibernate     [HIBERNATION] Disable hibernation and resume.
> +
>         nohz=           [KNL] Boottime enable/disable dynamic ticks
>                         Valid arguments: on, off
>                         Default: on
> @@ -2980,6 +2982,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                 noresume        Don't check if there's a hibernation image
>                                 present during boot.
>                 nocompress      Don't compress/decompress hibernation images.
> +               no              Disable hibernation and resume.
>
>         retain_initrd   [RAM] Keep initrd memory after extraction
>
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index f76994b9396c..519064e0c943 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -327,6 +327,7 @@ extern unsigned long get_safe_page(gfp_t gfp_mask);
>  extern void hibernation_set_ops(const struct platform_hibernation_ops *ops);
>  extern int hibernate(void);
>  extern bool system_entering_hibernation(void);
> +extern bool hibernation_available(void);
>  asmlinkage int swsusp_save(void);
>  extern struct pbe *restore_pblist;
>  #else /* CONFIG_HIBERNATION */
> @@ -339,6 +340,7 @@ static inline void swsusp_unset_page_free(struct page *p) {}
>  static inline void hibernation_set_ops(const struct platform_hibernation_ops *ops) {}
>  static inline int hibernate(void) { return -ENOSYS; }
>  static inline bool system_entering_hibernation(void) { return false; }
> +static inline bool hibernation_available(void) { return false; }
>  #endif /* CONFIG_HIBERNATION */
>
>  /* Hibernation and suspend events */
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index df88d55dc436..fd3e785dbc37 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -34,6 +34,7 @@
>
>  static int nocompress;
>  static int noresume;
> +static int nohibernate;
>  static int resume_wait;
>  static unsigned int resume_delay;
>  static char resume_file[256] = CONFIG_PM_STD_PARTITION;
> @@ -61,6 +62,11 @@ bool freezer_test_done;
>
>  static const struct platform_hibernation_ops *hibernation_ops;
>
> +bool hibernation_available(void)
> +{
> +       return (nohibernate == 0);
> +}
> +
>  /**
>   * hibernation_set_ops - Set the global hibernate operations.
>   * @ops: Hibernation operations to use in subsequent hibernation transitions.
> @@ -639,6 +645,11 @@ int hibernate(void)
>  {
>         int error;
>
> +       if (!hibernation_available()) {
> +               pr_debug("PM: Hibernation not available.\n");
> +               return -EINVAL;
> +       }
> +
>         lock_system_sleep();
>         /* The snapshot device should not be opened while we're running */
>         if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
> @@ -731,7 +742,7 @@ static int software_resume(void)
>         /*
>          * If the user said "noresume".. bail out early.
>          */
> -       if (noresume)
> +       if (noresume || !hibernation_available())
>                 return 0;
>
>         /*
> @@ -897,6 +908,9 @@ static ssize_t disk_show(struct kobject *kobj, struct kobj_attribute *attr,
>         int i;
>         char *start = buf;
>
> +       if (!hibernation_available())
> +               return sprintf(buf, "[disabled]\n");
> +
>         for (i = HIBERNATION_FIRST; i <= HIBERNATION_MAX; i++) {
>                 if (!hibernation_modes[i])
>                         continue;
> @@ -931,6 +945,9 @@ static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
>         char *p;
>         int mode = HIBERNATION_INVALID;
>
> +       if (!hibernation_available())
> +               return -EINVAL;
> +

Similar to Pavel's comment, EINVAL works but isn't exactly clear.  We
use -EPERM in our current patch which might be more accurate.  I could
see arguments either way.

>         p = memchr(buf, '\n', n);
>         len = p ? p - buf : n;
>
> @@ -1098,6 +1115,10 @@ static int __init hibernate_setup(char *str)
>                 noresume = 1;
>         else if (!strncmp(str, "nocompress", 10))
>                 nocompress = 1;
> +       else if (!strncmp(str, "no", 2)) {
> +               noresume = 1;
> +               nohibernate = 1;
> +       }
>         return 1;
>  }
>
> @@ -1122,9 +1143,17 @@ static int __init resumedelay_setup(char *str)
>         return 1;
>  }
>
> +static int __init nohibernate_setup(char *str)
> +{
> +       noresume = 1;
> +       nohibernate = 1;
> +       return 1;
> +}
> +
>  __setup("noresume", noresume_setup);
>  __setup("resume_offset=", resume_offset_setup);
>  __setup("resume=", resume_setup);
>  __setup("hibernate=", hibernate_setup);
>  __setup("resumewait", resumewait_setup);
>  __setup("resumedelay=", resumedelay_setup);
> +__setup("nohibernate", nohibernate_setup);
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 573410d6647e..8e90f330f139 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -300,13 +300,11 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
>                         s += sprintf(s,"%s ", pm_states[i].label);
>
>  #endif
> -#ifdef CONFIG_HIBERNATION
> -       s += sprintf(s, "%s\n", "disk");
> -#else
> +       if (hibernation_available())
> +               s += sprintf(s, "disk ");
>         if (s != buf)
>                 /* convert the last space to a newline */
>                 *(s-1) = '\n';
> -#endif
>         return (s - buf);
>  }
>
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 98d357584cd6..000b94419182 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -49,6 +49,9 @@ static int snapshot_open(struct inode *inode, struct file *filp)
>         struct snapshot_data *data;
>         int error;
>
> +       if (!hibernation_available())
> +               return -EINVAL;
> +

Same comment as above.

josh
