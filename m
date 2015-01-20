Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbbATJ4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:56:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbbATJ4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:56:36 -0500
Date: Tue, 20 Jan 2015 10:56:33 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: support for repatching a function
In-Reply-To: <b211111ad4f29886a44871dddc313a542c48960b.1420834026.git.jpoimboe@redhat.com>
Message-ID: <alpine.LNX.2.00.1501201051330.31639@pobox.suse.cz>
References: <b211111ad4f29886a44871dddc313a542c48960b.1420834026.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 9 Jan 2015, Josh Poimboeuf wrote:

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
> Acked-by: Seth Jennings <sjenning@redhat.com>
> ---
>  include/linux/livepatch.h |   4 +-
>  kernel/livepatch/core.c   | 157 +++++++++++++++++++++++++++++++---------------
>  2 files changed, 108 insertions(+), 53 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 950bc61..f14c6fb 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -40,8 +40,8 @@ enum klp_state {
>   * @old_addr:	a hint conveying at what address the old function
>   *		can be found (optional, vmlinux patches only)
>   * @kobj:	kobject for sysfs resources
> - * @fops:	ftrace operations structure
>   * @state:	tracks function-level patch application state
> + * @stack_node:	list node for klp_ops func_stack list
>   */
>  struct klp_func {
>  	/* external */
> @@ -59,8 +59,8 @@ struct klp_func {
>  
>  	/* internal */
>  	struct kobject kobj;
> -	struct ftrace_ops *fops;
>  	enum klp_state state;
> +	struct list_head stack_node;
>  };
>  
>  /**
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index ce42d3b..5c10381 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -29,17 +29,40 @@
>  #include <linux/kallsyms.h>
>  #include <linux/livepatch.h>
>  
> +struct klp_ops {
> +	struct list_head node;
> +	struct list_head func_stack;
> +	struct ftrace_ops fops;
> +};

I think it would be useful to add some comments for this structure and its 
members (similar to the last paragraph of the changelog above). Maybe it 
is useless now but the code is going to get complicated and it costs 
nothing...

Otherwise it looks ok to me (except for thing mentioned by Jiri).

Thank you

--
Miroslav Benes
SUSE Labs
