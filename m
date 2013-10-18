Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3JRO4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:56:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:22439 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755485Ab3JRO4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:56:01 -0400
Date: Fri, 18 Oct 2013 10:55:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 5/6] x86: patch all traced function calls using the
 int3-based framework
Message-ID: <20131018105557.0961a2f5@gandalf.local.home>
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


> +/*
> + * We do not want to replace ftrace calls one by one because syncing all CPUs
> + * is quite expensive.
> + *
> + * On the other hand, we do not want to modify all calls at once because
> + * the buffers for text_poke_bp might be quite huge. Also we do not want
> + * to count the number of records before the allocation.
> + *
> + * Let's modify the call in batches defined by this define.
> + */
> +#define FTRACE_MAX_RECS_PATCH 8192
>  
> -static int finish_update(struct dyn_ftrace *rec, int enable)
> +static int ftrace_allocate_replace_buffers(unsigned long **addr, void **opcode)

I absolutely hate this. Current ftrace conversion does not need to
allocate at all. I want to keep it that way.

Now, what I was thinking is that the text_poke_bp() should have a
variant where you can pass in an iterator. That way we don't need to
copy the ftrace records to an array that text_poke_bp() uses to do the
conversion. Just let the iterator return the next address to use.

I'm all for merging the code (was on my TODO list, so thank you for
this :-) but one reason I didn't get to it yet, was because of not
doing the copy. To me, that's a cop out.

Anyway, this was really bad timing. I'm trying to get some other things
reviewed and into the kernel for 3.12 before it's too late, and next
week I'll be traveling for 10 days (Kernel Summit, followed by RT
summit). You may need to ping me again in a couple of weeks to review
this. Unless I get some time to do it in my travels.

Thanks,

-- Steve


>  {
> -	unsigned long ftrace_addr;
> -	int ret;
> -
> -	ret = ftrace_update_record(rec, enable);
> -
> -	ftrace_addr = get_ftrace_addr(rec);
> -
> -	switch (ret) {
> -	case FTRACE_UPDATE_IGNORE:
> -		return 0;
> -
> -	case FTRACE_UPDATE_MODIFY_CALL_REGS:
> -	case FTRACE_UPDATE_MODIFY_CALL:
> -	case FTRACE_UPDATE_MAKE_CALL:
> -		/* converting nop to call */
> -		return finish_update_call(rec, ftrace_addr);
> +	*addr = kmalloc_array(FTRACE_MAX_RECS_PATCH,
> +			      sizeof(*addr), GFP_KERNEL);
> +	if (!addr) {
> +		printk(KERN_ERR
> +		       "ftrace_replace_code: cannot allocate addr buffer\n");
> +		return -ENOMEM;
> +	}
>  
> -	case FTRACE_UPDATE_MAKE_NOP:
> -		/* converting a call to a nop */
> -		return finish_update_nop(rec);
> +	*opcode = kmalloc_array(FTRACE_MAX_RECS_PATCH,
> +				MCOUNT_INSN_SIZE, GFP_KERNEL);
> +	if (!opcode) {
> +		printk(KERN_ERR
> +		       "ftrace_replace_code: cannot allocate codes buffer\n");
> +		return -ENOMEM;
>  	}
>  
>  	return 0;
>  }
>  
