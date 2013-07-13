Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab3GMLmZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:42:25 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37435 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab3GMLmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:42:23 -0400
Date: Sat, 13 Jul 2013 07:42:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130713114211.GA3112@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Willy Tarreau <w@1wt.eu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable <stable@vger.kernel.org>
References: <20130711222935.GA11340@redhat.com>
 <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712195051.GB32054@1wt.eu>
 <20130713062223.GA15155@kroah.com>
 <20130713063607.GI32054@1wt.eu>
 <20130713064801.GA1305@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713064801.GA1305@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 11:48:01PM -0700, Greg Kroah-Hartman wrote:
> > It's the difference between "this is a fix" and "please backport this
> > fix into stable". As we aid in this thread, cc:stable is a bit too much
> > automatic and sometimes not appropriate (not important enough fixes).
> 
> No, I've never said that.

You've not said this, but Linus has.  Linus has pointed at the
following words which are in stable_kernel_rules:

 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.                                             ^^^^^^^^^^^^^^^^^^^
   ^^^^^^^^

> I _want_ fixes in stable trees, as they are being done to, obviously,
> fix problems.  So does Linus, why wouldn't a fix for something that is
> an issue for someone _not_ go into his tree after -rc4?

Linus has said he doesn't want fixes that aren't CRITICAL after -rc4.

So the problem is there's apparently a discrepancy between your
standards for when a patch should hit stable, and Linus's criteria for
post-rc4 inclusion.

Originally, this boundary for "nothing but regressions and critical
fixes" was -rc3 at the latest, which is why I've sat on fixes after
-rc2 has been released.  But since you've wanted these fixes, I would
mark them stable, with the assumption that by the time I've completed
all of the regression tests before the merge window, it would be fine
for stable.

Here's another real-life situation which is happening right now.  It's
almost -rc1, and I've believe that discovered a potential ext4 bug
fix.  It fixes a long-standing xfstest failure, that we've been trying
to track down for several releases.  This is the sort of thing that
stable enterprise distro's would want (eventually), since otherwise
their help desks would be tearing their hair out with a
hard-to-reproduce and hard-to-root-cause bug report from the field.
I'll probably want to push out this fix to Linus, assuming it passes
all of my regression tests --- especially since Linus has said he'll
now take bug-fixes before -rc4.

But is this the sort of thing that we would want in stable right away?
I was thinking that perhaps the right thing to do was to mark it with
a "Fixes: v3.8" (indicating that eventually this may want to be sent
to all stable kernel releases v3.8+), but perhaps it shouldn't be
automatically scooped up for stable, at least until a week or two
after 3.11 comes out and we're sure that the bug fix doesn't introduce
some other regression.

I'll note that technically this fix might not meet the "something
critical" test in stable_kernel_rules, since it only occurs under
extreme memory pressure, and it's otherwise extraordinarily hard to
reproduce (but this is why it's extraordinarily expensive for
enterprise distros to root cause these sorts of problem when they are
reported from the field).

> I _should_ be seeing more patches marked for stable showing up after
> -rc3 then for -rc1.  As it is, I think there's something wrong with
> maintainers relying on me to do their work for them too much, and it's
> finally pushed me to start complaining and pushing back.

How about this?  If patches marked for stable show up after 3.11-rc2,
or 3.11-rc3, could they not get automatically scooped up until a week
after 3.11 comes out?  If a post-rc2 patch shows up in 3.10.x before
3.11 comes out, and it is not a __critical__ bug fix, I would be
really uncomfortable about accidentally introducing a regression into
the stable kernel tree --- at least for a subsystem like ext4, where a
regression might lead to data corruption (which generally makes users
a lot more cranky than a bug in some random graphics driver which just
causes their system to reboot.)

If it's critical, I'll explicitly send it to stable@vger.kernel.org;
but if it's not critical, I really would like more soak time in
mainline before it gets picked up for stable.  If you don't think this
is appropriate for all subsystems, maybe it could be a per-subsystem
policy --- but I really think this is a good idea for everyone.

Regards,

						- Ted

P.S.  Maybe this is a grey area that you're not worried about, and
you're actually getting more cranky about people labelling whitespace
fixes with stable@vger.kernel.org.  My personal policy is those sorts
of changes should *** NEVER *** be sent to the stable kernel series,
regardless of when they hit either my tree or mainline....
