Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3HVTjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:39:21 -0400
Received: from 1wt.eu ([62.212.114.60]:35550 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab3HVTjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:39:19 -0400
Date: Thu, 22 Aug 2013 21:39:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
Message-ID: <20130822193910.GJ31117@1wt.eu>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net> <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com> <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 12:05:50PM -0700, Andy Lutomirski wrote:
> On Thu, Aug 22, 2013 at 11:53 AM, Willy Tarreau <w@1wt.eu> wrote:
> > On Thu, Aug 22, 2013 at 11:48:10AM -0700, Linus Torvalds wrote:
> >> And I'm wondering if we shouldn't actually do that at "path_init"
> >> time. Right now the code says:
> >>
> >>                 /* Caller must check execute permissions on the
> >> starting path component */
> >>                 struct fd f = fdget_raw(dfd);
> >>
> >> and then uses the struct file mindlessly.
> >>
> >> I'm wondering if we should just do some validation in that place, and say:
> >>
> >>  - for directories, we require exec permissions here
> >>  - for everything else, we require that f->f_cred == current->cred check.
> 
> Does this work for the procfs case?  As far as I understand it (which
> isn't saying much), it goes through the symlink-following path.

Indeed I checked yesterday that it seems to use proc_pid_follow_link() for
fd/, cwd, root and exe, which means the same tests are used everywhere.

> >> I dunno. But that I_LINKABLE thing just bothers me. It screams "I'm
> >> hacky" to me.
> >
> > I agreed, simply because the condition here is different from the one in /proc.
> >
> > I have read some code last evening to try to understand how /proc/pid/fd
> > entries were granted access to various processes, because I would love to
> > see the same condition being used in both places. Unfortunately, it's beyond
> > my skills, and I stopped after my random attempts gave me some panics.
> 
> What if we added another field to struct nameidata that's indicates
> what restrictions need to be enforced when following magical symlinks
> and then enforcing them when nd_jump_link gets used.  (There are only
> two of these, both in procfs.)

I tried to add a test based on a mount option before this call to
nd_jump_link() when I realized my attempt was a total disaster because
I'm a noob. But what I think would be nice (at least as an opt-in) would
be :

  - processes which don't share the same root should not be allowed to
    access files through /proc/pid/{root,cwd,exe,fd/*}

  - keep the current restrictions as well of course

  - the exact same restrictions should apply to AT_EMPTY_PATH

I might be totally wrong, but as a user that's what I find natural and
what I tend to expect.

> Then open could check that the original fd was opened for a superset
> of the requested permissions (or that the caller has
> CAP_DAC_OVERRIDE), linkat could check whatever it feels like checking,
> etc.

Do not forget that 2 other syscalls seem to support AT_EMPTH_PATH as
well if that makes a difference.

> This would allow all of these issues to be fixed for real (controlled
> by sysctl, presumably).

If needed for backwards compatibility, possibly, though I doubt that
there are apps that *rely* on the current lack of isolation between
chroots. But at the same time I hate to break existing setups :-)

> --Andy

Willy

