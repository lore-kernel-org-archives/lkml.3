Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab3HCQr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 12:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3HCQr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 12:47:26 -0400
Date: Sat, 3 Aug 2013 18:42:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach Levis <zml@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com, Zach Levis <zach@zachsthings.com>
Subject: Re: [PATCH v3 2/3] fs/binfmts: Better handling of binfmt loops
Message-ID: <20130803164203.GB32568@redhat.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com> <1375485703-4077-3-git-send-email-zml@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375485703-4077-3-git-send-email-zml@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Zach Levis wrote:
>
> With these changes, when a binfmt loop is encountered,
> the ELOOP will propogate back to the 0 depth. At this point the
> argv and argc values will be reset to what they were originally and an
> attempt is made to continue with the following binfmt handlers.
>
> Example: a qemu is configured to run 64-bit ELFs on an otherwise 32-bit
> system. The system's owner switches to running with 64-bit executables,
> but forgets to disable the binfmt_misc option that redirects 64bit ELFs
> to qemu. Since the qemu executable is a 64-bit ELF now, binfmt_misc
> keeps on matching it with the qemu rule, preventing the execution of any
> 64-bit binary.
>
> With these changes, an error is printed and search_binary_handler()
> continues on to the next handler, allowing the original executable to
> run normally so the user can (hopefully) fix their misconfiguration more
> easily.

Well. To be honest, I still can't say I like this change.

I won't argue, but I would really like if someone else can ack/nack
the intent.

As for correctness, please see below.

> @@ -1394,14 +1394,34 @@ int search_binary_handler(struct linux_binprm *bprm)
>  		if (!try_module_get(fmt->module))
>  			continue;
>  		read_unlock(&binfmt_lock);
> +		bprm->previous_binfmts[1] = bprm->previous_binfmts[0];
> +		bprm->previous_binfmts[0] = fmt;
> +
>  		bprm->recursion_depth++;
>  		retval = fmt->load_binary(bprm);
>  		bprm->recursion_depth--;
> -		if (retval >= 0 || retval != -ENOEXEC ||
> +		if (retval == -ELOOP && bprm->recursion_depth == 0) { /* cur, previous */
> +			pr_err("Too much recursion with binfmts (0:%s, -1:%s) in file %s, skipping (base %s).\n",
> +					bprm->previous_binfmts[0]->name,
> +					bprm->previous_binfmts[1]->name,

This doesn't look safe... previous_binfmts[0] == fmt is fine, but
previous_binfmts[1] can be already unloaded.

> +					bprm->filename,
> +					fmt->name);
> +
> +			/* Put argv back in its place */
> +			bprm->p = bprm->p_no_argv;
> +
> +			bprm->argc = count(*(bprm->argv_orig), MAX_ARG_STRINGS);

This can fail too.

> +			retval = copy_strings(bprm->argc, *(bprm->argv_orig), bprm);
> +			if (retval < 0)
> +				return retval;

This lacks put_binfmt().

And we should probably also check bprm->file != NULL and mm != NULL to
ensure it is safe to continue (->mm check is probably unneeded, but we
should either do it anyway or remove another one).

> +			retval = -ENOEXEC;

Hmm, why?

If this fmt is not last, retval will be changed anyway. Otherwise we
are going to return the error, and -ELOOP obviously makes more sense?

And in fact we should return -ELOOP even if this fmt is not last (unless
another linux_binfmt succceeds, of course). But with this patch ELOOP will
be translated into ENOEXEC, not good.


And once again, why do we need this? Afaics it only can help to "fix" the
misconfigured binfmt_misc.c. So perhaps it would be better to change
load_misc_binary() to detect the loop, do copy_strings() again (we can
add the helper for this to avoid the extra exports) and return -ENOEXEC?

And in this case you do not need previous_binfmts[], you can just do
WARN_ON() which shows the stack.



Note that in general this logic does not look right or I missed something.
OK, we restored argc/argv. But what about binfmt->file/buf ?

Suppose that ->load_script() is called with recursion_depth == 5. It reads
->buf which finally it points to, say, elf binary.

So it does bprm->file = open_exec(interp) + prepare_binprm(), and calls
search_binary_handler() again which results in -ELOOP.

This -ELOOP is propagated up to recursion_depth == 0. We restore argv
and continue.

If the next fmt is elf_format it can happily load this elf binary.

No?

> @@ -1436,6 +1456,10 @@ static int exec_binprm(struct linux_binprm *bprm)
>  	if (ret >= 0) {
>  		trace_sched_process_exec(current, old_pid, bprm);
>  		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
> +		/* Successful execution, now null out the cached argv
> +		 * (we don't want to access it later)

Yes, and now that we have exec_binprm() this is obvious, so

> +		bprm->argv_orig = NULL;

why do we need to reset it?

> @@ -1533,9 +1557,11 @@ static int do_execve_common(const char *filename,
>  	if (retval < 0)
>  		goto out;
>
> +	bprm->p_no_argv = bprm->p;
>  	retval = copy_strings(bprm->argc, argv, bprm);
>  	if (retval < 0)
>  		goto out;
> +	bprm->argv_orig = &argv;

purely cosmetic, but you can initialize both p_no_argv and argv_orig
in one place, but I won't insist.

Oleg.

