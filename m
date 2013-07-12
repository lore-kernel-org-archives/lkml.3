Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3GLTmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:42:21 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:54124 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677Ab3GLTmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:42:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130712191321.GB4165@ZenIV.linux.org.uk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
	<CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
	<20130712054817.GY4165@ZenIV.linux.org.uk>
	<8738rk9eai.fsf@rasmusvillemoes.dk>
	<20130712154833.GA4165@ZenIV.linux.org.uk>
	<87wqovviyy.fsf@rasmusvillemoes.dk>
	<20130712191321.GB4165@ZenIV.linux.org.uk>
Date: Fri, 12 Jul 2013 12:42:15 -0700
X-Google-Sender-Auth: 7mHayX-nBzDTec0C8wia_MMFqnY
Message-ID: <CA+55aFyCa59PnK2GRCdFKOJRvF4HqAT6-euDtVb35ABKEmZbow@mail.gmail.com>
Subject: Re: [git pull] vfs.git part 2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 12:13 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Jul 12, 2013 at 04:30:45PM +0000, Rasmus Villemoes wrote:
>>
>> How about simply making O_TMPFILE == O_DIRECTORY | O_RDWR |
>> O_TMPFILE_INTERNAL, and letting the correct use be
>>
>> open("/some/dir", O_TMPFILE) [with or without a mode argument]
>>
> Hrm...  I can't say I like it, but it's almost OK; the only problem here
> is the bug fixed by commit bc77daa78 - on some of the old kernels (including
> 3.10, BTW) we used to allow opening /proc/self/fd/0 with O_DIRECTORY|O_RDWR ;-/
>
> Said that, I think it's more tolerable than the kludge I came up with -
> one would need to pass it a procfs symlink as argument to hit that.
> Linus, your opinion?

I think I like it. Because we really shouldn't rely on "the directory
already exists", since it's actually quite possible that it doesn't.
Sure, things like /tmp and /usr/tmp we can generally rely on, but
mkstemp() and friends are often done using TMPDIR etc, so for a
O_TMPFILE we really shouldn't assume that the directory is some
long-term stable and reliable thing.

My only suggestion is that we *enforce* that O_DIRECTORY is set, and
that O_CREAT is not set (the latter is the reverse of what we do now),
so that we don't get programs that "happen" to work on older kernels
(the /proc bug thing I think we can ignore - at least it makes the
possibility of accidental problems much *much* less).

That said, I'm not sure about O_RDWR. There are ways to possibly turn
an fd into a new path, so I could imagine O_WRONLY being useful
("create a temporary file, fill in the content, do fdatasync, then
atomically make it appear in the filesystem with a linkat() system
call").

I'd actually want to at least bring up again the possible requirement
that the pathname argument to O_TEMPFILE must end in a '/'. It would
be an easy check to add, and then we could actually drop the whole
O_DIRECTORY flag, and O_CREAT becomes a non-issue too. The only
downside of that is that it might be very inconvenient for user mode
(eg if user-mode just wants to use the TMPDIR environment variable
directly), so it might well make for a "better" patch for the kernel,
but be much worse as an ABI issue.

As to the mode argument: we should encourage people to have it, since
the inode *may* become visible afterwards. See above (can you do
linkat() to just turn an fd into a name? I didn't really check, but I
think you can do it as a "link(/proc/sef/fd/..)" thing regardless).

                    Linus
