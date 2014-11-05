Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaKEV7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:59:25 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49671 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaKEV7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:59:21 -0500
Date: Wed, 5 Nov 2014 13:59:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, vgoyal@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, jbaron@akamai.com,
        linux-doc@vger.kernel.org, kexec@lists.infradead.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v8] kernel, add panic_on_warn
In-Reply-To: <1415187736-16242-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.10.1411051357050.31575@chino.kir.corp.google.com>
References: <1415187736-16242-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014, Prarit Bhargava wrote:

> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index 6c0b9f2..bc4bd5a 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -471,6 +471,13 @@ format. Crash is available on Dave Anderson's site at the following URL:
>  
>     http://people.redhat.com/~anderson/
>  
> +Trigger Kdump on WARN()
> +=======================
> +
> +The kernel parameter, panic_on_warn, calls panic() in all WARN() paths.  This
> +will cause a kdump to occur at the panic() call.  In cases where a user wants
> +to specify this during runtime, /proc/sys/kernel/panic_on_warn can be set to 1
> +to achieve the same behaviour.
>  
>  Contact
>  =======
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4c81a86..ea5d57c 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2509,6 +2509,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			timeout < 0: reboot immediately
>  			Format: <timeout>
>  
> +	panic_on_warn	panic() instead of WARN().  Useful to cause kdump
> +			on a WARN().
> +
>  	crash_kexec_post_notifiers
>  			Run kdump after running panic-notifiers and dumping
>  			kmsg. This only for the users who doubt kdump always
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 57baff5..b5d0c85 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -54,8 +54,9 @@ show up in /proc/sys/kernel:
>  - overflowuid
>  - panic
>  - panic_on_oops
> -- panic_on_unrecovered_nmi
>  - panic_on_stackoverflow
> +- panic_on_unrecovered_nmi
> +- panic_on_warn
>  - pid_max
>  - powersave-nap               [ PPC only ]
>  - printk
> @@ -527,19 +528,6 @@ the recommended setting is 60.
>  
>  ==============================================================
>  
> -panic_on_unrecovered_nmi:
> -
> -The default Linux behaviour on an NMI of either memory or unknown is
> -to continue operation. For many environments such as scientific
> -computing it is preferable that the box is taken out and the error
> -dealt with than an uncorrected parity/ECC error get propagated.
> -
> -A small number of systems do generate NMI's for bizarre random reasons
> -such as power management so the default is off. That sysctl works like
> -the existing panic controls already in that directory.
> -
> -==============================================================
> -
>  panic_on_oops:
>  
>  Controls the kernel's behaviour when an oops or BUG is encountered.
> @@ -563,6 +551,30 @@ This file shows up if CONFIG_DEBUG_STACKOVERFLOW is enabled.
>  
>  ==============================================================
>  
> +panic_on_unrecovered_nmi:
> +
> +The default Linux behaviour on an NMI of either memory or unknown is
> +to continue operation. For many environments such as scientific
> +computing it is preferable that the box is taken out and the error
> +dealt with than an uncorrected parity/ECC error get propagated.
> +
> +A small number of systems do generate NMI's for bizarre random reasons
> +such as power management so the default is off. That sysctl works like
> +the existing panic controls already in that directory.
> +
> +==============================================================
> +
> +panic_on_warn:
> +
> +Calls panic() in the WARN() path when set to 1.  This is useful to avoid
> +a kernel rebuild when attempting to kdump at the location of a WARN().
> +
> +0: only WARN(), default behaviour.
> +
> +1: call panic() after printing out WARN() location.
> +
> +==============================================================
> +
>  perf_cpu_time_max_percent:
>  
>  Hints to the kernel how much CPU time it should be allowed to
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 3d770f55..d60d31d 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -422,6 +422,7 @@ extern int panic_timeout;
>  extern int panic_on_oops;
>  extern int panic_on_unrecovered_nmi;
>  extern int panic_on_io_nmi;
> +extern int panic_on_warn;
>  extern int sysctl_panic_on_stackoverflow;
>  /*
>   * Only to be used by arch init code. If the user over-wrote the default
> diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
> index 43aaba1..0956373 100644
> --- a/include/uapi/linux/sysctl.h
> +++ b/include/uapi/linux/sysctl.h
> @@ -153,6 +153,7 @@ enum
>  	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
> +	KERN_PANIC_ON_WARN=77, /* int: call panic() in WARN() functions */
>  };
>  
>  
> diff --git a/kernel/panic.c b/kernel/panic.c
> index d09dc5c..c6a7723 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -33,6 +33,7 @@ static int pause_on_oops;
>  static int pause_on_oops_flag;
>  static DEFINE_SPINLOCK(pause_on_oops_lock);
>  static bool crash_kexec_post_notifiers;
> +int panic_on_warn __read_mostly;
>  
>  int panic_timeout = CONFIG_PANIC_TIMEOUT;
>  EXPORT_SYMBOL_GPL(panic_timeout);
> @@ -420,13 +421,23 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
>  {
>  	disable_trace_on_warning();
>  
> -	pr_warn("------------[ cut here ]------------\n");
> +	if (!panic_on_warn)
> +		pr_warn("------------[ cut here ]------------\n");

Is this really necessary?

>  	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
>  		raw_smp_processor_id(), current->pid, file, line, caller);
>  
>  	if (args)
>  		vprintk(args->fmt, args->args);
>  
> +	if (panic_on_warn) {
> +		/*
> +		 * A flood of WARN()s may occur.  Prevent further WARN()s
> +		 * from panicking the system.
> +		 */

What synchronization is preventing this race and further WARN()s panicking 
the system?

> +		panic_on_warn = 0;
> +		panic("panic_on_warn set ...\n");
> +	}
> +
>  	print_modules();
>  	dump_stack();
>  	print_oops_end_marker();
