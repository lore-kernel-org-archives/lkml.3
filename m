Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaECSVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 14:21:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36757 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaECSVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 14:21:13 -0400
Date: Sat, 3 May 2014 19:21:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140503182110.GN18016@ZenIV.linux.org.uk>
References: <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
 <20140502055127.GH18016@ZenIV.linux.org.uk>
 <CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
 <20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFzbtGwxTf_d97pSLc4hAciErGDdkOSzLkpt_hP-UmLPWg@mail.gmail.com>
 <20140502224022.GJ18016@ZenIV.linux.org.uk>
 <20140503042604.GM18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140503042604.GM18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 05:26:04AM +0100, Al Viro wrote:

> See vfs.git#dentry_kill-3; warning - this is completely untested and I would
> really like comments on spinning case there (i.e. the one where select_collect()
> finds some stuff already on some other shrink list and nothing with zero
> refcount that wouldn't be there).  In that case (and it's basically "somebody
> else is evicting stuff in our subtree and they'd already picked everything
> we want evicted") I just let the loop in check_submounts_and_drop() repeat
> (we do have cond_resched() there).  Any better suggestions would be welcome...

Hmm...  As the matter of fact, the whole shrink_dcache_for_umount() could
be made a lot saner.  What we need is to reuse shrink_dcache_parent()
and follow it with d_walk() that would just go through whatever remains and
complain about the leaves of that.  For anon roots we'll obviously need to
wrap that into dget and d_drop/dput.

I'm testing that right now; everything seems to be working so far and if
it survives, I'll push that sucker out.  Total since the beginning of
the whole series:
 fs/dcache.c            |  310 ++++++++++++++++++++++++++++++++---------------------------------------------------------
 include/linux/dcache.h |    2 +
 2 files changed, 112 insertions(+), 200 deletions(-)

Anyway, I'm off to finish with acct.c races, then it's time for Eric's
lazy umount on unlink series; this work is getting unpleasantly close
to the areas he's touching, so I'd better get it on top of this stuff
and into -next...
