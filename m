Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935318Ab3DPAo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 20:44:59 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61038 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab3DPAo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 20:44:58 -0400
Date: Tue, 16 Apr 2013 02:44:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace/x86: dont delay perf_event_disable() till
 second pass in ptrace_write_dr7()
Message-ID: <20130416004452.GG17561@somewhere.redhat.com>
References: <20130414191205.GA28791@redhat.com>
 <20130414191232.GA28816@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414191232.GA28816@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 09:12:32PM +0200, Oleg Nesterov wrote:
> ptrace_write_dr7() skips ptrace_modify_breakpoint(disabled => true)
> unless second_pass, this buys nothing but complicates the code and
> means that we always do the main loop twice even if "disabled" was
> never true.
> 
> The comment says:
> 
> 	Don't unregister the breakpoints right-away,
> 	unless all register_user_hw_breakpoint()
> 	requests have succeeded.
> 
> I think this logic was always wrong, hw_breakpoint_del() does not
> free the slot so perf_event_disable() can't hurt.

For the record, I think it was necessary before
44234adcdce38f83c56e05f808ce656175b4beeb
("hw-breakpoints: Modify breakpoints without unregistering them") because
modifying a breakpoint implied that the old bp was released and a new one
was created, opening a little race window in between against concurrent
breakpoint users.

> 
> But in any case this looks unneeded nowadays, and contrary to what
> the comment says we do not do register_user_hw_breakpoint(), this
> was removed by 24f1e32c "hw-breakpoints: Rewrite the hw-breakpoints
> layer on top of perf events".
> 
> Remove the "second_pass" check from the main loop and simplify the
> code. Since we have to check "bp != NULL" anyway, the patch also
> removes the same check in ptrace_modify_breakpoint() and moves the
> comment into ptrace_write_dr7().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Yeah I can't find a reason to keep that deferred disabling.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

The patch looks good, I just have a small suggestion below:

> ---
>  arch/x86/kernel/ptrace.c |   46 +++++++++++++++++-----------------------------
>  1 files changed, 17 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 0649f16..6814f27 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -609,14 +609,6 @@ ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
>  	int gen_len, gen_type;
>  	struct perf_event_attr attr;
>  
> -	/*
> -	 * We should have at least an inactive breakpoint at this
> -	 * slot. It means the user is writing dr7 without having
> -	 * written the address register first
> -	 */
> -	if (!bp)
> -		return -EINVAL;
> -
>  	err = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
>  	if (err)
>  		return err;
> @@ -634,10 +626,10 @@ ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
>   */
>  static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
>  {
> -	struct thread_struct *thread = &(tsk->thread);
> +	struct thread_struct *thread = &tsk->thread;
>  	unsigned long old_dr7;
> -	int i, orig_ret = 0, rc = 0;
> -	int second_pass = 0;
> +	int i, ret = 0, rc = 0;
> +	bool second_pass = false;
>  
>  	data &= ~DR_CONTROL_RESERVED;
>  	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
> @@ -651,35 +643,31 @@ restore:
>  		bool disabled = !decode_dr7(data, i, &len, &type);
>  		struct perf_event *bp = thread->ptrace_bps[i];
>  
> -		if (disabled) {
> +		if (!bp) {
> +			if (disabled)
> +				continue;
>  			/*
> -			 * Don't unregister the breakpoints right-away, unless
> -			 * all register_user_hw_breakpoint() requests have
> -			 * succeeded. This prevents any window of opportunity
> -			 * for debug register grabbing by other users.
> +			 * We should have at least an inactive breakpoint at
> +			 * this slot. It means the user is writing dr7 without
> +			 * having written the address register first.
>  			 */
> -			if (!bp || !second_pass)
> -				continue;
> +			rc = -EINVAL;
> +			break;
>  		}
>  
>  		rc = ptrace_modify_breakpoint(bp, len, type, tsk, disabled);
>  		if (rc)
>  			break;

It would be nice to warn here:

   WARN_ON_ONCE(rc && second_pass);

Because we rely on the second pass operations to always succeed. And these are indeed supposed
to. If not then we have a bug hiding somewhere that we really want to know about. And given
the complicated code path we can have with breakpoints and perf, it would be nice to
have that check.

Thanks.

>  	}
> -	/*
> -	 * Make a second pass to free the remaining unused breakpoints
> -	 * or to restore the original breakpoints if an error occurred.
> -	 */
> -	if (!second_pass) {
> -		second_pass = 1;
> -		if (rc < 0) {
> -			orig_ret = rc;
> -			data = old_dr7;
> -		}
> +	/* Make a second pass to restore the original breakpoints if failed */
> +	if (!second_pass && rc) {
> +		second_pass = true;
> +		ret = rc;
> +		data = old_dr7;
>  		goto restore;
>  	}
>  
> -	return orig_ret < 0 ? orig_ret : rc;
> +	return ret;
>  }
>  
>  /*
> -- 
> 1.5.5.1
> 
