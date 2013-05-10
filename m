Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3EJQDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:03:45 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62993 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3EJQDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130510153638.GA8179@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com>
 <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com>
 <20130510125826.GA553@redhat.com> <CAKi4VALE8tFUTZ1qYwm0Eth1zFMU8xA6XC5RTnF1KCKYQp-0NQ@mail.gmail.com>
 <20130510153638.GA8179@redhat.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Fri, 10 May 2013 13:03:23 -0300
Message-ID: <CAKi4VAJPXgiik9CGrVyk7cCvz-1913p1KL8tn5FvxH4w0r27bg@mail.gmail.com>
Subject: Re: [PATCH 3/3] init/Kconfig: Add option to set modprobe command
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 12:36 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 05/10, Lucas De Marchi wrote:
>>
>> Oh, right. Forgot about that. And this patch set should have been sent
>> as RFC, since I'm interested in feedback about the idea. What do you
>> think?
>
> Well, personally I think it would be better to use kasprintf(), see the
> patch I sent (it is actually wrong, needs kfree(args) before return).
>
> Or. How about the patch below? It should be split into 2 changes:
>
>         1. Introduce __argv_split(). It can have more callers, for
>            example do_coredump() and ftrace_function_filter_re()
>            can use it to avoid kstrndup() + kfree().
>
>         2. Change call_modprobe() to use kasprintf() + __argv_split().

Seems better. In your previous version I was troubled about
duplicating the string twice. Now it's weird freeing a
user-allocated-string,
but I think it's a good tradeoff and covers other use cases as you
pointed out as well.


>
> uncompiled/untested.

Ok. I'll give it a try.


>
> Oleg.
>
> --- x/lib/argv_split.c
> +++ x/lib/argv_split.c
> @@ -39,31 +39,15 @@ void argv_free(char **argv)
>  }
>  EXPORT_SYMBOL(argv_free);
>
> -/**
> - * argv_split - split a string at whitespace, returning an argv
> - * @gfp: the GFP mask used to allocate memory
> - * @str: the string to be split
> - * @argcp: returned argument count
> - *
> - * Returns an array of pointers to strings which are split out from
> - * @str.  This is performed by strictly splitting on white-space; no
> - * quote processing is performed.  Multiple whitespace characters are
> - * considered to be a single argument separator.  The returned array
> - * is always NULL-terminated.  Returns NULL on memory allocation
> - * failure.
> - *
> - * The source string at `str' may be undergoing concurrent alteration via
> - * userspace sysctl activity (at least).  The argv_split() implementation
> - * attempts to handle this gracefully by taking a local copy to work on.
> +/*
> + * @argv_str should be kmalloc'ed by the caller, freed by this func.
>   */
> -char **argv_split(gfp_t gfp, const char *str, int *argcp)
> +char **__argv_split(gfp_t gfp, const char *argv_str, int *argcp)
>  {
> -       char *argv_str;
>         bool was_space;
>         char **argv, **argv_ret;
>         int argc;
>
> -       argv_str = kstrndup(str, KMALLOC_MAX_SIZE - 1, gfp);
>         if (!argv_str)
>                 return NULL;
>
> @@ -91,4 +75,28 @@ char **argv_split(gfp_t gfp, const char
>                 *argcp = argc;
>         return argv_ret;
>  }
> +
> +/**
> + * argv_split - split a string at whitespace, returning an argv
> + * @gfp: the GFP mask used to allocate memory
> + * @str: the string to be split
> + * @argcp: returned argument count
> + *
> + * Returns an array of pointers to strings which are split out from
> + * @str.  This is performed by strictly splitting on white-space; no
> + * quote processing is performed.  Multiple whitespace characters are
> + * considered to be a single argument separator.  The returned array
> + * is always NULL-terminated.  Returns NULL on memory allocation
> + * failure.
> + *
> + * The source string at `str' may be undergoing concurrent alteration via
> + * userspace sysctl activity (at least).  The argv_split() implementation
> + * attempts to handle this gracefully by taking a local copy to work on.
> + */
> +char **argv_split(gfp_t gfp, const char *str, int *argcp)
> +{
> +       char *dup = kstrndup(str, KMALLOC_MAX_SIZE - 1, gfp);
> +       return __argv_split(gfp, dup, argcp);
> +}
> +
>  EXPORT_SYMBOL(argv_split);
> --- x/kernel/kmod.c
> +++ x/kernel/kmod.c
> @@ -64,20 +64,16 @@ static DECLARE_RWSEM(umhelper_sem);
>
>  #ifdef CONFIG_MODULES
>
> -/*
> -       modprobe_path is set via /proc/sys.
> -*/
> -char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
> +/* modprobe_path is set via /proc/sys/kernel/modprobe */
> +char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
>
>  static void free_modprobe_argv(struct subprocess_info *info)
>  {
> -       kfree(info->argv[3]); /* check call_modprobe() */
> -       kfree(info->argv);
> +       argv_free(info->argv);
>  }
>
>  static int call_modprobe(char *module_name, int wait)
>  {
> -       struct subprocess_info *info;
>         static char *envp[] = {
>                 "HOME=/",
>                 "TERM=linux",
> @@ -85,31 +81,24 @@ static int call_modprobe(char *module_na
>                 NULL
>         };
>
> -       char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
> +       struct subprocess_info *info;
> +       char **argv;
> +       char *args;
> +
> +       args = kasprintf(GFP_KERNEL, "%s %s", modprobe_path, module_name);
> +       argv = __argv_split(GFP_KERNEL, args, NULL);
>         if (!argv)
>                 goto out;
>
> -       module_name = kstrdup(module_name, GFP_KERNEL);
> -       if (!module_name)
> -               goto free_argv;
> -
> -       argv[0] = modprobe_path;
> -       argv[1] = "-q";
> -       argv[2] = "--";
> -       argv[3] = module_name;  /* check free_modprobe_argv() */
> -       argv[4] = NULL;
> -
>         info = call_usermodehelper_setup(modprobe_path, argv, envp, GFP_KERNEL,
>                                          NULL, free_modprobe_argv, NULL);
>         if (!info)
> -               goto free_module_name;
> +               goto free_argv;
>
>         return call_usermodehelper_exec(info, wait | UMH_KILLABLE);
>
> -free_module_name:
> -       kfree(module_name);
>  free_argv:
> -       kfree(argv);
> +       argv_free(argv);
>  out:
>         return -ENOMEM;
>  }
>



--

Lucas De Marchi
