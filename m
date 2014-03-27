Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbaC0SeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:34:24 -0400
Received: from fn.samba.org ([216.83.154.106]:44893 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbaC0SeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:34:22 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2014 14:34:22 EDT
Date: Thu, 27 Mar 2014 11:26:17 -0700
From: Jeremy Allison <jra@samba.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Subject: Re: Thoughts on credential switching
Message-ID: <20140327182617.GC2526@jeremy-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <53341D8E.80105@redhat.com>
 <20140327060225.4f4caa5a@ipyr.poochiereds.net>
 <53342258.8000304@redhat.com>
 <20140327070126.41ac75ac@ipyr.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140327070126.41ac75ac@ipyr.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 07:01:26AM -0700, Jeff Layton wrote:
> On Thu, 27 Mar 2014 14:06:32 +0100
> Florian Weimer <fweimer@redhat.com> wrote:
> 
> > On 03/27/2014 02:02 PM, Jeff Layton wrote:
> > 
> > >> This interface does not address the long-term lack of POSIX
> > >> compliance in setuid and friends, which are required to be
> > >> process-global and not thread-specific (as they are on the kernel
> > >> side).
> > >>
> > >> glibc works around this by reserving a signal and running set*id on
> > >> every thread in a special signal handler.  This is just crass, and
> > >> it is likely impossible to restore the original process state in
> > >> case of partial failure.  We really need kernel support to perform
> > >> the process-wide switch in an all-or-nothing manner.
> > >>
> > >
> > > I disagree. We're treading new ground here with this syscall. It's
> > > not defined by POSIX so we're under no obligation to follow its
> > > silly directives in this regard. Per-process cred switching doesn't
> > > really make much sense in this day and age, IMO. Wasn't part of the
> > > spec was written before threading existed
> > 
> > Okay, then we need to add a separate set of system calls.
> > 
> > I really, really want to get rid of that signal handler mess in
> > glibc, with its partial failures.
> > 
> 
> I agree, it's a hack, but hardly anyone these days really wants to
> switch creds on a per-process basis. It's just that we're saddled with
> a spec for those calls that was written before threads really existed.
> 
> The kernel syscalls already do the right thing as far as I'm concerned.
> What would be nice however is a blessed glibc interface to them
> that didn't involve all of the signal handling stuff. Then samba et. al.
> wouldn't need to call syscall() directly to get at them.

Amen to that :-).

However, after talking with Jeff and Jim at CollabSummit,
I was 'encouraged' to make my opinions known on the list.

To me, calling the creds handle a file descriptor just
feels wrong. IT *isn't* an fd, you can't read/write/poll
on it, and it's only done as a convenience to get the
close-on-exec semantics and the fact that the creds are
already hung off the fd's in kernel space.

I'd rather any creads call use a different type, even if
it's a typedef of 'int -> creds_handle_t', just to make
it really clear it's *NOT* an fd.

That way we can also make it clear this thing only has
meaning to a thread group, and SHOULD NOT (and indeed
preferably CAN NOT) be passed between processes.

Cheers,

	Jeremy.
