Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab3CDCfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:35:31 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:54754 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3CDCf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:35:29 -0500
MIME-Version: 1.0
In-Reply-To: <874ngsrvrh.fsf@xmission.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<874ngtxgt5.fsf@xmission.com>
	<CAGXu5j+bwUx6r++ttvYg4yJrUUHxoQ86tQ0JzEBoQQU6KAh9ww@mail.gmail.com>
	<874ngsrvrh.fsf@xmission.com>
Date: Sun, 3 Mar 2013 18:35:28 -0800
Message-ID: <CAGXu5jJiO=BmjVbpVJhxHbafn5T_SQbe5g-RLxRbmknNnQMyfQ@mail.gmail.com>
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

On Sun, Mar 3, 2013 at 1:58 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Kees Cook <keescook@google.com> writes:
>
>> On Sat, Mar 2, 2013 at 8:12 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>>>
>>>> Quoting Kees Cook (keescook@google.com):
>>>>> The rearranging done for user ns has resulted in allowing arbitrary
>>>>> kernel module loading[1] (i.e. re-introducing a form of CVE-2011-1019)
>>>>> by what is assumed to be an unprivileged process.
>>>>>
>>>>> At present, it does look to require at least CAP_SETUID along the way
>>>>> to set up the uidmap (but things like the setuid helper newuidmap
>>>>> might soon start providing such a thing by default).
>>>
>>> CAP_SETUID is not needed.
>>
>> Do you have an example? I wasn't able to gain capabilities within the
>> userns until I had a uid map set that allowed my uid to map to root.
>> (I needed CAP_SYS_ADMIN in the mnt ns to get past may_mount() before I
>> could touch get_fs_type().)
>
> Likely because exec drops capbilities if your uid isn't 0.
>
> Without CAP_SETUID you can still map uid to 0 to your current uid.
>
> The following shell script is an easy basis for testing and playing
> around with things.  It does assume a recent version of unshare from util-linux.
>
> #!/bin/sh
> export IFIFO=/tmp/userns-test-$$-in
> export OFIFO=/tmp/userns-test-$$-out
> rm -f $IFIFO $OFIFO
> mkfifo $IFIFO
> mkfifo $OFIFO
> unshare --user -- /bin/bash -s <<'EOF' &
> echo waiting-for-uid-and-gid-maps > $OFIFO
> read LINE < $IFIFO
> exec unshare --mount --net -- /bin/sh -s <<'EOF2'
> mount --bind $HOME /root/
> mount --bind /dev/null /dev/log
> # Start a shell to keep the namespace reference alive
> $SHELL -i < /dev/tty > /dev/tty 2> /dev/tty
> EOF2
> EOF
> child=$!
> read LINE < $OFIFO
> uid=$(id --user)
> gid=$(id --group)
> echo "0 $uid 1" > /proc/$child/uid_map
> echo "0 $gid 1" > /proc/$child/gid_map
> echo uid-and-gid-maps > $IFIFO
> wait $child

Ah-ha, thanks! Yes, that worked great. I think map_write()'s
cap_valid/ns_capable calls confused me. :)

