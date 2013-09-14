Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3INPsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 11:48:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab3INPsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 11:48:01 -0400
Date: Sat, 14 Sep 2013 17:41:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] argv_split: Return NULL if argument contains no
	non-whitespace.
Message-ID: <20130914154144.GA7884@redhat.com>
References: <201309141632.GHD86439.VLOOOFQFJtSMFH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309141632.GHD86439.VLOOOFQFJtSMFH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14, Tetsuo Handa wrote:
>
>   # echo '|' > /proc/sys/kernel/core_pattern
>
> and got
>
>   BUG: unable to handle kernel NULL pointer dereference at   (null)

Hmm. This was fixed by 264b83c07a8 "usermodehelper: check
subprocess_info->path != NULL".

But then this check was removed by 7f57cfa4e2a "usermodehelper:
kill the sub_info->path[0] check".

Note that the changelog says "do_execve(NULL) is safe" and I certainly
tested this case when I sent the patch...

Now it is crashes in path_openat() because pathname->name is NULL.
Something was changed, perhaps  or (I'm afraid) I misread that code and
my testing was wrong. do_filp_open/etc were changed to accept
"struct filename *" a long ago.

> upon core dump because helper_argv[0] == NULL at
>
>   helper_argv = argv_split(GFP_KERNEL, cn.corename, NULL);
>   call_usermodehelper_setup(helper_argv[0], ...);

Are you sure? See above.

> --- a/lib/argv_split.c
> +++ b/lib/argv_split.c
> @@ -50,7 +50,7 @@ EXPORT_SYMBOL(argv_free);
>   * quote processing is performed.  Multiple whitespace characters are
>   * considered to be a single argument separator.  The returned array
>   * is always NULL-terminated.  Returns NULL on memory allocation
> - * failure.
> + * failure or @str being empty or @str containing only white-space.
>   *
>   * The source string at `str' may be undergoing concurrent alteration via
>   * userspace sysctl activity (at least).  The argv_split() implementation
> @@ -68,6 +68,10 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
>  		return NULL;
>
>  	argc = count_argc(argv_str);
> +	if (!argc) {
> +		kfree(argv_str);
> +		return NULL;
> +	}

Yes, this is what 264b83c07a8 suggested... But I am not sure, if nothing
else pr_warn("failed to allocate memory") from do_coredump() doesn't look
nice in this case.

Perhaps

	--- x/kernel/kmod.c
	+++ x/kernel/kmod.c
	@@ -571,6 +571,9 @@ int call_usermodehelper_exec(struct subp
		DECLARE_COMPLETION_ONSTACK(done);
		int retval = 0;
	 
	+	if (!sub_info->path)
	+		return -EXXX;
	+
		helper_lock();
		if (!khelper_wq || usermodehelper_disabled) {
			retval = -EBUSY;

?

Oleg.

