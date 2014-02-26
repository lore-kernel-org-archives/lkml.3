Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaBZUkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:40:18 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:14743 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750999AbaBZUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:40:17 -0500
Date: Wed, 26 Feb 2014 15:40:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140226154012.7985f91c@gandalf.local.home>
In-Reply-To: <1392355106-26104-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1392355106-26104-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu, you should have added a v2 to the subject ie: [PATCH V2]

Rusty,

If you want to take this, please add my
Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


On Fri, 14 Feb 2014 00:18:26 -0500
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Users have reported being unable to trace non-signed modules loaded
> within a kernel supporting module signature.
> 
> This is caused by tracepoint.c:tracepoint_module_coming() refusing to
> take into account tracepoints sitting within force-loaded modules
> (TAINT_FORCED_MODULE). The reason for this check, in the first place, is
> that a force-loaded module may have a struct module incompatible with
> the layout expected by the kernel, and can thus cause a kernel crash
> upon forced load of that module on a kernel with CONFIG_TRACEPOINTS=y.
> 
> Tracepoints, however, specifically accept TAINT_OOT_MODULE and
> TAINT_CRAP, since those modules do not lead to the "very likely system
> crash" issue cited above for force-loaded modules.
> 
> With kernels having CONFIG_MODULE_SIG=y (signed modules), a non-signed
> module is tainted re-using the TAINT_FORCED_MODULE taint flag.
> Unfortunately, this means that Tracepoints treat that module as a
> force-loaded module, and thus silently refuse to consider any tracepoint
> within this module.
> 
> Since an unsigned module does not fit within the "very likely system
> crash" category of tainting, add a new TAINT_UNSIGNED_MODULE taint flag
> to specifically address this taint behavior, and accept those modules
> within Tracepoints. We use the letter 'X' as a taint flag character for
> a module being loaded that doesn't know how to sign its name (proposed
> by Steven Rostedt).
> 
> Also add the missing 'O' entry to trace event show_module_flags() list
> for the sake of completeness.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: David Howells <dhowells@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  Documentation/ABI/testing/sysfs-module |    1 +
>  Documentation/module-signing.txt       |    3 ++-
>  Documentation/oops-tracing.txt         |    3 +++
>  Documentation/sysctl/kernel.txt        |    2 ++
>  include/linux/kernel.h                 |    1 +
>  include/trace/events/module.h          |    4 +++-
>  kernel/module.c                        |    4 +++-
>  kernel/panic.c                         |    2 ++
>  kernel/tracepoint.c                    |    5 +++--
>  9 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-module b/Documentation/ABI/testing/sysfs-module
> index 47064c2..b9a29cd 100644
> --- a/Documentation/ABI/testing/sysfs-module
> +++ b/Documentation/ABI/testing/sysfs-module
> @@ -49,3 +49,4 @@ Description:	Module taint flags:
>  			O - out-of-tree module
>  			F - force-loaded module
>  			C - staging driver module
> +			X - unsigned module
> diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
> index 2b40e04..b6af42e 100644
> --- a/Documentation/module-signing.txt
> +++ b/Documentation/module-signing.txt
> @@ -53,7 +53,8 @@ This has a number of options available:
>  
>       If this is off (ie. "permissive"), then modules for which the key is not
>       available and modules that are unsigned are permitted, but the kernel will
> -     be marked as being tainted.
> +     be marked as being tainted, and the concerned modules will be marked as
> +     tainted, shown with the character 'X'.
>  
>       If this is on (ie. "restrictive"), only modules that have a valid
>       signature that can be verified by a public key in the kernel's possession
> diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
> index 13032c0..879abe2 100644
> --- a/Documentation/oops-tracing.txt
> +++ b/Documentation/oops-tracing.txt
> @@ -265,6 +265,9 @@ characters, each representing a particular tainted value.
>  
>   13: 'O' if an externally-built ("out-of-tree") module has been loaded.
>  
> + 14: 'X' if an unsigned module has been loaded in a kernel supporting
> +     module signature.
> +
>  The primary reason for the 'Tainted: ' string is to tell kernel
>  debuggers if this is a clean kernel or if anything unusual has
>  occurred.  Tainting is permanent: even if an offending module is
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index e55124e..8ebe1c0 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -792,6 +792,8 @@ can be ORed together:
>  1024 - A module from drivers/staging was loaded.
>  2048 - The system is working around a severe firmware bug.
>  4096 - An out-of-tree module has been loaded.
> +8192 - An unsigned module has been loaded in a kernel supporting module
> +       signature.
>  
>  ==============================================================
>  
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 196d1ea..4710900 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -469,6 +469,7 @@ extern enum system_states {
>  #define TAINT_CRAP			10
>  #define TAINT_FIRMWARE_WORKAROUND	11
>  #define TAINT_OOT_MODULE		12
> +#define TAINT_UNSIGNED_MODULE		13
>  
>  extern const char hex_asc[];
>  #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
> diff --git a/include/trace/events/module.h b/include/trace/events/module.h
> index 1619327..11fd51b 100644
> --- a/include/trace/events/module.h
> +++ b/include/trace/events/module.h
> @@ -22,8 +22,10 @@ struct module;
>  
>  #define show_module_flags(flags) __print_flags(flags, "",	\
>  	{ (1UL << TAINT_PROPRIETARY_MODULE),	"P" },		\
> +	{ (1UL << TAINT_OOT_MODULE),		"O" },		\
>  	{ (1UL << TAINT_FORCED_MODULE),		"F" },		\
> -	{ (1UL << TAINT_CRAP),			"C" })
> +	{ (1UL << TAINT_CRAP),			"C" },		\
> +	{ (1UL << TAINT_UNSIGNED_MODULE),	"X" })
>  
>  TRACE_EVENT(module_load,
>  
> diff --git a/kernel/module.c b/kernel/module.c
> index d24fcf2..4d7d25e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1013,6 +1013,8 @@ static size_t module_flags_taint(struct module *mod, char *buf)
>  		buf[l++] = 'F';
>  	if (mod->taints & (1 << TAINT_CRAP))
>  		buf[l++] = 'C';
> +	if (mod->taints & (1 << TAINT_UNSIGNED_MODULE))
> +		buf[l++] = 'X';
>  	/*
>  	 * TAINT_FORCED_RMMOD: could be added.
>  	 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
> @@ -3214,7 +3216,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  		pr_notice_once("%s: module verification failed: signature "
>  			       "and/or  required key missing - tainting "
>  			       "kernel\n", mod->name);
> -		add_taint_module(mod, TAINT_FORCED_MODULE, LOCKDEP_STILL_OK);
> +		add_taint_module(mod, TAINT_UNSIGNED_MODULE, LOCKDEP_STILL_OK);
>  	}
>  #endif
>  
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 6d63003..0e25fe1 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -210,6 +210,7 @@ static const struct tnt tnts[] = {
>  	{ TAINT_CRAP,			'C', ' ' },
>  	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
>  	{ TAINT_OOT_MODULE,		'O', ' ' },
> +	{ TAINT_UNSIGNED_MODULE,	'X', ' ' },
>  };
>  
>  /**
> @@ -228,6 +229,7 @@ static const struct tnt tnts[] = {
>   *  'C' - modules from drivers/staging are loaded.
>   *  'I' - Working around severe firmware bug.
>   *  'O' - Out-of-tree module has been loaded.
> + *  'X' - Unsigned module has been loaded.
>   *
>   *	The string is overwritten by the next call to print_tainted().
>   */
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 29f2654..9bb887d 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -639,9 +639,10 @@ static int tracepoint_module_coming(struct module *mod)
>  	/*
>  	 * We skip modules that taint the kernel, especially those with different
>  	 * module headers (for forced load), to make sure we don't cause a crash.
> -	 * Staging and out-of-tree GPL modules are fine.
> +	 * Staging, out-of-tree, and unsigned GPL modules are fine.
>  	 */
> -	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
> +	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP) |
> +			(1 << TAINT_UNSIGNED_MODULE)))
>  		return 0;
>  	mutex_lock(&tracepoints_mutex);
>  	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);

