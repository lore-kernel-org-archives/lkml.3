Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3EZTLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 15:11:34 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:51981 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab3EZTLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 15:11:33 -0400
Date: Sun, 26 May 2013 15:11:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: Stupid VFS name lookup interface..
Message-ID: <20130526191124.GB32729@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Paris <eparis@redhat.com>,
	James Morris <james.l.morris@oracle.com>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
 <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
 <20130525165710.GC25399@ZenIV.linux.org.uk>
 <51A1040A.80003@schaufler-ca.com>
 <20130526120251.GA32729@thunk.org>
 <51A25305.90101@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A25305.90101@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 11:23:01AM -0700, Casey Schaufler wrote:
> I believe that Yama points to a serious change in the way
> "operating systems" are being developed. The desktop is not
> the sweet spot for Linux development, nor is the enterprise
> server. Six years ago the Bell & LaPadula subject/object models
> still made sense. Today, we're looking at applications, services
> and resources. We don't have LSMs that support those* natively.
> We are going to have new LSMs, and soon, if Linux is going to
> remain relevant.

Oh, I agree, having worked on a TS project involving real-time Linux
that did not even try to use a Bell-LaPadula security model on the
Linux system.

The challenge is that although the world does seem to be moving
towards using air gap firewalls and separate single-level systems
(using trusted message passing routers and/or trusted hypervisors)
instead of a MLS design, I'm sure there will still be some
applications where people will want a Bell-LaPadula security model.
And if we can't rip out that fundamental assumption, it's not obvious
to me it will be possible to simplify the core LSM architecture.

We also have to consider especially how much sunk costs have been
invested in systems such as SELinux which can support (but which are
not limited to) Bell-LaPadula.  If we simplify the LSM architecture,
but it requires a radical rewrite of systems where massive amounts of
effort have been poured into make them somewhat easier to use
(although personally I'm not convinced that a policy file which is
hundreds of kilobytes qualifies as "easy" to debug or to validate), I
suspect the people who don't feel like throwing all of that heavy
investment away will resist such an initiative mightily.  (Not to
mention that if we break backwards compatibility, we will end up
breaking userspace for deployed enterprise distro's.)

And yet, if we don't rip out some of these assumptions, it's not
obvious to me how much even Linus's caching idea is going to buy us.
A generic caching layer still has to include in its hash all of the
possible inputs that a LSM module might want to use as part of its
access decision.  If this includes the pathname, then you'll have to
lock a whole bunch of dentries while you calculate its hash ---
something that wouldn't be necessary for SELinux, for example.  And
I'm sure SELinux uses some things when making its access decisions
which Smack does not need, and so on.  So a generalized caching scheme
might not result in any any performance wins; it might even be worse
than what we have today!

So I'm dubious --- but maybe this is something which a Security
working group could maybe try to hash out at a face-to-face meeting.
Given our past track record of coming to consensus, I suspect
face-to-face has a higher chance of working --- who knows, maybe hell
will freeze over or pigs will end up nesting in trees.  :-)

Cheers,

					- Ted
