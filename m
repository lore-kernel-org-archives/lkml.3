Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaFWH52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:57:28 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45974 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaFWH51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:57:27 -0400
Message-ID: <53A7DDE0.3050405@hitachi.com>
Date: Mon, 23 Jun 2014 16:57:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip v2 2/3] ftrace, kprobes: Support IPMODIFY flag to
 find IP modify conflict
References: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal> <20140617110449.15167.45320.stgit@kbuild-fedora.novalocal> <20140619224846.670964c2@gandalf.local.home>
In-Reply-To: <20140619224846.670964c2@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/20 11:48), Steven Rostedt wrote:
> On Tue, 17 Jun 2014 11:04:49 +0000
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Introduce FTRACE_OPS_FL_IPMODIFY to avoid conflict among
>> ftrace users who may modify regs->ip to change the execution
>> path. This also adds the flag to kprobe_ftrace_ops, since
>> ftrace-based kprobes already modifies regs->ip. Thus, if
>> another user modifies the regs->ip on the same function entry,
>> one of them will be broken. So both should add IPMODIFY flag
>> and make sure that ftrace_set_filter_ip() succeeds.
>>
>> Note that currently conflicts of IPMODIFY are detected on the
>> filter hash. It does NOT care about the notrace hash. This means
>> that if you set filter hash all functions and notrace(mask)
>> some of them, the IPMODIFY flag will be applied to all
>> functions.
> 
> Hmm, this worries me. I'm not sure I care about ignoring the notrace
> hash.

Since the notrace hash is not updated atomically (it is disabled ->
updated -> enabled), there could be a small window where only filter
hash is enabled.　I considered that.


[...]
>> @@ -317,13 +322,14 @@ extern int ftrace_nr_registered_ops(void);
>>   * from tracing that function.
>>   */
>>  enum {
>> +	FTRACE_FL_IPMODIFY	= (1UL << 28),
>>  	FTRACE_FL_ENABLED	= (1UL << 29),
>>  	FTRACE_FL_REGS		= (1UL << 30),
>>  	FTRACE_FL_REGS_EN	= (1UL << 31)
>>  };
>>  
>> -#define FTRACE_FL_MASK		(0x7UL << 29)
>> -#define FTRACE_REF_MAX		((1UL << 29) - 1)
>> +#define FTRACE_FL_MASK		(0xfUL << 28)
>> +#define FTRACE_REF_MAX		((1UL << 28) - 1)
> 
> Note, this is going to conflict with my queue for 3.17, as I'm starting
> to write individual trampolines.
> 
> You can take a look at my ftrace/next branch, but be warned, it will
> rebase.

OK, anyway, at least this flag can easily be changed. :)


