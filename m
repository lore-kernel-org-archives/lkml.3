Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab3CLRsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724Ab3CLRsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:48:43 -0400
Date: Tue, 12 Mar 2013 18:46:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: Regression with orderly_poweroff()
Message-ID: <20130312174623.GA14509@redhat.com>
References: <1363058712.4534.12.camel@pasglop> <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12, Linus Torvalds wrote:
>
> On Mon, Mar 11, 2013 at 8:25 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > A couple of weeks ago, David sent an email that went unanswered about a
> > regression concerning orderly_poweroff(). I think the original patch
> > causing it should be reverted, here's the actual email with the
> > explanation:
>
> Hmm.. You should really have cc'd the people who acked it and were in
> the sign-off chain too, because all those people are involved with the
> patch as well.
>
> Also, the patch doesn't revert cleanly any more after commit
> 7ff6764061ec ("usermodehelper: cleanup/fix __orderly_poweroff() &&
> argv_free()") which seems to be a real bug-fix for a double free, but
> which really doesn't seem to work together with UMH_NO_WAIT.
>
> So before reverting that one too, let's at least get the people who
> were involved with the original patch (and the bugfix that relies on
> it) in the email thread.
>
> I'm leaving David's quoted report for the new people..
>
>                 Linus
>
> ---
> > Subject: orderly_poweroff() is no longer safe in atomic context
> >
> > Commit 6c0c0d4d1080840eabb3d055d2fd81911111c5fd "poweroff: fix bug in
> > orderly_poweroff()" apparently fixes one bug in orderly_poweroff(),
> > but introduces another.  The comments on orderly_poweroff() claim it
> > can be called from any context - and indeed we call it from interrupt
> > context in arch/powerpc/platforms/pseries/ras.c for example.  But
> > since that commit this is no longer safe, since
> > call_usermodehelper_fns() is not safe in interrupt context without the
> > UMH_NO_WAIT option.
> >
> > I'm having trouble understanding the commit message to see what the
> > original bug being fixed was.  Specifically I can't make sense of:
> >
> >   |  The bug here is, step 1 is always successful with param
> >   |  UMH_NO_WAIT, which obey the design goal of orderly_poweroff.

I guess this means that UMH_NO_WAIT is pointless, it (almost) never
fails and thus we do not do kernel_power_off() if, say, there is no
/sbin/poweroff.

Well, if it can be called from interrupt, we should either skip
call_usermodehelper() or use schedule_work() for that...

And I didn't notice argv_split(GFP_ATOMIC), this is pointless because
we are going to sleep anyway.

So,

	- We can simply change orderly_poweroff() to use queue_work().

	  This makes it asynchronous even if we do not run the command.

	  And with this change it can only return the error if powerof_work
	  is already pending, perhaps this is fine. Only 2 callers check
	  the returned error just to print the warning. And this way
	  we can kill inprog/shutting_down in envctrl_do_shutdown() and
	  do_envctrl_shutdown().

	- We can add orderly_poweroff_async() which does this, and change
	  the in_atomic() callers.

	- We can add "bool in_atomic" argument which means do-not-exec
	  or use-workqueue.

	- Anything else?

Oleg.

