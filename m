Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280Ab3HOGwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:52:34 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:63339 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3HOGwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com> <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Aug 2013 23:52:11 -0700
Message-ID: <CALCETrUzJjTDT6mxEoQg=cq9jOvw8mn9dLQ=q=qko+oEwkGsVQ@mail.gmail.com>
Subject: Re: DoS with unprivileged mounts
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 11:45 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> writes:
>
>> On Wed, Aug 14, 2013 at 9:32 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>
>>>> The solution is also theoretically simple: mounts in unpriv namespaces
>>>> are marked "volatile" and are dissolved on an unlink type operation.
>>>>
>>>> Such volatile mounts would be useful in general too.
>>>
>>> Agreed.
>>>
>>> This is a problem that is a general pain with mount namespaces in
>>> general.
>>>
>>> I think the real technical hurdle is finding the mounts t in some random
>>> mount namespace.  Once we can do that relatively efficiently the rest
>>> becomes simple.
>>
>> We already have a "struct mountpoint" hashed on the dentry.  Chaining
>> mounts on that mountpoint would be trivial.  And we need a
>> MNT_VOLATILE flag and that's it.  If we fear that traversing the list
>> of mounts on the dentry to check for non-volatile ones then we could
>> also add a separate volatile counter to struct mountpoint and a
>> matching flag to the dentry.  But I don't think that's really
>> necessary.
>
> *Blink* I had overlooked "struct mountpoint".  That indeed makes things
> easier.
>
> I agree we can chain "struct mount" on "struct mountpoint" and then we
> would have an efficient implementation, that does not impact the vfs
> fast path.
>
> After that it becomes a question of permissions and semantics.
>
> I am in the process of adopting the rule that something that is not
> visible at the time we copy a set of mounts should not become visible
> in the child mount namespace.  Grr.  This has been a busy month and
> despite having been reviewed I haven't gotten around to pushing that
> patch to linux-next.
>
> But MNT_VOLATILE by definition can not reveal anything becasue the
> underlying mount point is removed, so that all of that weirdness is in
> propogating mounts between mount namespaces is not relevant here.
>
> This is however the propogation of an unmount between mount namespaces.
>
> In general we don't even need the MNT_VOLATILE flag we just need the
> appropriate permission checks.  However we do need something like
> MNT_VOLATILE to prevent surprises.  MNT_VOLATILE would be used to
> prevent things like:
>
> # mount --bind /  /mnt
> # rmdir /mnt/usr
>
> I think the root user would be rather annoyed if that worked, so it does
> appear we need something like MNT_VOLATILE.
>
> Part of me does prefer the semantics Andy has suggested where instead of
> unmounting things we have something like a skeleton of the mount tree
> unioned with dcaches of the filesystems themselves.  With "struct
> mountpoint" we are amazing close to that already.

Two possible nasty cases:

1. mount whatever /tmp/foo/bar; rmdir /tmp/foo/bar; rmdir /tmp/foo

Presumably ls /tmp shouldn't show foo.  Should cd /tmp/foo/bar work?
What about umount /tmp/foo/bar?  What about cd /tmp/foo?

2. mount whatever /tmp/foo; rmdir /tmp/foo; mkdir /tmp/foo

Ugh.

--Andy
