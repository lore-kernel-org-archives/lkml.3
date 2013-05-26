Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab3EZTcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 15:32:46 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:33275 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3EZTcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 15:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130526191124.GB32729@thunk.org>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
	<CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
	<20130525165710.GC25399@ZenIV.linux.org.uk>
	<51A1040A.80003@schaufler-ca.com>
	<20130526120251.GA32729@thunk.org>
	<51A25305.90101@schaufler-ca.com>
	<20130526191124.GB32729@thunk.org>
Date: Sun, 26 May 2013 12:32:44 -0700
X-Google-Sender-Auth: BreCp1eUdSoMimMCBssX_aTwKxI
Message-ID: <CA+55aFxueg-wBRdUw=S=TOAnHy3BorGYMzffiDkjU90BCTzcig@mail.gmail.com>
Subject: Re: Stupid VFS name lookup interface..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 12:11 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> And if we can't rip out that fundamental assumption, it's not obvious
> to me it will be possible to simplify the core LSM architecture.

One thing that may be sufficient is to maintain a complex model as a
*possible* case, but make sure that we handle the simple cases well.

For example, a "security cache" *might* be as simple as a single bit
saying "this inode has no special file permissions outside the normal
UNIX ones".

For example, the biggest win in the whole POSIX ACL cache was not
actually caching POSIX ACL's at all - even though it does that - but
caching the fact that a particular file did *not* have any POSIX ACL's
associated with it. So the POSIX AXL cache was very much designed to
have separate states for "I don't have a cache entry" and "I have an
empty cache entry". And 99% of the time, that negative cache is
sufficient.

Similarly, for at least the filesystem security case, if we had a "the
owner of this file can do all the normal operations on it" bit, that
would generally take care of 99% of all home directory operations. If,
in addition to that, there's some way to mark other "normal"
directories as having only normal UNIX security semantics (ie /home
and /usr), that would take care of most of the rest.

Having to call into the security layer when you cross some special
boundary is fine. It's doing it for every single path component, and
every single 'stat' of a regular file - *THAT* is what kills us.

So complexity could be ok. As long as the common case isn't complex,
and as long as there's a simple way to check that. We don't
necessarily need to simplify things in the general case.

             Linus