>>  struct dyn_ftrace {
>>  	unsigned long		ip; /* address of mcount call-site */
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index 3214289..e52d86f 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -915,7 +915,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>>  #ifdef CONFIG_KPROBES_ON_FTRACE
>>  static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
>>  	.func = kprobe_ftrace_handler,
>> -	.flags = FTRACE_OPS_FL_SAVE_REGS,
>> +	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
> 
> We probably should comment somewhere that once you set the IPMODIFY
> flag (or do not set it), it should never change. An ops either has it
> or it doesn't, it can't change its mind. Otherwise it could play havoc
> with the update code below.

Agreed. Hmm, it seems that we currently have no document about ftrace_ops.
This is a kind of undocumented kmodule API. At least we need to add a comment
on the header.

[...]
>> @@ -1593,6 +1607,109 @@ static void ftrace_hash_rec_enable(struct ftrace_ops *ops,
>>  	__ftrace_hash_rec_update(ops, filter_hash, 1);
>>  }
>>  
>> +/*
>> + * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
>> + * or no-needed to update, -EBUSY if it detects a conflict of the flag
>> + * on a ftrace_rec.
>> + * Note that old_hash and new_hash has below meanings
>> + *  - If the hash is NULL, it hits all recs
>> + *  - If the hash is EMPTY_HASH, it hits nothing
>> + *  - Others hits the recs which match the hash entries.
> 
>  - Anything else hits the recs ...

Oh, thanks!

> 
>> + */
>> +static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>> +					 struct ftrace_hash *old_hash,
>> +					 struct ftrace_hash *new_hash)
>> +{
>> +	struct ftrace_page *pg;
>> +	struct dyn_ftrace *rec, *end = NULL;
>> +	int in_old, in_new;
>> +
>> +	/* Only update if the ops has been registered */
>> +	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
>> +		return 0;
>> +
>> +	if (!(ops->flags & FTRACE_OPS_FL_SAVE_REGS) ||
>> +	    !(ops->flags & FTRACE_OPS_FL_IPMODIFY))
> 
> Only check the IPMODIFY flag. In the future, I may allow this without
> SAVE_REGS. That is, the function will get a regs pointer that has a
> limited number of regs set. Maybe just ip.

Ah, I see. I'll change that.

>> +		return 0;
>> +
>> +	/* Update rec->flags */
>> +	do_for_each_ftrace_rec(pg, rec) {
>> +		/* We need to update only differences of filter_hash */
>> +		in_old = !old_hash || ftrace_lookup_ip(old_hash, rec->ip);
>> +		in_new = !new_hash || ftrace_lookup_ip(new_hash, rec->ip);
>> +		if (in_old == in_new)
>> +			continue;
>> +
>> +		if (in_new) {
>> +			/* New entries must ensure no others are using it */
>> +			if (rec->flags & FTRACE_FL_IPMODIFY)
>> +				goto rollback;
>> +			rec->flags |= FTRACE_FL_IPMODIFY;
>> +		} else /* Removed entry */
>> +			rec->flags &= ~FTRACE_FL_IPMODIFY;
> 
> Like I mentioned before. This code depends on oldhash also having
> IPMODIFY set. I wonder if we can detect if it changed.

Yeah, I guess that SAVE_REGS flag has same issue. And, of course
kprobe->flags has same. I think we just need comments or a document
for the ftrace_ops API.

[...]
>> @@ -2078,6 +2195,15 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
>>  
>>  	ops->flags |= FTRACE_OPS_FL_ENABLED;
>>  
>> +	ret = ftrace_hash_ipmodify_enable(ops);
>> +	if (ret < 0) {
>> +		/* Rollback registration process */
>> +		__unregister_ftrace_function(ops);
>> +		ftrace_start_up--;
>> +		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
>> +		return ret;
>> +	}
>> +
>>  	ftrace_hash_rec_enable(ops, 1);
>>  
>>  	ftrace_startup_enable(command);
>> @@ -2104,6 +2230,8 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
>>  	 */
>>  	WARN_ON_ONCE(ftrace_start_up < 0);
>>  
>> +	/* Disabling ipmodify never be failed */
> 
>           "Disabling ipmodify never fails"

OK, I'll fix that.

> 
>> +	ftrace_hash_ipmodify_disable(ops);
>>  	ftrace_hash_rec_disable(ops, 1);
>>  
>>  	if (!global_start_up)
>> @@ -2641,9 +2769,10 @@ static int t_show(struct seq_file *m, void *v)
>>  
>>  	seq_printf(m, "%ps", (void *)rec->ip);
>>  	if (iter->flags & FTRACE_ITER_ENABLED)
>> -		seq_printf(m, " (%ld)%s",
>> +		seq_printf(m, " (%ld)%s%s",
>>  			   rec->flags & ~FTRACE_FL_MASK,
>> -			   rec->flags & FTRACE_FL_REGS ? " R" : "");
>> +			   rec->flags & FTRACE_FL_REGS ? " R" : "",
>> +			   rec->flags & FTRACE_FL_IPMODIFY ? " I" : "");
> 
> Perhaps even add 'I' as we may allow setting it without regs.

Yes, here we do so. :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


