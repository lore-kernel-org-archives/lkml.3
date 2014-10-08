Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbaJHVgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:36:08 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:63750 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaJHVgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:36:06 -0400
Message-ID: <5435AE41.20105@landley.net>
Date: Wed, 08 Oct 2014 16:36:01 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Vagin <avagin@parallels.com>, Andrey Vagin <avagin@openvz.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
References: <1412683977-29543-1-git-send-email-avagin@openvz.org> <87mw97wqvx.fsf@x220.int.ebiederm.org> <20141008110829.GC24908@paralelels.com> <CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ@mail.gmail.com> <87vbnue56f.fsf@x220.int.ebiederm.org> <CALCETrVSxYr=Oa29qHNL-GoifS26U8TfpreGY+KN7g926YgHUw@mail.gmail.com>
In-Reply-To: <CALCETrVSxYr=Oa29qHNL-GoifS26U8TfpreGY+KN7g926YgHUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/14 14:31, Andy Lutomirski wrote:
> On Wed, Oct 8, 2014 at 12:23 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>>> Maybe we want to say that rootfs should not be used if we are going to
>>>> create containers...
>>
>> Today it is an assumption of the vfs that rootfs is mounted.  With
>> rootfs mounted and pivot_root at the base of the mount stack you can
>> make as minimal of a set of mounts as the vfs allows.
>>
>> Removing rootfs from the vfs requires an audit of everything that
>> manipulates mounts.  It is not remotely a local excercise.
> 
> Would it be a less invasive audit to allow different mount namespaces
> to have different rootfses?

I.E. The same way different namespaces have different init tasks?

The abstraction containers has implemented here should be logically
consistent.

>>> Could we have an extra rootfs-like fs that is always completely empty,
>>> doesn't allow any writes, and can sit at the bottom of container
>>> namespace hierarchies?  If so, and if we add a new syscall that's like
>>> pivot_root (or unshare) but prunes the hierarchy, then we could switch
>>> to that rootfs then.
>>
>> Or equally have something that guarantees that rootfs is empty and
>> read-only at the time the normal root filesystem is mounted.  That is
>> certainly a much more localized change if we want to go there.
>>
>> I am half tempted to suggest that mount --move /some/path / be updated
>> to make the old / just go away (perhaps to be replaced with a read-only
>> empty rootfs).  That gets us into figuring out if we break userspace
>> which is a big challenge.
> 
> Hence my argument for a new syscall or entirely new operation.

I'm still waiting for somebody to explain to my why chroot() shouldn't
be changed to do this instead of adding a new syscall. (At least when
mount namespace support is enabled.)

> mount(2) and friends are way too multiplexed right now.  I just found
> yet another security bug due to the insanely complicated semantics of
> the vfs syscalls.  (Yes, a different one from the one yesterday.)

As the guy who rewrote busybox mount 3 times, and who just implemented a
brand new one (toybox) from scratch:

It's a bit fiddly, yes.

> A new operation kills several birds with one stone.  It could look like:
> 
> int mntns_change_root(int dfd, const char *path, int flags);
> 
> return -EPERM if chrooted.

Really?

>  Returns -EINVAL if path (relative to dfd) isn't a mountmount.

Requiring that chroot() only be called on mountpoints would break
existing semantics, which gets us back to new systemcall instead of
changing behavior of existing one.

If I recall, the first line of pushback against merging the openvz code
as is was "buckets of new syscalls". Pushback against adding a new
system call is understandable. Why can't we fix chroot() now that we
have the tools to do so?

>  Otherwise it disconnects path from the existing
> hierarchy, attaches a permanently-empty read-only rootfs under it,
> makes it the root of the mntns, and does the root refs fixup.  The old
> hierarchy gets thrown out.

We have a chroot() syscall. We don't use it for containers because it
doesn't do what we want. Does it currently do what _anybody_ wants?

> Systemd could use this, too.

While that's a strong argument against it, I'm willing to overlook it.

Rob
