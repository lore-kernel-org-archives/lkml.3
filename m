Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaI3ClU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:41:20 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:55768 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbaI3ClQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140930022133.GR7996@ZenIV.linux.org.uk>
References: <CALCETrWivFAqiWAfAYzZ4fgKC87H+VhyOLrfb+ONCjMmqKG9eQ@mail.gmail.com>
 <20140930000924.GO7996@ZenIV.linux.org.uk> <CALCETrW8xvOr0WfyzqBUxZkw_PXckUh8AdGPxU3sd7=cLayPyQ@mail.gmail.com>
 <20140930002948.GP7996@ZenIV.linux.org.uk> <CALCETrVnXXjDjh9+vOGfFh08-wtjJeuC=n=PtNusOS_nq0puFA@mail.gmail.com>
 <20140930011446.GQ7996@ZenIV.linux.org.uk> <CALCETrXXFCfwEdi+AYELdr4umWPTr8=2x4AzvSTBX6E55Do2sw@mail.gmail.com>
 <20140930022133.GR7996@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 19:40:54 -0700
Message-ID: <CALCETrXWHpaH88JRK7kHw7GUmfKn20rYwA8n=kMqzUoiDFY29g@mail.gmail.com>
Subject: Re: Removing shared subtrees?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 7:21 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Sep 29, 2014 at 06:24:05PM -0700, Andy Lutomirski wrote:
>> On Mon, Sep 29, 2014 at 6:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Mon, Sep 29, 2014 at 05:36:27PM -0700, Andy Lutomirski wrote:
>> >
>> >> Ideally it would leave them around until the whole subtree had no
>> >> references, at which point /mnt and everything under it would
>> >> disappear with no side effects, because it has no references.
>> >
>> > So, assuming you've got a stuck NFS mount with a bunch of local stuff
>> > bound on top of it, in your ideal we'd have the latter all remaining
>> > mounted until the server comes back.  Lovely, that...
>>
>> No, not at all.
>
> Er...  How so?  /mnt is stuck NFS.  /mnt/foo/bar and /mnt/foo/barf have
> /dev/sda1 and /dev/sda2 mounted on them.  Both are currently not busy.
> /mnt is - there's that shell trying to expand *.c in /mnt/splat, sitting
> around blocked with opened directory in its descriptor table.
>
> Just how would your ideal prevent sda1 and sda2 staying mounted?  You can't
> say umount /mnt/foo/bar; it'll get blocked trying to revalidate foo and
> waiting for server to reply.  In real world you can say umount -l /mnt and
> be done with that - everything in there becomes detached, what used to be
> /mnt stays alive (but not mounted on /mnt anymore) until it ceases to be
> busy.  What used to be /mnt/foo/bar and /mnt/foo/barf end up shut down
> immediately (what with not being busy).  In your ideal they would stay around
> until the "whole subtree" (of what?) loses all references, i.e. until that
> shell closes opened directory.

I don't want /mnt/foo/far to stay mounted.  I do, however, want their
peers, if any, to stay mounted *if /mnt is the root of a shared
recursive bind mount*.

>
>> Let me try this one more time:
>>
>> I don't *care* whether MNT_DETACH unmounts submounts immediately or
>> when all the references are finally gone.  I didn't read the docs or
>> the code to see which is the case *because I don't care*.
>>
>> I think it's somewhere between ridiculous and flat-out broken that
>> MNT_DETACH of the *root* of a shared subtree *propagates* the unmount
>> of submounts to the parent of the shared subtree.  This is IMO
>> completely bogus.
>
> Parent in which sense?  Try to experiment with this: mount something on
> /tmp/foo, then mount --rbind /tmp/foo /mnt/foo, mount something on /mnt/bar
> and /tmp/bar and umount -l /mnt/foo.  Then think what does and does not
> happen.
>
>> IOW, if I do:
>>
>> mount --make-rshared /
>> mount --rbind / /mnt
>> umount -l /mnt/dev
>>
>> then I fully expect /dev to be unmounted (although I think that this
>> is a misfeature).
>>
>> But I did:
>>
>> mount --make-rshared /
>> mount --rbind / /mnt
>> umount -l /mnt  <- the ROOT of the fscking shared subtree
>>
>> And /dev got unmounted.  How does this make any sense at all?
>
> Sigh... umount -l /mnt *includes* unmounting /mnt/dev.  Which you
> do expect to take /dev out.

I expect:

mount --rbind / /mnt
umount -l /mnt/dev

to detach /dev.

I expect:

mount --rbind / /mnt
umount -l /mnt

to have no net effect.

Another way of thinking about this would be that I would expect the
umount -l to propogate as a unit rather than propagating as a bunch of
individual unmounts.  For example:

mount --rbind / /mnt
umount -l /mnt/dev

means "detach /mnt/dev from /mnt and, due to sharing, detach /dev from /"

whereas

mount --rbind / /mnt
umount -l /mnt

means "detach /mnt from /" but does not unmount / or other things in
/.  IOW MNT_DETACH should only propagate detach of submounts if a
umount without MNT_DETACH would propagate.

In this case, mount --rbind / /mnt; umount /mnt would either fail with
-EBUSY or *not* propagate because it's the root of the shared subtree.

Anyway, improving the MNT_DETACH docs to recommend doing MS_PRIVATE
first if you're just trying to remove an rbind would solve most of the
problem.

In any event, I still don't understand why we have shared recursive
bind mounts in the first place.  What are they used for that wouldn't
be better served by slave mounts?

--Andy
