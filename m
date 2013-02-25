Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab3BYQIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 11:08:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759933Ab3BYQIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 11:08:11 -0500
Date: Mon, 25 Feb 2013 17:06:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usermodehelper: Fix -ENOMEM return logic
Message-ID: <20130225160642.GA31806@redhat.com>
References: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Lucas De Marchi wrote:
>
> Callers of call_usermodehelper_fns() should check the return value and
> free themselves the data passed if the return is -ENOMEM. This is
> because the subprocess_info is allocated in this function, and if the
> allocation fail, the cleanup function cannot be called.

Yes, this is confusing.

> However call_usermodehelper_exec() may also return -ENOMEM,

Yes, and we can't distinguish this case from info == NULL case,

> in which
> case the cleanup function is called. This means that if the caller
> checked the return code, it was risking running the cleanup twice (like
> kernel/sys.c:orderly_poweroff()) and if not, a leak could happen.

In short: every user of call_usermodehelper_fns(cleanup != NULL)
is buggy. Thanks.

But I am not sure I agree with the patch...

>  static void call_usermodehelper_freeinfo(struct subprocess_info *info)
>  {
> -	if (info->cleanup)
> +	if (info->cleanup && info->retval != -ENOMEM)
>  		(*info->cleanup)(info);
>  	kfree(info);
>  }

This doesn't look very clean/robust. And in general, personally I
dislike the fact that ENOMEM has the special meaning. IOW, I think
we should cleanup this logic, not to complicate it more.

And in fact I do not think this is right, at least in UMH_NO_WAIT
case, shouldn't avoid ->cleanup() if, say, prepare_kernel_cred()
fails in ____call_usermodehelper()...


I think we should extract call_usermodehelper_setup() +
call_usermodehelper_setfns() into the new helper and export it.
And export call_usermodehelper_exec() as well.

call_usermodehelper_setfns() as a separate function makes no sense.

Then we can fix call_modprobe/orderly_poweroff, something like below.

What do you think?

Oleg.

--- x/kernel/kmod.c
+++ x/kernel/kmod.c
@@ -98,8 +98,14 @@ static int call_modprobe(char *module_na
 	argv[3] = module_name;	/* check free_modprobe_argv() */
 	argv[4] = NULL;
 
-	return call_usermodehelper_fns(modprobe_path, argv, envp,
-		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
+	info = call_usermodehelper_setup(...); // better name, please...
+	if (!info)
+		goto free_modname;
+
+	return call_usermodehelper_exec(info, wait);
+
+free_modname:
+	kfree(module_name);
 free_argv:
 	kfree(argv);
 out:

