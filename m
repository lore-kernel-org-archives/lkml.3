Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaCaTFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:05:38 -0400
Received: from fn.samba.org ([216.83.154.106]:53758 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbaCaTFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:05:35 -0400
Date: Mon, 31 Mar 2014 12:05:34 -0700
From: Jeremy Allison <jra@samba.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com, Jeff Layton <jlayton@redhat.com>
Subject: Re: Thoughts on credential switching
Message-ID: <20140331190534.GA24608@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <20140331114459.4b3638f8@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331114459.4b3638f8@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 11:44:59AM +0100, One Thousand Gnomes wrote:
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
> 
> What are the rules for simultaneous threads doing I/O and and credential
> changes ?
> 
> What is the rule for a faulting of an mmapped page in a multithreaded app
> one thread of which has changed credentials ?
> 
> Who owns a file created while you are changing credentials ?
> 
> >  - credfd_activate fails (-EINVAL) if dumpable.  This is because we
> > don't want a privileged daemon to be ptraced while impersonating
> > someone else.
> 
> That's one of the obvious problems but if you have that problem then
> you've got races against signals and ptrace etc to deal with.

FYI, Any process using pthreads and glibc already
has to cope with these races as setresuid on glibc
on Linux is not atomic.

That's why Samba eventually changed to using the
raw system calls on Linux due to an interesting
bug with glibc aio interacting with setresuid
races (receiving signal thread was uid 0, sending
aio thread was non-zero - signal couldn't be
delivered, glibc aio wakeup lost).

Jeremy.
