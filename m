Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab3BYRjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:39:14 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:63358 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651Ab3BYRjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:39:11 -0500
MIME-Version: 1.0
In-Reply-To: <20130225160642.GA31806@redhat.com>
References: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi> <20130225160642.GA31806@redhat.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Mon, 25 Feb 2013 14:38:50 -0300
Message-ID: <CAMOw1v7S07YOLQaKBBSHkCqhf1JSB1ZabMeMUJagb4E8841opQ@mail.gmail.com>
Subject: Re: [PATCH] usermodehelper: Fix -ENOMEM return logic
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 1:06 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/25, Lucas De Marchi wrote:
>>
>> Callers of call_usermodehelper_fns() should check the return value and
>> free themselves the data passed if the return is -ENOMEM. This is
>> because the subprocess_info is allocated in this function, and if the
>> allocation fail, the cleanup function cannot be called.
>
> Yes, this is confusing.
>
>> However call_usermodehelper_exec() may also return -ENOMEM,
>
> Yes, and we can't distinguish this case from info == NULL case,
>
>> in which
>> case the cleanup function is called. This means that if the caller
>> checked the return code, it was risking running the cleanup twice (like
>> kernel/sys.c:orderly_poweroff()) and if not, a leak could happen.
>
> In short: every user of call_usermodehelper_fns(cleanup != NULL)
> is buggy. Thanks.
>
> But I am not sure I agree with the patch...
>
>>  static void call_usermodehelper_freeinfo(struct subprocess_info *info)
>>  {
>> -     if (info->cleanup)
>> +     if (info->cleanup && info->retval != -ENOMEM)
>>               (*info->cleanup)(info);
>>       kfree(info);
>>  }
>
> This doesn't look very clean/robust. And in general, personally I
> dislike the fact that ENOMEM has the special meaning. IOW, I think
> we should cleanup this logic, not to complicate it more.
>
> And in fact I do not think this is right, at least in UMH_NO_WAIT
> case, shouldn't avoid ->cleanup() if, say, prepare_kernel_cred()
> fails in ____call_usermodehelper()...
>
>
> I think we should extract call_usermodehelper_setup() +
> call_usermodehelper_setfns() into the new helper and export it.
> And export call_usermodehelper_exec() as well.
>
> call_usermodehelper_setfns() as a separate function makes no sense.
>
> Then we can fix call_modprobe/orderly_poweroff, something like below.
>
> What do you think?

Yep. The current interface is confusing. I agree that a separate
setup() + exec() would make more sense.

>
> Oleg.
>
> --- x/kernel/kmod.c
> +++ x/kernel/kmod.c
> @@ -98,8 +98,14 @@ static int call_modprobe(char *module_na
>         argv[3] = module_name;  /* check free_modprobe_argv() */
>         argv[4] = NULL;
>
> -       return call_usermodehelper_fns(modprobe_path, argv, envp,
> -               wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
> +       info = call_usermodehelper_setup(...); // better name, please...
> +       if (!info)
> +               goto free_modname;
> +
> +       return call_usermodehelper_exec(info, wait);

I'd say that in these cases the "call_" prefix has no meaning, and we
could just use a "usermodehelper" as the namespace.

Lucas De Marchi
