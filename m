Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaDAObZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:31:25 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55913 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaDAObX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:31:23 -0400
MIME-Version: 1.0
In-Reply-To: <1396360701-27197-1-git-send-email-prarit@redhat.com>
References: <1396360701-27197-1-git-send-email-prarit@redhat.com>
Date: Tue, 1 Apr 2014 16:31:22 +0200
Message-ID: <CAFLxGvwMpNRfmJAGJ-961J5-mOy=X0QHZWzyHfQi3J8Gu7o7OQ@mail.gmail.com>
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter [v3]
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Josh Boyer <jwboyer@fedoraproject.org>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 3:58 PM, Prarit Bhargava <prarit@redhat.com> wrote:
> When a module is built into the kernel the module_init() function becomes
> an initcall.  Sometimes debugging through dynamic debug can help,
> however, debugging built in kernel modules is typically done by changing
> the .config, recompiling, and booting the new kernel in an effort to
> determine exactly which module caused a problem.
>
> This patchset can be useful stand-alone or combined with initcall_debug.
> There are cases where some initcalls can hang the machine before the
> console can be flushed, which can make initcall_debug output
> inaccurate.  Having the ability to skip initcalls can help further
> debugging of these scenarios.
>
> Usage: initcall_blacklist=<list of comma separated initcalls>
>
> ex) added "initcall_blacklist=sgi_uv_sysfs_init" as a kernel parameter and
> the log contains:
>
>         blacklisted initcall sgi_uv_sysfs_init
>         ...
>         ...
>         function sgi_uv_sysfs_init returning without executing
>
> ex) added "initcall_blacklist=foo_bar,sgi_uv_sysfs_init" as a kernel parameter
> and the log contains:
>
>         initcall blacklisted foo_bar
>         initcall blacklisted sgi_uv_sysfs_init
>         ...
>         ...
>         function sgi_uv_sysfs_init returning without executing
>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Josh Boyer <jwboyer@fedoraproject.org>
> Cc: Rob Landley <rob@landley.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: linux-doc@vger.kernel.org
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>
> [v2]: A few people recommended that I add code to allow for a list of
> initcalls as there maybe dependencies between initcalls such that one cannot
> be made without the other.  I also updated the patch description.
> [v3]: Drop memory cleanup, suggested by Andi Kleen.
> ---
>  Documentation/kernel-parameters.txt |    4 ++++
>  init/main.c                         |   42 +++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 67755ea..ebeb8a5 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1275,6 +1275,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                         for working out where the kernel is dying during
>                         startup.
>
> +       initcall_blacklist=  [KNL] Do not execute a comma-separated list of
> +                       initcall functions.  Useful for debugging built-in
> +                       modules and initcalls.
> +
>         initrd=         [BOOT] Specify the location of the initial ramdisk
>
>         inport.irq=     [HW] Inport (ATI XL and Microsoft) busmouse driver
> diff --git a/init/main.c b/init/main.c
> index 9c7fd4c..64a3b8b 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -77,6 +77,7 @@
>  #include <linux/sched_clock.h>
>  #include <linux/context_tracking.h>
>  #include <linux/random.h>
> +#include <linux/list.h>
>
>  #include <asm/io.h>
>  #include <asm/bugs.h>
> @@ -666,6 +667,34 @@ static void __init do_ctors(void)
>  bool initcall_debug;
>  core_param(initcall_debug, initcall_debug, bool, 0644);
>
> +struct blacklist_entry {
> +       struct list_head next;
> +       char *buf;
> +};
> +
> +static __initdata_or_module LIST_HEAD(blacklisted_initcalls);
> +
> +static int __init initcall_blacklist(char *str)
> +{
> +       char *str_entry;
> +       struct blacklist_entry *entry;
> +
> +       /* str argument is a comma-separated list of functions */
> +       do {
> +               str_entry = strsep(&str, ",");
> +               if (str_entry) {
> +                       pr_debug("initcall blacklisted %s \n", str_entry);
> +                       entry = alloc_bootmem(sizeof(*entry));
> +                       entry->buf = alloc_bootmem(strlen(str_entry));
> +                       strncpy(entry->buf, str_entry, strlen(str_entry));
> +                       list_add(&entry->next, &blacklisted_initcalls);
> +               }
> +       } while (str_entry);
> +
> +       return 0;
> +}
> +__setup("initcall_blacklist=", initcall_blacklist);

Wouldn't it make sense to make this feature depend on CONFIG_KALLSYMS?
I.e. Making it a nop plus a warning if one uses initcall_blacklist and
has CONFIG_KALLSYMS=n.

>  static int __init_or_module do_one_initcall_debug(initcall_t fn)
>  {
>         ktime_t calltime, delta, rettime;
> @@ -689,6 +718,19 @@ int __init_or_module do_one_initcall(initcall_t fn)
>         int count = preempt_count();
>         int ret;
>         char msgbuf[64];
> +       char fn_name[128] = "\0";
> +       struct list_head *tmp;
> +       struct blacklist_entry *entry;
> +
> +       snprintf(fn_name, 128, "%pf", fn);
> +       list_for_each(tmp, &blacklisted_initcalls) {
> +               entry = list_entry(tmp, struct blacklist_entry, next);
> +               if (!strcmp(fn_name, entry->buf)) {
> +                       pr_debug("initcall %pf returning without executing\n",
> +                                fn);
> +                       return -EPERM;
> +               }
> +       }
>
>         if (initcall_debug)
>                 ret = do_one_initcall_debug(fn);
> --
> 1.7.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
