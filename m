Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab3JRQkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:40:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:59469 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752621Ab3JRQj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:39:59 -0400
Date: Fri, 18 Oct 2013 12:39:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 5/6] x86: patch all traced function calls using the
 int3-based framework
Message-ID: <20131018123955.2e301b97@gandalf.local.home>
In-Reply-To: <1382106445-31468-6-git-send-email-pmladek@suse.cz>
References: <1382106445-31468-6-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013 16:27:24 +0200
Petr Mladek <pmladek@suse.cz> wrote:


>  void ftrace_replace_code(int enable)
>  {
>  	struct ftrace_rec_iter *iter;
>  	struct dyn_ftrace *rec;
> -	const char *report = "adding breakpoints";
> -	int count = 0;
> -	int ret;
> +	unsigned long *addr = NULL;
> +	void *opcode = NULL, *op = NULL;
> +	const unsigned char *new;
> +	size_t count = 0;
>  
>  	for_ftrace_rec_iter(iter) {
>  		rec = ftrace_rec_iter_record(iter);
> -
> -		ret = add_breakpoints(rec, enable);
> -		if (ret)
> -			goto remove_breakpoints;
> -		count++;
> -	}
> -
> -	run_sync();
> -
> -	report = "updating code";
> -
> -	for_ftrace_rec_iter(iter) {
> -		rec = ftrace_rec_iter_record(iter);
> -
> -		ret = add_update(rec, enable);
> -		if (ret)
> -			goto remove_breakpoints;
> +		new = ftrace_new_code(rec, enable);
> +
> +		/* check next record if there is no new code for this one */
> +		if (!new)
> +			continue;
> +
> +		/* allocate buffers only when there will be a change */
> +		if (unlikely(!addr)) {
> +			if (ftrace_allocate_replace_buffers(&addr, &opcode))
> +				goto out;
> +			op = opcode;
> +			count = 0;
> +		}
> +
> +		/* fill buffers */
> +		addr[count++] = rec->ip;
> +		memcpy(op, new, MCOUNT_INSN_SIZE);
> +		op += MCOUNT_INSN_SIZE;
> +
> +		/* write buffers if they are full */
> +		if (count == FTRACE_MAX_RECS_PATCH) {
> +			text_poke_bp((void **)addr, opcode,
> +				     MCOUNT_INSN_SIZE, count, NULL);
> +			op = opcode;
> +			count = 0;
> +		}
>  	}
>  
> -	run_sync();
> -
> -	report = "removing breakpoints";
> -
> -	for_ftrace_rec_iter(iter) {
> -		rec = ftrace_rec_iter_record(iter);
> +	if (count)
> +		text_poke_bp((void **)addr, opcode,
> +			     MCOUNT_INSN_SIZE, count, NULL);
>  
> -		ret = finish_update(rec, enable);
> -		if (ret)
> -			goto remove_breakpoints;
> -	}
> -
> -	run_sync();
> -
> -	return;
> -
> - remove_breakpoints:
> -	ftrace_bug(ret, rec ? rec->ip : 0);
> -	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
> -	for_ftrace_rec_iter(iter) {
> -		rec = ftrace_rec_iter_record(iter);
> -		remove_breakpoint(rec);

Also you must keep the ftrace_bug() functionality. I notice there's no
error check for text_poke_bp(). Not only do we need to check the error
status, but if an error does happen, we must know the following:

 1) What record it failed on
 2) Did in fail on the read, compare, or write?

If it failed on the read:     -EFAULT is returned
If it failed on the compare:  -EINVAL is returned
If it failed on the write:    -EPERM is returned

Look at "ftrace_bug()", and then you can also do a google search on
"ftrace faulted" or "ftrace failed to modify", and see that this is an
extremely useful debugging tool, and not something I will allow to be
removed.

-- Steve


> -	}
> +out:
> +	kfree(addr);
> +	kfree(opcode);
>  }
>  

