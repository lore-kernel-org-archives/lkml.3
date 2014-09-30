Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaI3BY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:24:29 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:65228 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaI3BY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140930011446.GQ7996@ZenIV.linux.org.uk>
References: <CALCETrWivFAqiWAfAYzZ4fgKC87H+VhyOLrfb+ONCjMmqKG9eQ@mail.gmail.com>
 <20140930000924.GO7996@ZenIV.linux.org.uk> <CALCETrW8xvOr0WfyzqBUxZkw_PXckUh8AdGPxU3sd7=cLayPyQ@mail.gmail.com>
 <20140930002948.GP7996@ZenIV.linux.org.uk> <CALCETrVnXXjDjh9+vOGfFh08-wtjJeuC=n=PtNusOS_nq0puFA@mail.gmail.com>
 <20140930011446.GQ7996@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 18:24:05 -0700
Message-ID: <CALCETrXXFCfwEdi+AYELdr4umWPTr8=2x4AzvSTBX6E55Do2sw@mail.gmail.com>
Subject: Re: Removing shared subtrees?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 6:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Sep 29, 2014 at 05:36:27PM -0700, Andy Lutomirski wrote:
>
>> Ideally it would leave them around until the whole subtree had no
>> references, at which point /mnt and everything under it would
>> disappear with no side effects, because it has no references.
>
> So, assuming you've got a stuck NFS mount with a bunch of local stuff
> bound on top of it, in your ideal we'd have the latter all remaining
> mounted until the server comes back.  Lovely, that...

No, not at all.

>
>> I suspect it detaches them immediately, especially after reading the
>> rest of your email.
>
> IOW, you *still* have not bothered to say man umount and read the manpage?
>
> Quote:
>        -l     Lazy  unmount.  Detach  the filesystem from the filesystem
>               hierarchy now, and cleanup all references to the filesystem as
>               soon as it is not busy anymore.  (Requires kernel 2.4.11 or
>               later.)
>
>> > Such an elegant way to say "I can't be arsed to read"...  For what it's
>> > worth: MNT_DETACH is *not* "detach the subtree as whole, busy or not".
>> > It's "unmount all mounts within the subtree, busy or not".  At which point
>> > the self-LART you keep describing becomes quite easy to comprehend, doesn't
>> > it?

The manpage you quoted doesn't seem to agree with what you just said.
Or at least, it contains nothing that, to me, would indicate that.
But...

>>
>> Again, *I have no problem with the current semantics of umount -l*,
>> except insofar as they interact really nastily with shared subtrees.
>> I have a problem with bidirectional shared subtrees *in general*.
>
> Pardon me, but it really looks like your problem is with reading.  In general
> or not, but you are essentially complaining that your *guess* concerning the
> semantics of this and that doesn't match the reality all that well, and its
> combination with observed bits and pieces is really confusing.
>
> BTW, I certainly agree that documentation of the mount-related utils and
> syscalls could've been better.  But you clearly have never bothered to
> read the existing one.  I'm sorry, but "I've used this utility with that
> flag as root without ever checking what the manpage says about that
> flag; results are painful and incomprehensible; whaddya mean, read the
> fine manpage?" buys you very little sympathy.

Let me try this one more time:

I don't *care* whether MNT_DETACH unmounts submounts immediately or
when all the references are finally gone.  I didn't read the docs or
the code to see which is the case *because I don't care*.

I think it's somewhere between ridiculous and flat-out broken that
MNT_DETACH of the *root* of a shared subtree *propagates* the unmount
of submounts to the parent of the shared subtree.  This is IMO
completely bogus.

IOW, if I do:

mount --make-rshared /
mount --rbind / /mnt
umount -l /mnt/dev

then I fully expect /dev to be unmounted (although I think that this
is a misfeature).

But I did:

mount --make-rshared /
mount --rbind / /mnt
umount -l /mnt  <- the ROOT of the fscking shared subtree

And /dev got unmounted.  How does this make any sense at all?

I further claim that the entire concept of shared (as opposed to
slave) subtrees is essentially worthless and should possibly be
deprecated or removed outright.

--Andy
