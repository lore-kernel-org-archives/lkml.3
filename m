Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaD2VS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:18:58 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:32468 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbaD2VS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:18:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnZMACoWYFN5LEcvPGdsb2JhbABZgwaIRKN/AQEBBZl3gSMXAwEBAQE4NYIlAQEFOhwjEAgDGAklDwUlAwcaE4hAyVcXFoU/iHoHgySBFQSZD5YmKw
Date: Wed, 30 Apr 2014 07:18:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140429211851.GA32204@dastard>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
 <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
 <20140429181610.GJ18016@ZenIV.linux.org.uk>
 <20140429191015.GK18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429191015.GK18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 08:10:15PM +0100, Al Viro wrote:
> On Tue, Apr 29, 2014 at 07:16:10PM +0100, Al Viro wrote:
> > On Tue, Apr 29, 2014 at 08:03:24PM +0200, Miklos Szeredi wrote:
> > 
> > > Introducing a new per-sb lock should be OK.
> > > 
> > > Another idea, which could have subtler effects, is simply not to kill
> > > a dentry that is on the shrink list (indicated by
> > > DCACHE_SHRINK_LIST), since it's bound to get killed anyway.  But
> > > that's a change in behaviour...
> > 
> > Umm...  You mean, if final dput() finds dentry already on shrink list,
> > just leave it there and return?  Might get really painful - the code
> > that knows it's holding the last reference to already unhashed dentry
> > might get a nasty surprise when dput() returns before it's killed off.
> 
> I wonder if we could have dput() side of thinks check if we are on the
> shrink list, mark it "I'll be killing it anyway" and go ahead without
> removal from the shrink list and instead of freeing mark it "I'm done
> with it".  With shrink_dentry_list(), on the other hand, checking for those
> marks, treating the former as "just move it to private list and keep
> going".  After the list of victims is dealt with, keep picking dentries
> from the second list, wait for them to get the second mark and do actual
> freeing.  That ought to avoid any extra locks and preserve all ordering,
> except for that of kmem_cache_free(), AFAICS...
> 
> Comments?

Seems like it would work, but it seems fragile to me - I'm
wondering how we can ensure that the private shrink list
manipulations can be kept private.

We have a similar situation with the inode cache (private shrink
list) but the I_FREEING flag is set the entire time the inode is on
the shrink list. Any new hash lookup or attempt to grab the inode
that occurs while I_FREEING is set fails, so perhaps dentries also
need a well defined "being torn down and freed" state where new
references cannot be taken even though the dentry can still be
found...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
