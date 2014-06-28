Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaF0XoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:44:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53182 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752247AbaF0XoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:44:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 01/27] x86, power, suspend: Annotate restore_processor_state() with notrace
Date: Sat, 28 Jun 2014 02:02:10 +0200
Message-ID: <3577662.BSnUZfboWb@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140626165847.934409696@goodmis.org>
References: <20140626165221.736847419@goodmis.org> <20140626165847.934409696@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 26, 2014 12:52:22 PM Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> ftrace_stop() is used to stop function tracing during suspend and resume
> which removes a lot of possible debugging opportunities with tracing.
> The reason was that some function in the resume path was causing a triple
> fault if it were to be traced. The issue I found was that doing something
> as simple as calling smp_processor_id() would reboot the box!
> 
> When function tracing was first created I didn't have a good way to figure
> out what function was having issues, or it looked to be multiple ones. To
> fix it, we just created a big hammer approach to the problem which was to
> add a flag in the mcount trampoline that could be checked and not call
> the traced functions.
> 
> Lately I developed better ways to find problem functions and I can bisect
> down to see what function is causing the issue. I removed the flag that
> stopped tracing and proceeded to find the problem function and it ended
> up being restore_processor_state(). This function makes sense as when the
> CPU comes back online from a suspend it calls this function to set up
> registers, amongst them the GS register, which stores things such as
> what CPU the processor is (if you call smp_processor_id() without this
> set up properly, it would fault).
> 
> By making restore_processor_state() notrace, the system can suspend and
> resume without the need of the big hammer tracing to stop.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

ACK

> ---
>  arch/x86/power/cpu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index 424f4c97a44d..6ec7910f59bf 100644
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -165,7 +165,7 @@ static void fix_processor_context(void)
>   *		by __save_processor_state()
>   *	@ctxt - structure to load the registers contents from
>   */
> -static void __restore_processor_state(struct saved_context *ctxt)
> +static void notrace __restore_processor_state(struct saved_context *ctxt)
>  {
>  	if (ctxt->misc_enable_saved)
>  		wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
> @@ -239,7 +239,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
>  }
>  
>  /* Needed by apm.c */
> -void restore_processor_state(void)
> +void notrace restore_processor_state(void)
>  {
>  	__restore_processor_state(&saved_context);
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
