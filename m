Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaF0Xoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:44:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53767 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753454AbaF0Xof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:44:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 02/27] PM / Sleep: Remove ftrace_stop/start() from suspend and hibernate
Date: Sat, 28 Jun 2014 02:02:24 +0200
Message-ID: <1518201.VD9cU33jRU@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140626165848.128028586@goodmis.org>
References: <20140626165221.736847419@goodmis.org> <20140626165848.128028586@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 26, 2014 12:52:23 PM Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> ftrace_stop() and ftrace_start() were added to the suspend and hibernate
> process because there was some function within the work flow that caused
> the system to reboot if it was traced. This function has recently been
> found (restore_processor_state()). Now there's no reason to disable
> function tracing while we are going into suspend or hibernate, which means
> that being able to trace this will help tremendously in debugging any
> issues with suspend or hibernate.
> 
> This also means that the ftrace_stop/start() functions can be removed
> and simplify the function tracing code a bit.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

ACK

> ---
>  kernel/power/hibernate.c | 6 ------
>  kernel/power/suspend.c   | 2 --
>  2 files changed, 8 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 49e0a20fd010..ca7b1906c6c8 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -365,7 +365,6 @@ int hibernation_snapshot(int platform_mode)
>  	}
>  
>  	suspend_console();
> -	ftrace_stop();
>  	pm_restrict_gfp_mask();
>  
>  	error = dpm_suspend(PMSG_FREEZE);
> @@ -391,7 +390,6 @@ int hibernation_snapshot(int platform_mode)
>  	if (error || !in_suspend)
>  		pm_restore_gfp_mask();
>  
> -	ftrace_start();
>  	resume_console();
>  	dpm_complete(msg);
>  
> @@ -494,7 +492,6 @@ int hibernation_restore(int platform_mode)
>  
>  	pm_prepare_console();
>  	suspend_console();
> -	ftrace_stop();
>  	pm_restrict_gfp_mask();
>  	error = dpm_suspend_start(PMSG_QUIESCE);
>  	if (!error) {
> @@ -502,7 +499,6 @@ int hibernation_restore(int platform_mode)
>  		dpm_resume_end(PMSG_RECOVER);
>  	}
>  	pm_restore_gfp_mask();
> -	ftrace_start();
>  	resume_console();
>  	pm_restore_console();
>  	return error;
> @@ -529,7 +525,6 @@ int hibernation_platform_enter(void)
>  
>  	entering_platform_hibernation = true;
>  	suspend_console();
> -	ftrace_stop();
>  	error = dpm_suspend_start(PMSG_HIBERNATE);
>  	if (error) {
>  		if (hibernation_ops->recover)
> @@ -573,7 +568,6 @@ int hibernation_platform_enter(void)
>   Resume_devices:
>  	entering_platform_hibernation = false;
>  	dpm_resume_end(PMSG_RESTORE);
> -	ftrace_start();
>  	resume_console();
>  
>   Close:
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 4dd8822f732a..f6623da034d8 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -248,7 +248,6 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
>  		goto Platform_wake;
>  	}
>  
> -	ftrace_stop();
>  	error = disable_nonboot_cpus();
>  	if (error || suspend_test(TEST_CPUS))
>  		goto Enable_cpus;
> @@ -275,7 +274,6 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
>  
>   Enable_cpus:
>  	enable_nonboot_cpus();
> -	ftrace_start();
>  
>   Platform_wake:
>  	if (need_suspend_ops(state) && suspend_ops->wake)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
