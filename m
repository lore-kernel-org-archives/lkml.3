Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3BPCUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 21:20:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34542 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3BPCUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 21:20:08 -0500
Date: Sat, 16 Feb 2013 02:20:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Shentino <shentino@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
Message-ID: <20130216022006.GB4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk>
 <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk>
 <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk>
 <CAGDaZ_rqKR7Ea6SZ9JXmeVOvEBEk3gHaQEa1LAkzWxRHfJsHWw@mail.gmail.com>
 <CAGDaZ_p8Dm+Tco_famKmEzGpV6G+zo1xHLkA7LQCkzQJD_pxMA@mail.gmail.com>
 <20130216015024.GA4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130216015024.GA4503@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 01:50:24AM +0000, Al Viro wrote:
> On Fri, Feb 15, 2013 at 04:46:43PM -0800, Shentino wrote:
> > On Fri, Feb 15, 2013 at 4:38 PM, Shentino <shentino@gmail.com> wrote:
> > > On Fri, Feb 15, 2013 at 4:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >> How would you manage to have it masked at that point?  setup_new_exec()
> > >> is inevitable after success of flush_old_exec() and it will do
> > >> flush_signal_handlers() for us.
> > >
> > > I wouldn't know for sure but I read somewhere that even if execve
> > > resets handled signals, it didn't also say that ignored signals were
> > > also reset.  (Source: execve man page.)
> > 
> > Also, apologies for the terminology mix-up.  By masked, I mean that
> > the signal was ignored as directed by userspace a-la signal(SIGSEGV,
> > SIG_IGN).
> > 
> > Plus I *think* that signal ignore masks are preserved across an exec.
> 
> You are correct.  OK, what it means is that we do need that force_sigsegv() -
> either there or in all places in ->load_binary() where we currently have
> send_sig_info(SIGSEGV).  I don't think that it's an urgent hole, but yes,
> it is a bug.  Nice catch.

Arrgh...  OK, I'm a blind idiot.  These places in binfmt_elf.c currently use
force_sig(), not send_sig_info().  Currently == since 2006 when somebody
noticed the problem.  Their counterparts in binfmt_elf_fdpic.c were *not*
noticed.  Anyway, that definitely means we want to do it in a single commit;
the only remaining question is whether we have any problems with somebody
ptracing such execve() and then poking the sucker with ptrace(); that _can_
happen with the current mainline for ELF binaries, so this is not something
new.  I'm low on coffee and about to crash, so I might be missing some
horrible problem with it, but in this case I'm fairly sure that such a problem
would be present in current mainline.
