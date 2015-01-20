Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbbATGkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:40:31 -0500
Received: from ozlabs.org ([103.22.144.67]:55316 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbbATGka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:40:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrey Tsyvarev <tsyvarev@ispras.ru>
Cc: Andrey Tsyvarev <tsyvarev@ispras.ru>, linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kernel/module.c: Free lock-classes if parse_args failed
In-Reply-To: <1421216708-1975-1-git-send-email-tsyvarev@ispras.ru>
References: <1421216708-1975-1-git-send-email-tsyvarev@ispras.ru>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Jan 2015 17:07:19 +1030
Message-ID: <87iog2arfk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
> parse_args call module parameters' .set handlers, which may use locks defined in the module.
> So, these classes should be freed in case parse_args returns error(e.g. due to incorrect parameter passed).

Thanks, this seems right.  Applied.

But this makes me ask: where is lockdep_free_key_range() called on the
module init code?  It doesn't seem to be at all...

Confused,
Rusty.

> Signed-off-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
> ---
>  kernel/module.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 3965511..2b44de4 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3311,6 +3311,9 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	module_bug_cleanup(mod);
>  	mutex_unlock(&module_mutex);
>  
> +	/* Free lock-classes: */
> +	lockdep_free_key_range(mod->module_core, mod->core_size);
> +
>  	/* we can't deallocate the module until we clear memory protection */
>  	unset_module_init_ro_nx(mod);
>  	unset_module_core_ro_nx(mod);
> -- 
> 1.8.3.1
