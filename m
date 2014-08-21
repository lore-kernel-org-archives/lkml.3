Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaHUGuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:50:55 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36623 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaHUGuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:50:54 -0400
MIME-Version: 1.0
In-Reply-To: <1408573066.9484.11.camel@intel.com>
References: <1408564816-1778-1-git-send-email-arjun024@gmail.com>
 <87mwayj39c.fsf@rustcorp.com.au> <CAJFMrCG1OXrdRoUNqtZYdBqE_0dj+a3yAfFhuyFvTte7Ozbo0w@mail.gmail.com>
 <87ha16izpu.fsf@rustcorp.com.au> <1408573066.9484.11.camel@intel.com>
From: Arjun Sreedharan <arjun024@gmail.com>
Date: Thu, 21 Aug 2014 12:20:32 +0530
Message-ID: <CAJFMrCEiop68C1ksqmbYznMJbLROEKWqXLF1VP8kJUXkbCEHnA@mail.gmail.com>
Subject: Re: [PATCH] params: fix potential memory leak in add_sysfs_param()
To: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 August 2014 03:47, Woodhouse, David <david.woodhouse@intel.com> wrote:
> On Thu, 2014-08-21 at 07:35 +0930, Rusty Russell wrote:
>>
>> Above this:
>>         if (!mk->mp) {
>>                 num = 0;
>>                 attrs = NULL;
>>         } else {
>>                 num = mk->mp->num;
>>                 attrs = mk->mp->grp.attrs;
>>         }
>>
>> So, attrs is just a temporary: either NULL (doesn't need freeing), or
>> is the old mk->mp->grp.attrs ptr.
>
> Except that in the failure case we *free* the old mk->mp and never free
> mk->mp->grp.attrs so it *is* indeed lost.
>
> A simpler version of Arjun's patch might look like this:
>
> diff --git a/kernel/params.c b/kernel/params.c
> index 34f5270..f9459bc 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -613,7 +613,6 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
>                        sizeof(*mk->mp) + sizeof(mk->mp->attrs[0]) * (num+1),
>                        GFP_KERNEL);
>         if (!new) {
> -               kfree(attrs);
>                 err = -ENOMEM;
>                 goto fail;
>         }
> @@ -653,7 +652,10 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
>  fail_free_new:
>         kfree(new);
>  fail:
> -       mk->mp = NULL;
> +       if (mk->mp) {
> +               kfree(mk->mp->grp.attrs);
> +               mk->mp = NULL;
> +       }
>         return err;
>  }
>
>
>
> But as I suggested in my previous response, a *better* fix might look
> like this:
>
> diff --git a/kernel/params.c b/kernel/params.c
> index 34f5270..cdab9d4 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -595,7 +595,7 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
>  {
>         struct module_param_attrs *new;
>         struct attribute **attrs;
> -       int err, num;
> +       int num;
>
>         /* We don't bother calling this with invisible parameters. */
>         BUG_ON(!kp->perm);
> @@ -612,18 +612,19 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
>         new = krealloc(mk->mp,
>                        sizeof(*mk->mp) + sizeof(mk->mp->attrs[0]) * (num+1),
>                        GFP_KERNEL);
> -       if (!new) {
> -               kfree(attrs);
> -               err = -ENOMEM;
> -               goto fail;
> -       }
> +       if (!new)
> +               return -ENOMEM;
> +
>         /* Despite looking like the typical realloc() bug, this is safe.
> -        * We *want* the old 'attrs' to be freed either way, and we'll store
> -        * the new one in the success case. */
> +        * In the failure case, the old 'attrs' is still in new->grp.attrs
> +        * and will live on there. */
>         attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
>         if (!attrs) {
> -               err = -ENOMEM;
> -               goto fail_free_new;
> +               /* This is in a larger kmalloc allocation than before but
> +                * otherwise entirely unchanged. We've failed to add the
> +                * new param but the existing ones are still there. */
> +               mk->mp = new;
> +               return -ENOMEM;
>         }
>
>         /* Sysfs wants everything zeroed. */
> @@ -649,12 +650,6 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
>
>         mk->mp = new;
>         return 0;
> -
> -fail_free_new:
> -       kfree(new);
> -fail:
> -       mk->mp = NULL;
> -       return err;
>  }
>
>  #ifdef CONFIG_MODULES
>

Ok, what's the harm in releasing {new,mk->mp}->grp.attrs and
new/mk->mp on realloc failure ?
@David, @Rusty Am i right thinking they are not used after the
function returns error ?

See module_param_sysfs_setup() : when the function in question returns error,
free_module_param_attrs() is *not* called to release memory.

For cleaner code, we do *not* release memory in the said function as
David suggests and then call
free_module_param_attrs() on returning err. What say?

Arjun

>
> --
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