>>> At a practical level I don't see adding a capalbe(CAP_SYS_ADMIN) check
>>> as having much effect for the functionality currently present in user
>>> namespaces today as the filesystems that an legal to mount in a user
>>> namespace (ramfs, tmpfs, mqueuefs, sysfs, proc, devpts) are so common
>>> most of them can not even be built as modules and even if they are
>>> modules the modules will already be loaded.  So I will see about adding
>>> a capable(CAP_SYS_ADMIN) check to shore things up for the short term.
>>
>> For the short-term, yes, this solves the "regression". But it
>> obviously isn't what is desired for userns in the long term.
>
>
>>> So I am wondering what I a good policy should be.  Should we trust
>>> kernel modules to not be buggy (especially if they were signed as part
>>> of the build process)?  Do we add some defense in depth and add
>>> filesystem registration magic?  Thinking...
>>
>> If we can produce a mechanism that provides some defensive design, we
>> should do it. There will always be bugs, so we should always try to
>> make them harder to get to or harder to exploit. Reducing the
>> available attack surface to "just filesystems" would be a win here,
>> and it would be consistent with the _intent_ of existing kernel code.
>
> Agreed.
>
>>> We can limit the request_module in get_fs_type to just filesystems
>>> fairly easily.
>>>
>>> In include/linux/fs.h:
>>>
>>>         #define MODULE_ALIAS_FS(type) MODULE_ALIAS("fs-" __stringify(type))
>>>
>>> In fs/filesystems.c:
>>>
>>>         if (request_moudle("fs-%.*s", len, name) == 0)
>>>
>>> Then just add the appropriate MODULE_ALIAS_FS lines in all of the
>>> filesystems.  This also allows user space to say set the module loading
>>> policy for filesystems using the blacklist and the alias keywords
>>> in /etc/modprobe.d/*.conf.
>>
>> This was the solution for netdev. The backward compat situation is this:
>>
>>         if (no_module && capable(CAP_NET_ADMIN))
>>                 no_module = request_module("netdev-%s", name);
>>         if (no_module && capable(CAP_SYS_MODULE)) {
>>                 if (!request_module("%s", name))
>>                         pr_warn("Loading kernel module for a network
>> device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias
>> netdev-%s instead.\n",
>>                                 name);
>>         }
>
> If I have read it right the backwards compat case is there to be
> compatibile with existing peoples configuration who had created specific
> aliases like eth0 for specific network devices in
> /etc/modprobe.d/*.conf.  Where the new netdev-* would break userspace.
>
> I don't believe anyone does anything like that for filesystems, and even
> if they tried it wouldn't work because the registered filesystem type
> would have a different name.  So I don't see needing to worry about that
> kind of backwards compatibility for filesystems.

Yeah, on re-reading the thread that introduced the backward compat
mode, I agree. There is no need for this with filesystems AFAICT.

>> Those aren't ns_capable, though, so right now userns can't trigger
>> loading new network drivers via ifconfig, but this seems like a
>> reasonable approach to take.
>
> Yes.  I saw those and deliberately didn't make those ns_capable, to be
> on the safe side when I made the rest of the networking ns_capable.
> That and ns_capabable is not meaningful as a check for loading modules.
> The only interesting question is can the global root user trigger them
> or can everyone trigger module loading.
>
>>> That seems a whole lot simpler, more powerful and more maintainable than
>>> what little I saw in GRKERNSEC_MODHARDEN to prevent loading of
>>> non-filesystem modules from get_fs_type.
>>>
>>> Eric
>>>
>>> p.s.  This is the patch I am looking at pushing to Linus in the near
>>> future.
>>>
>>> diff --git a/fs/filesystems.c b/fs/filesystems.c
>>> index da165f6..5b0644d 100644
>>> --- a/fs/filesystems.c
>>> +++ b/fs/filesystems.c
>>> @@ -273,7 +273,8 @@ struct file_system_type *get_fs_type(const char *name)
>>>         int len = dot ? dot - name : strlen(name);
>>>
>>>         fs = __get_fs_type(name, len);
>>> -       if (!fs && (request_module("%.*s", len, name) == 0))
>>> +       if (!fs && capable(CAP_SYS_ADMIN) &&
>>> +           (request_module("%.*s", len, name) == 0))
>>>                 fs = __get_fs_type(name, len);
>>>
>>>         if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
>>
>> Will this break other users of get_fs_type()? I think it's okay; it
>> looks like all the other users are expected to be privileged.
>
> I read through them all, and I didn't see problems.  The most concerning
> one is tomoyo's use of get_fs_type before capabilities are checked in
> do_mount.  But that is neither here nor there.
>
>> Should this look like netdev in the future? Something like this, after
>> making may_mount() available to fs/filesystems.c:
>>
>> -       if (!fs && (request_module("%.*s", len, name) == 0))
>> +       if (!fs && ((may_mount() && request_module("fs-%.*s", len,
>> name) == 0) ||
>> +                   (capable(CAP_SYS_ADMIN) && request_module("%.*s",
>> len, name) == 0)))
>>
>> and adding all the filesystem module aliases.
>>
>> At some point maybe we can add a flag to kill the old unqualified
>> paths available to CAP_SYS_ADMIN for netdev and mount...
>
> For netdev at least I don't see it as being particularly interesting.
> The case for tunnels is already as unprivileged as you can reasonably
> get with "request_module("rtnl-link-%s", kind);" in
> net/core/rtnetlink.c:rtnl_newlink().  For real physical devices there is
> both greater chance of a buggy module and no realy need as udev will
> load the module based on hardware auto-discovery.
>
> This leads to the fundamental question: Should we require privilege to
> request the load filesystem modules?

I think that the past dictated the need for privilege due to it being
tied to mounting. With userns, this is weakened, but it seems like the
privilege should at least attempt to segregate caps to certain classes
of modules.

> I have looked at GRKERNSEC_MODHARDEN to see if that could give me some
> guidance.  Unfortunately GRKERNSEC_MODHARDEN takes the position that fs
> kernel modules are the only kernel modules that should ever auto-load
> and only in very specific situations.  So I can't see that being the
> normal kernel policy, especially since there are the sysctls

Right -- modharden's basic goal is to block all non-root autoloading.
It had to work around some corner-cases (mount being setuid, etc).

> /proc/sys/kernel/modprobe and /proc/sys/kernel/modules_disabled.

Right -- this gives the granularity of "autoloading" and "loading"
respectively, but there is no concept of "only privileged autoloading"
in the current kernel.

It seems to me that unpriv users shouldn't be able to arbitrarily load
kernel modules, but if userns continues in this direction, there will
always be a path to doing autoloading for each different subsystem's
modules, ultimately leading to unpriv loading. Still, I think it's
worth creating obvious subsystem aliases so userspace can more easily
blacklist/whitelist things.

> Overall the basic policy building blocks for controlling which modules
> are loaded seem solid and in use.  So I don't see any particular reason
> why the kernel's default policy should not be to allow any users actions
> to request modules.
>
> So I think I am going to scrap the change sitting in my development tree
> to require capalbe(CAP_SYS_ADMIN) to load a filesystem module and just
> go with my request_module("fs-%.*",...); change. That is simple and
> seems to match the rest of the kernel.

Agreed.

> Does anyone see a reason why we should need CAP_SYS_ADMIN or be in the
> initial user namespace to trigger a request of filesystem modules?
>
> Eric

-Kees

-- 
Kees Cook
Chrome OS Security
