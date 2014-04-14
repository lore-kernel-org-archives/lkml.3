Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaDNV3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:29:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbaDNV3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:29:16 -0400
Date: Mon, 14 Apr 2014 14:29:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Boyer <jwboyer@fedoraproject.org>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter [v4]
Message-Id: <20140414142914.57110976dd96134875b63639@linux-foundation.org>
In-Reply-To: <1396365545-12279-1-git-send-email-prarit@redhat.com>
References: <1396365545-12279-1-git-send-email-prarit@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Apr 2014 11:19:05 -0400 Prarit Bhargava <prarit@redhat.com> wrote:

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
> 	blacklisted initcall sgi_uv_sysfs_init
> 	...
> 	...
> 	function sgi_uv_sysfs_init returning without executing
> 
> ex) added "initcall_blacklist=foo_bar,sgi_uv_sysfs_init" as a kernel parameter
> and the log contains:
> 
> 	initcall blacklisted foo_bar
> 	initcall blacklisted sgi_uv_sysfs_init
> 	...
> 	...
> 	function sgi_uv_sysfs_init returning without executing

I guess the idea is reasonable and can be implemented very cheaply.

> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1275,6 +1275,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			for working out where the kernel is dying during
>  			startup.
>  
> +	initcall_blacklist=  [KNL] Do not execute a comma-separated list of
> +			initcall functions.  Useful for debugging built-in
> +			modules and initcalls.


>  	initrd=		[BOOT] Specify the location of the initial ramdisk
>  
>  	inport.irq=	[HW] Inport (ATI XL and Microsoft) busmouse driver
> diff --git a/init/main.c b/init/main.c
> index 9c7fd4c..e050c24 100644
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
> @@ -666,6 +667,42 @@ static void __init do_ctors(void)
>  bool initcall_debug;
>  core_param(initcall_debug, initcall_debug, bool, 0644);
>  
> +struct blacklist_entry {
> +	struct list_head next;
> +	char *buf;
> +};
> +
> +static __initdata_or_module LIST_HEAD(blacklisted_initcalls);

I suggest this be moved inside #ifdef CONFIG_KALLSYMS, then add

#ifdef CONFIG_KALLSYMS
static bool initcall_blacklisted(const char *id)
{
	...
}
#else
static bool initcall_blacklisted(const char *id)
{
	return false;
}
#endif

than call that from do_one_initcall().

> +#ifdef CONFIG_KALLSYMS
> +static int __init initcall_blacklist(char *str)
> +{
> +	char *str_entry;
> +	struct blacklist_entry *entry;
> +
> +	/* str argument is a comma-separated list of functions */
> +	do {
> +		str_entry = strsep(&str, ",");
> +		if (str_entry) {
> +			pr_debug("initcall blacklisted %s \n", str_entry);
> +			entry = alloc_bootmem(sizeof(*entry));
> +			entry->buf = alloc_bootmem(strlen(str_entry));

This needs to be strlen()+1.

> +			strncpy(entry->buf, str_entry, strlen(str_entry));

and strcpy().

Or add a new strdup_bootmem() if it looks like there are (or will be)
other callers.

> +			list_add(&entry->next, &blacklisted_initcalls);
> +		}
> +	} while (str_entry);
> +
> +	return 0;
> +}
> +#else
> +static int __init initcall_blacklist(char *str)
> +{
> +	pr_warning("initcall_blacklist requires CONFIG_KALLSYMS to be enabled.\n");

"initcall_blacklist requires CONFIG_KALLSYMS" is sufficient.

> +	return 0;
> +}
> +#endif
> +__setup("initcall_blacklist=", initcall_blacklist);
> +
>  static int __init_or_module do_one_initcall_debug(initcall_t fn)
>  {
>  	ktime_t calltime, delta, rettime;
> @@ -689,6 +726,19 @@ int __init_or_module do_one_initcall(initcall_t fn)
>  	int count = preempt_count();
>  	int ret;
>  	char msgbuf[64];
> +	char fn_name[128] = "\0";
> +	struct list_head *tmp;
> +	struct blacklist_entry *entry;
> +
> +	snprintf(fn_name, 128, "%pf", fn);

Remove fn_name[], use kasprintf(), remember to free it.

> +	list_for_each(tmp, &blacklisted_initcalls) {
> +		entry = list_entry(tmp, struct blacklist_entry, next);
> +		if (!strcmp(fn_name, entry->buf)) {
> +			pr_debug("initcall %pf returning without executing\n",

"foo returning without executing" is contradictory: how can it return
if it didn't execute?  I suggest something like "skipping blacklisted
initcall %pf".

> +				 fn);
> +			return -EPERM;
> +		}
> +	}

Let's not leak all those blacklist entries when we're finished?

