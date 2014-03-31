Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaCaKpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:45:21 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55054 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbaCaKpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:45:18 -0400
Date: Mon, 31 Mar 2014 11:44:59 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jim Lieb <jlieb@panasas.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com, Jeff Layton <jlayton@redhat.com>
Subject: Re: Thoughts on credential switching
Message-ID: <20140331114459.4b3638f8@alan.etchedpixels.co.uk>
In-Reply-To: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014 17:23:24 -0700
Andy Lutomirski <luto@amacapital.net> wrote:

> Hi various people who care about user-space NFS servers and/or
> security-relevant APIs.
> 
> I propose the following set of new syscalls:
> 
> int credfd_create(unsigned int flags): returns a new credfd that
> corresponds to current's creds.
> 
> int credfd_activate(int fd, unsigned int flags): Change current's
> creds to match the creds stored in fd.  To be clear, this changes both
> the "subjective" and "objective" (aka real_cred and cred) because
> there aren't any real semantics for what happens when userspace code
> runs with real_cred != cred.

What is the sematic of a simultaneous ptrace racing a credfd_activate on
another processor core ?

What are the rules for simultaneous threads doing I/O and and credential
changes ?

What is the rule for a faulting of an mmapped page in a multithreaded app
one thread of which has changed credentials ?

Who owns a file created while you are changing credentials ?

>  - credfd_activate fails (-EINVAL) if dumpable.  This is because we
> don't want a privileged daemon to be ptraced while impersonating
> someone else.

That's one of the obvious problems but if you have that problem then
you've got races against signals and ptrace etc to deal with.

One way to implement it I think safely but which requires a fair bit more
work elsewhere is to apply the debug and signal type checks as

   'you may only do X if you also posess the right to do so for *all*
    credentials accessible to this task'

which I think is the correct logical check.

Alan
