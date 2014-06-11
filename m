Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaFKB2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 21:28:10 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58493 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaFKB2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 21:28:08 -0400
Message-ID: <5397B0A1.7060401@hitachi.com>
Date: Wed, 11 Jun 2014 10:28:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ftrace/core  2/2] ftrace, kprobes: Support IPMODIFY flag
 to find IP modify conflict
References: <20140610105001.8732.93502.stgit@kbuild-fedora.novalocal>  <20140610105014.8732.43086.stgit@kbuild-fedora.novalocal> <1402408435.1676.13.camel@leonhard>
In-Reply-To: <1402408435.1676.13.camel@leonhard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/10 22:53), Namhyung Kim wrote:
> Hi Masami,
> 
> 2014-06-10 (화), 10:50 +0000, Masami Hiramatsu:
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
>>
> 
> [SNIP]
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
>> +		return 0;
>> +
>> +	/* Update rec->flags */
>> +	do_for_each_ftrace_rec(pg, rec) {
>> +		/* We need to update only differences of filter_hash */
>> +		in_old = !old_hash || ftrace_lookup_ip(old_hash, rec->ip);
>> +		in_new = !new_hash || ftrace_lookup_ip(new_hash, rec->ip);
> 
> Why not use ftrace_hash_empty() here instead of checking NULL? 

Ah, a trick is here. Since an empty filter_hash must hit all, we can not
enable/disable filter_hash if we use ftrace_hash_empty() here.

To enabling the new_hash, old_hash must be EMPTY_HASH which means in_old
always be false. To disabling, new_hash is EMPTY_HASH too.
Please see ftrace_hash_ipmodify_enable/disable/update().

> Also
> return value of ftrace_lookup_ip is not boolean..  maybe you need to
> add !! or convert type of the in_{old,new} to bool.

Yeah, I see. And there is '||' (logical OR) which evaluates the result
as boolean. :)

> 
> 
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
>> +	} while_for_each_ftrace_rec();
>> +
>> +	return 0;
>> +
>> +rollback:
>> +	end = rec;
>> +
>> +	/* Roll back what we did above */
>> +	do_for_each_ftrace_rec(pg, rec) {
>> +		if (rec == end)
>> +			goto err_out;
>> +
>> +		in_old = !old_hash || ftrace_lookup_ip(old_hash, rec->ip);
>> +		in_new = !new_hash || ftrace_lookup_ip(new_hash, rec->ip);
>> +		if (in_old == in_new)
>> +			continue;
>> +
>> +		if (in_new)
>> +			rec->flags &= ~FTRACE_FL_IPMODIFY;
>> +		else
>> +			rec->flags |= FTRACE_FL_IPMODIFY;
>> +	} while_for_each_ftrace_rec();
>> +
>> +err_out:
>> +	return -EBUSY;
>> +}
>> +
>> +static int ftrace_hash_ipmodify_enable(struct ftrace_ops *ops)
>> +{
>> +	struct ftrace_hash *hash = ops->filter_hash;
>> +
>> +	if (ftrace_hash_empty(hash))
>> +		hash = NULL;
>> +
>> +	return __ftrace_hash_update_ipmodify(ops, EMPTY_HASH, hash);
>> +}
> 
> Please see above comment.  You can pass an empty hash as is, or pass
> NULL as second arg.  The same goes to below...

As I said above, that is by design :). EMPTY_HASH means it hits nothing,
NULL means it hits all.

> 
> Thanks,
> Namhyung
> 
> 
>> +
>> +/* Disabling always succeeds */
>> +static void ftrace_hash_ipmodify_disable(struct ftrace_ops *ops)
>> +{
>> +	struct ftrace_hash *hash = ops->filter_hash;
>> +
>> +	if (ftrace_hash_empty(hash))
>> +		hash = NULL;
>> +
>> +	__ftrace_hash_update_ipmodify(ops, hash, EMPTY_HASH);
>> +}
>> +
>> +static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
>> +				       struct ftrace_hash *new_hash)
>> +{
>> +	struct ftrace_hash *old_hash = ops->filter_hash;
>> +
>> +	if (ftrace_hash_empty(old_hash))
>> +		old_hash = NULL;
>> +
>> +	if (ftrace_hash_empty(new_hash))
>> +		new_hash = NULL;
>> +
>> +	return __ftrace_hash_update_ipmodify(ops, old_hash, new_hash);
>> +}
>> +
> 
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


