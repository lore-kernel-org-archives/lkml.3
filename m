Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaCaQt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:49:28 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:43067 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbaCaQtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:49:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140331114459.4b3638f8@alan.etchedpixels.co.uk>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <20140331114459.4b3638f8@alan.etchedpixels.co.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 31 Mar 2014 09:49:03 -0700
Message-ID: <CALCETrX7mxsWTsvcZJ=i0GOPvUp7TRvbrgNCq3Ajk8YK7FFnaA@mail.gmail.com>
Subject: Re: Thoughts on credential switching
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jim Lieb <jlieb@panasas.com>, Jeff Layton <jlayton@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>, bfields@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 31, 2014 3:45 AM, "One Thousand Gnomes"
<gnomes@lxorguk.ukuu.org.uk> wrote:
>
> On Wed, 26 Mar 2014 17:23:24 -0700
> Andy Lutomirski <luto@amacapital.net> wrote:
>
> > Hi various people who care about user-space NFS servers and/or
> > security-relevant APIs.
> >
> > I propose the following set of new syscalls:
> >
> > int credfd_create(unsigned int flags): returns a new credfd that
> > corresponds to current's creds.
> >
> > int credfd_activate(int fd, unsigned int flags): Change current's
> > creds to match the creds stored in fd.  To be clear, this changes both
> > the "subjective" and "objective" (aka real_cred and cred) because
> > there aren't any real semantics for what happens when userspace code
> > runs with real_cred != cred.
>
> What is the sematic of a simultaneous ptrace racing a credfd_activate on
> another processor core ?

Exactly the same as for the raw syscall setresuid.  That is, we
require sequential consistency.  If the kernel fails to provide
sequential consistency, it's a bug.

>
> What are the rules for simultaneous threads doing I/O and and credential
> changes ?

None.  credfd_activate affects only the calling thread.

>
> What is the rule for a faulting of an mmapped page in a multithreaded app
> one thread of which has changed credentials ?

Same as in current kernels.  Note that checking credentials in
readpage, etc. is generally a bug.

>
> Who owns a file created while you are changing credentials ?

Can't happen.  See above.

>
> >  - credfd_activate fails (-EINVAL) if dumpable.  This is because we
> > don't want a privileged daemon to be ptraced while impersonating
> > someone else.
>
> That's one of the obvious problems but if you have that problem then
> you've got races against signals and ptrace etc to deal with.
>
> One way to implement it I think safely but which requires a fair bit more
> work elsewhere is to apply the debug and signal type checks as
>
>    'you may only do X if you also posess the right to do so for *all*
>     credentials accessible to this task'
>
> which I think is the correct logical check.

Do we include credfd fds sitting in Unix sockets?

More generally, there are plenty of cases where ptracing something
might give you access to one of its fds that you shouldn't normally
have access to.  Even real file fds are like this, and they could come
from outside a namespace, they could be a result of odd selinux
policy, etc.

The only real new issue is that, while using a subsidiary credential,
you don't want people who couldn't ptrace you before to suddenly be
able to ptrace you.  This is where "subjective" and "objective"
credentials came from, but the current in-kernel implementation is
really half-baked.  Fixing it for real will probably run into all
kinds of funny corner cases involving the existing syscalls, and it
would be nice to have a way to handle this that doesn't involve
auditing every commit_creds caller.

Hmm.  What if we had initial_creds and creds, and initial_creds never
changed unless explicitly requested.  There wouldn't be any way to
revert to initial_creds, but may_ptrace would check initial_creds
*and* creds.  This is a little hacky, and it might break Android (I'm
not really sure how the zygote thing works), but it could do the
trick.

Or we can rely on dumpable, which I think can prevent unprivileged
ptracers from attaching.

--Andy
