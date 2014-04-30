Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbaD3Sgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:36:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49384 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759421AbaD3Sgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:36:52 -0400
Date: Wed, 30 Apr 2014 19:36:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430183650.GQ18016@ZenIV.linux.org.uk>
References: <20140429211851.GA32204@dastard>
 <20140429214842.GL18016@ZenIV.linux.org.uk>
 <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430040436.GO18016@ZenIV.linux.org.uk>
 <20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
 <20140430160345.GP18016@ZenIV.linux.org.uk>
 <CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 07:33:38PM +0200, Miklos Szeredi wrote:
> On Wed, Apr 30, 2014 at 6:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Wed, Apr 30, 2014 at 05:49:58PM +0200, Miklos Szeredi wrote:
> >> > FWIW, the first two are really straightforward expanding the function
> >> > into its only callsite.  The last needs more splitup.  Not sure if the
> >> > following is good enough, but it ought to be at least somewhat cleaner.
> >> > Combined change is identical to the original, so it doesn't invalidate
> >> > the testing so far...
> >>
> >> Hmm, patches look okay, but I'm wondering if we really need the morgue list and
> >> the waiting.  Why not just skip dentries that are presently being handled by
> >> dentry_kill()?
> >
> > Who will be freeing them?  If we do that from dentry_kill(), we are back to
> > needing them removed from shrink list by something called by dput().  And
> > if we do that from shrink_dentry_list(), we'd damn better wait for
> > dentry_iput() et.al. to finish.
> 
> We can do it from dput if the shrinker gets there first and from the
> shrinker if dput manages to finish before.  See the updated patch in
> the previous mail.

Er?  The only patch I see is removal of RCU from shrink_dentry_list(), which
is fine, but doesn't do anything of that sort.  What was the Message-ID?

Let me see if I understand what you are proposing:
	dentry_kill(dentry, 0) seeing DCACHE_DENTRY_KILLED
		check DCACHE_MAY_FREE, free it's been set
	dentry_kill(dentry, 1) seeing that we are on shrinker list
		leave on the list, do the work on killing, retake ->d_lock,
		if we are still on shrinker list
			set DCACHE_MAY_FREE,
		else
			free it

That would probably work...
