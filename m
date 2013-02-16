Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3BPBWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 20:22:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33875 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3BPBWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 20:22:45 -0500
Date: Sat, 16 Feb 2013 01:22:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shentino <shentino@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
Message-ID: <20130216012242.GZ4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk>
 <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk>
 <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk>
 <CA+55aFyzGenPNnKxf_PnAWVa1tZP294XUrhAVXgi0EuKm1x=vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyzGenPNnKxf_PnAWVa1tZP294XUrhAVXgi0EuKm1x=vA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 04:40:18PM -0800, Linus Torvalds wrote:
> On Fri, Feb 15, 2013 at 4:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Fri, Feb 15, 2013 at 03:12:30PM -0800, Shentino wrote:
> >> > +                               send_sig(SIGSEGV, current, 0);
> >>
> >> This might be a stupid miscue on my part, but shouldn't it be
> >> force_sig instead of send_sig?
> >>
> >> I've got this crazy hunch that having SEGV masked might muck something up.
> >
> > How would you manage to have it masked at that point?  setup_new_exec()
> > is inevitable after success of flush_old_exec() and it will do
> > flush_signal_handlers() for us.
> 
> I have to agree with Shentino on this one: it's entirely possible that
> send_sig() is always equivalent to force_sig() in this circumstance,
> but rather than depend on that kind of non-local subtlety, we should
> just make it obvious. This is what "force_sig()" exists for - making
> it clear that we punch through any signal handlers. Whether such a
> signal handler can exist or not is kind of immaterial.

*shrug*

Fine by me - the variant I'd posted simply moved these calls in one
place; I've no problem with replacing them with force_sig() (or
force_sigsegv(SIGSEGV, current), for paranoia sake).  OTOH, I'd probably
prefer to make it a separate commit.

FWIW, now that I've looked into what's involved in merging flush_old_exec()
and setup_new_exec()...  Here's something that looks like a bug:
#include <sys/personality.h>
#include <unistd.h>
main()
{
	char *argv[] = {"uname", "-m", "-r", NULL};
	char *envp[] = {NULL};
	personality(0x0020000);	/* UNAME26 */
	execve("/bin/uname", argv, envp);
}

On amd64 testbox (3.0.60-based kernel):
2.6.40+ x86_64
On alpha:
3.3.6+ alpha

Cause: SET_PERSONALITY() on alpha doesn't care to preserve the upper bits
of current->personality and just does either set_personality(PER_LINUX) or
set_personality(PER_LINUX_32BIT).
