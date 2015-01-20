Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbbATPnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:43:55 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:41754 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbbATPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:43:54 -0500
Message-ID: <54BE7657.2010105@suse.cz>
Date: Tue, 20 Jan 2015 16:37:59 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>
CC: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: support for repatching a function
References: <cover.1421767360.git.jpoimboe@redhat.com> <da0d4d3c34441efcd8e830c4c978016581d7f055.1421767360.git.jpoimboe@redhat.com>
In-Reply-To: <da0d4d3c34441efcd8e830c4c978016581d7f055.1421767360.git.jpoimboe@redhat.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015, 04:26 PM, Josh Poimboeuf wrote:
> Add support for patching a function multiple times.  If multiple patches
> affect a function, the function in the most recently enabled patch
> "wins".  This enables a cumulative patch upgrade path, where each patch
> is a superset of previous patches.
> 
> This requires restructuring the data a little bit.  With the current
> design, where each klp_func struct has its own ftrace_ops, we'd have to
> unregister the old ops and then register the new ops, because
> FTRACE_OPS_FL_IPMODIFY prevents us from having two ops registered for
> the same function at the same time.  That would leave a regression
> window where the function isn't patched at all (not good for a patch
> upgrade path).
> 
> This patch replaces the per-klp_func ftrace_ops with a global klp_ops
> list, with one ftrace_ops per original function.  A single ftrace_ops is
> shared between all klp_funcs which have the same old_addr.  This allows
> the switch between function versions to happen instantaneously by
> updating the klp_ops struct's func_stack list.  The winner is the
> klp_func at the top of the func_stack (front of the list).
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

Reviewed-by: Jiri Slaby <jslaby@suse.cz>

But...

> @@ -267,16 +303,28 @@ static int klp_write_object_relocations(struct module *pmod,
>  
>  static void notrace klp_ftrace_handler(unsigned long ip,
>  				       unsigned long parent_ip,
> -				       struct ftrace_ops *ops,
> +				       struct ftrace_ops *fops,
>  				       struct pt_regs *regs)
>  {
> -	struct klp_func *func = ops->private;
> +	struct klp_ops *ops;
> +	struct klp_func *func;
> +
> +	ops = container_of(fops, struct klp_ops, fops);
> +
> +	rcu_read_lock();
> +	func = list_first_or_null_rcu(&ops->func_stack, struct klp_func,
> +				      stack_node);
> +	rcu_read_unlock();
> +
> +	if (WARN_ON(!func))
> +		return;

If it ever happens, the warn will drown the machine in the output splash.

WARN_ON_RATELIMIT?

thanks,
-- 
js
suse labs
