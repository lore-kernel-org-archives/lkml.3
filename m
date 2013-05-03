Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3ECEJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:09:41 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49299 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3ECEJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:09:39 -0400
Date: Thu, 2 May 2013 21:09:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jeff Layton <jlayton@redhat.com>,
        Mandeep Baines <msb@chromium.org>
Subject: Re: [PATCH v2 03/10] freezer: add new freezable helpers using
 freezer_do_not_count()
Message-ID: <20130503040934.GA16968@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
 <1367458508-9133-4-git-send-email-ccross@android.com>
 <20130502235505.GW19814@mtj.dyndns.org>
 <20130503000358.GX19814@mtj.dyndns.org>
 <CAMbhsRSFjUvkXq66pYs_nYN5At7yB4sFM+cpxLgUF_Yns54J5A@mail.gmail.com>
 <CAMbhsRTSCW3WOxTgw8btk2yWAucqNmyY-Sc+CHsHmZzf6ZsTNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRTSCW3WOxTgw8btk2yWAucqNmyY-Sc+CHsHmZzf6ZsTNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 02, 2013 at 07:41:39PM -0700, Colin Cross wrote:
> On Thu, May 2, 2013 at 7:16 PM, Colin Cross <ccross@android.com> wrote:
> > This sounds the same as what ended up getting reverted in
> > https://lkml.org/lkml/2013/3/4/221
> > I can add the WARN_ON_ONCE to all my new calls, and leave them out of
> > existing calls, but that seems a little odd, and will be redundant if
> > the lockdep call in try_to_freeze goes back in in 3.11.  Do you still
> > want it in the new apis?
...
> I could also put the lockdep check that was reveted back into
> try_to_freeze(), and add a freezable_schedule_unsafe() that skips it
> for use in the known-unsafe users in nfs, with a big comment not to
> add new users of it.

Oh yeah, that sounds like a good idea, and as for the non-ugly
variants, at least in the mid/long term, I think it'd be best to add
the lockdep annotation to try_to_freeze() with
__try_to_freeze_unsafe_youre_gonna_burn_in_hell_if_you_use_this() for
the existing users which should be gradually converted, but if that's
too burdensome, adding warnings to the wrappers should do for now, I
guess.

And I *hope* the lockdep annotation is stricter than what was added
before.  I think it better be "no lock ever should be held at this
point" rather than "consider this a big lock".  I'm not sure how much
consensus we have on this but I'd like to, in the longer term, merge
freezer into job control stop so that frozen tasks don't appear as
being in uninterruptible sleep.  Currently, the frozen tasks are
essentially in UNINTERRUPTIBLE sleep which is okay for suspend but for
cgroup freezer, it sucks.  You end up with tasks which you can't even
kill.

Combined with the locking problems, I was planning to update the
freezer such that the frozen state is implemented as a form of jobctl
stop, so that things like ptrace / kill -9 could work on them and we
also have the clear definition of the frozen state rather than the
current "it may get stuck somewhere in the kernel".

But that conflicts with what you're doing here which seems pretty
useful, so, to satisfy both goals, when somebody needs to put a
pseudo-frozen task into the actual frozen jobctl stop, those spots
which are currently using try_to_stop() would have to return an error,
most likely -EINTR with TIF_SIGPENDING set, and the control should
return towards userland so that signal handling path can be invoked.
ie. It should be possible to steer the tasks which are considered
frozen but not in the frozen jobctl stop into the jobctl stop without
any side effect.  To do that, those spots basically have to be pretty
close to the userland boundary where it can easily leave the kernel
with -EINTR and AFAICS all the spots that you converted are like that
(which I think is natural).  While not holding any locks doesn't
guarantee that, I think there'd be a fairly high correlation at least
and it'd be able to drive people towards finding out what's going on.

So, that's my agenda.  Not sure how many actually agree with it.
Rafael, Oleg, Jeff?

Thanks.

-- 
tejun
