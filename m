Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3CCSSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 13:18:16 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:62183 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab3CCSSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 13:18:15 -0500
MIME-Version: 1.0
In-Reply-To: <874ngtxgt5.fsf@xmission.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<874ngtxgt5.fsf@xmission.com>
Date: Sun, 3 Mar 2013 10:18:14 -0800
Message-ID: <CAGXu5j+bwUx6r++ttvYg4yJrUUHxoQ86tQ0JzEBoQQU6KAh9ww@mail.gmail.com>
Subject: Re: user ns: arbitrary module loading
From: Kees Cook <keescook@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 8:12 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Serge E. Hallyn" <serge@hallyn.com> writes:
>
>> Quoting Kees Cook (keescook@google.com):
>>> The rearranging done for user ns has resulted in allowing arbitrary
>>> kernel module loading[1] (i.e. re-introducing a form of CVE-2011-1019)
>>> by what is assumed to be an unprivileged process.
>>>
>>> At present, it does look to require at least CAP_SETUID along the way
>>> to set up the uidmap (but things like the setuid helper newuidmap
>>> might soon start providing such a thing by default).
>
> CAP_SETUID is not needed.

Do you have an example? I wasn't able to gain capabilities within the
userns until I had a uid map set that allowed my uid to map to root.
(I needed CAP_SYS_ADMIN in the mnt ns to get past may_mount() before I
could touch get_fs_type().)

>>> It might be worth examining GRKERNSEC_MODHARDEN in grsecurity, which
>>> examines module symbols to verify that request_module() for a
>>> filesystem only loads a module that defines "register_filesystem"
>>> (among other things).
>>>
>>> -Kees
>>>
>>> [1] https://twitter.com/grsecurity/status/307473816672665600
>>
>> So the concern is root in a child user namespace doing
>>
>>       mount -t randomfs <...>
>>
>> in which case do_new_mount() checks ns_capable(), not capable(),
>> before trying to load a module for randomfs.
>>
>> As well as (secondly) the fact that there is no enforcement on
>> the format of the module names (i.e. fs-*).
>>
>> Kees, from what I've seen the GRKERNSEC_MODHARDEN won't be acceptable.
>> At least Eric Paris is strongly against it.
>
> What is wrong with GRKERNSEC_MODHARDEN?  It took a quick look and the
> code is far from clean.  But that would not be a fundamental objection
> from keeping code like that out of the kernel.
>
> It is also entertaining to read security code that won't even build with
> CONFIG_UIDGID_STRICT_TYPE_CHECKS enabled.
>
>> But how about if we
>> add a check for 'current_user_ns() == &init_user_ns' at that place
>> instead?
>>
>> Eric Biederman, do you have any objections to that?
>
> The obvious solution here is to test for CAP_SYS_ADMIN rather than
> current_user_ns == &init_user_ns before we request the module here.  As
> that is what was previously required on this path.
>
> Reading the comments the concerns are.
> - Non-root users are allowed to load obscure and possibly kernel
>   modules.
> - get_fs_type can trigger the load of any kernel module.

Yes, though I think you meant "... possibly vulnerable kernel modules
..." There has been a history of weird stuff living in kernel modules
that gets built by distros. If we can raise the bar on being able to
force the kernel to load those things, it'd be nice. As mentioned in
my other email, this is basically one of the few remaining places were
arbitrary module names can get loaded.

> At a practical level I don't see adding a capalbe(CAP_SYS_ADMIN) check
> as having much effect for the functionality currently present in user
> namespaces today as the filesystems that an legal to mount in a user
> namespace (ramfs, tmpfs, mqueuefs, sysfs, proc, devpts) are so common
> most of them can not even be built as modules and even if they are
> modules the modules will already be loaded.  So I will see about adding
> a capable(CAP_SYS_ADMIN) check to shore things up for the short term.

For the short-term, yes, this solves the "regression". But it
obviously isn't what is desired for userns in the long term.

> In the longer term I very much would like to get loopback devices
> and mounts of filesystems on those loopback devices working, and being
> able to mount filesystems from usb sticks that people commonly plug in,
> and remove the need for privileged daemons to do that work.  At that
> point manually having to do something that was automatic before will
> either mean a regression in functionality or bugs as people manually
> load things.
>
>
> So I am wondering what I a good policy should be.  Should we trust
> kernel modules to not be buggy (especially if they were signed as part
> of the build process)?  Do we add some defense in depth and add
> filesystem registration magic?  Thinking...

If we can produce a mechanism that provides some defensive design, we
should do it. There will always be bugs, so we should always try to
make them harder to get to or harder to exploit. Reducing the
available attack surface to "just filesystems" would be a win here,
and it would be consistent with the _intent_ of existing kernel code.

> We can limit the request_module in get_fs_type to just filesystems
> fairly easily.
>
> In include/linux/fs.h:
>
>         #define MODULE_ALIAS_FS(type) MODULE_ALIAS("fs-" __stringify(type))
>
> In fs/filesystems.c:
>
>         if (request_moudle("fs-%.*s", len, name) == 0)
>
> Then just add the appropriate MODULE_ALIAS_FS lines in all of the
> filesystems.  This also allows user space to say set the module loading
> policy for filesystems using the blacklist and the alias keywords
> in /etc/modprobe.d/*.conf.

This was the solution for netdev. The backward compat situation is this:

        if (no_module && capable(CAP_NET_ADMIN))
                no_module = request_module("netdev-%s", name);
        if (no_module && capable(CAP_SYS_MODULE)) {
                if (!request_module("%s", name))
                        pr_warn("Loading kernel module for a network
device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias
netdev-%s instead.\n",
                                name);
        }

Those aren't ns_capable, though, so right now userns can't trigger
loading new network drivers via ifconfig, but this seems like a
reasonable approach to take.

> That seems a whole lot simpler, more powerful and more maintainable than
> what little I saw in GRKERNSEC_MODHARDEN to prevent loading of
> non-filesystem modules from get_fs_type.
>
> Eric
>
> p.s.  This is the patch I am looking at pushing to Linus in the near
> future.
>
> diff --git a/fs/filesystems.c b/fs/filesystems.c
> index da165f6..5b0644d 100644
> --- a/fs/filesystems.c
> +++ b/fs/filesystems.c
> @@ -273,7 +273,8 @@ struct file_system_type *get_fs_type(const char *name)
>         int len = dot ? dot - name : strlen(name);
>
>         fs = __get_fs_type(name, len);
> -       if (!fs && (request_module("%.*s", len, name) == 0))
> +       if (!fs && capable(CAP_SYS_ADMIN) &&
> +           (request_module("%.*s", len, name) == 0))
>                 fs = __get_fs_type(name, len);
>
>         if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {

Will this break other users of get_fs_type()? I think it's okay; it
looks like all the other users are expected to be privileged.

Should this look like netdev in the future? Something like this, after
making may_mount() available to fs/filesystems.c:

-       if (!fs && (request_module("%.*s", len, name) == 0))
+       if (!fs && ((may_mount() && request_module("fs-%.*s", len,
name) == 0) ||
+                   (capable(CAP_SYS_ADMIN) && request_module("%.*s",
len, name) == 0)))

and adding all the filesystem module aliases.

At some point maybe we can add a flag to kill the old unqualified
paths available to CAP_SYS_ADMIN for netdev and mount...

-Kees

--
Kees Cook
Chrome OS Security
