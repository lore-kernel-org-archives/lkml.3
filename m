Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3CKACL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 20:02:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36455 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3CKACK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 20:02:10 -0400
Date: Mon, 11 Mar 2013 00:02:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG_ON(nd->inode->i_op->follow_link);
Message-ID: <20130311000207.GD21522@ZenIV.linux.org.uk>
References: <20130307021645.GA10173@redhat.com>
 <20130307153052.GA18246@redhat.com>
 <CA+55aFyVZeDswi=M65ULQkGCvJq5vsASLqGCtufH3TcS--MC1Q@mail.gmail.com>
 <20130307193501.GA2802@redhat.com>
 <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307221800.GA572@redhat.com>
 <CA+55aFwObv7--izbae5YdXX3AhoHfV0YwbSLQoonTf-=e4PzqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwObv7--izbae5YdXX3AhoHfV0YwbSLQoonTf-=e4PzqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 02:50:55PM -0800, Linus Torvalds wrote:

> and you get the oops, because when it follows that pseudo-symlink for
> fd3, it will hit that symlink we just looked up. And trigger the
> BUG_ON() you see.
> 
> Al, I think the BUG_ON() is simply bogus. Should we just remove it? Or
> is there some conceptual reason why we can't handle a symlink there?

BUG_ON() is bogus these days, but failing ->follow_link() is not.  The thing
is, what would you do with that sucker?  Suppose you have ->follow_link()
leaving you in a symlink.  What would you do with it?  Either you were
not going to follow it (in which case you wouldn't have called ->follow_link()
in the first place) *or* you need to know which directory it's in.  Which
we don't have in this case...

It really used to be an impossible case, until we'd introduced O_PATH.  And
IIRC, back when O_PATH had been developed, the plan was to fail attempts
to follow these suckers with -ELOOP; looks like we forgot to do that.  Mea
culpa...

And no, just removing BUG_ON() is not enough - callers of follow_link() will
do rather weird stuff (in nested symlink case it'll fail with ENOTDIR, in
path_lookupat() with LOOKUP_FOLLOW it'll give you a symlink, in case of
path_openat() with LOOKUP_FOLLOW fail with ELOOP).

See the patch I'd posted upthread.  Let's make it fail consistently...
