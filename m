Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbaCZQeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:34:24 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:42407 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbaCZQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:34:22 -0400
MIME-Version: 1.0
In-Reply-To: <1395842441-17923-1-git-send-email-prarit@redhat.com>
References: <1395842441-17923-1-git-send-email-prarit@redhat.com>
Date: Wed, 26 Mar 2014 12:34:21 -0400
X-Google-Sender-Auth: 9cCJa6KzVL7pz1jPPf_yVdgJ02E
Message-ID: <CA+5PVA7vt6nBWfuU9V4UahHigy7=3d40rmPhSJvPv9F5J_n0ug@mail.gmail.com>
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 10:00 AM, Prarit Bhargava <prarit@redhat.com> wrote:
> When a module is built into the kernel, the modules's module_init()
> function becomes an initcall.  Debugging built in kernel modules is
> typically done by changing the .config, recompiling, and booting the new
> kernel in an effort to determine exactly which module caused a problem.
> This is a wasteful time consuming process as it may be repeated several times
> before determining precisely what caused the problem.
>
> This patch has been useful in identifying problems with built-in modules and
> initcalls.  It allows a user to skip an initcall to see if the kernel
> would continue to boot properly without requiring recompiles.
>
> Usage: initcall_blacklist=<initcall function>
>
> ex) added "initcall_blacklist=sgi_uv_sysfs_init" as a kernel parameter and
> the log contains:
>
>         blacklisted initcall sgi_uv_sysfs_init
>         ...
>         ...
>         function sgi_uv_sysfs_init returning without executing
>

Could you elaborate on cases where this would be more useful than
initcall_debug?  It seems odd to have one option to debug initicalls
already saying it's useful for working out where the kernel is dying
during startup, and then adding another option with the same goal.

> Cc: Rob Landley <rob@landley.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: linux-doc@vger.kernel.org
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> ---
>  Documentation/kernel-parameters.txt |    4 ++++
>  init/main.c                         |   16 ++++++++++++++++
>  2 files changed, 20 insertions(+)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 7116fda..dadc43b 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1268,6 +1268,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                         for working out where the kernel is dying during
>                         startup.
>
> +       initcall_blacklist=  [KNL] Stop executing the specified initcall
> +                       function.  Useful for debugging built-in modules and
> +                       initcalls.
> +
>         initrd=         [BOOT] Specify the location of the initial ramdisk
>
>         inport.irq=     [HW] Inport (ATI XL and Microsoft) busmouse driver
> diff --git a/init/main.c b/init/main.c
> index 9c7fd4c..a34677c 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -666,6 +666,15 @@ static void __init do_ctors(void)
>  bool initcall_debug;
>  core_param(initcall_debug, initcall_debug, bool, 0644);
>
> +static char blacklist_buf[128] = "\0";
> +static int initcall_blacklist(char *str)
> +{
> +       snprintf(blacklist_buf, 127, "%s", str);
> +       pr_debug("blacklisted initcall %s\n", blacklist_buf);
> +       return 0;
> +}
> +__setup("initcall_blacklist=", initcall_blacklist);
> +

I'm not trying to bikeshed, but this isn't so much a list as it is a
single initcall to skip.  Maybe call it initcall_skip ?  I can see
people doing something like
initcall_blacklist=sgi_uv_sysfs_init,foo_bar_init,baz_debug_init and
being confused when nothing is skipped because no single initcall
matches that literal string.

josh
