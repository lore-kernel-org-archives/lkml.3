Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbaD2TKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:10:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46411 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759AbaD2TKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:10:18 -0400
Date: Tue, 29 Apr 2014 20:10:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140429191015.GK18016@ZenIV.linux.org.uk>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
 <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
 <20140429181610.GJ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429181610.GJ18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 07:16:10PM +0100, Al Viro wrote:
> On Tue, Apr 29, 2014 at 08:03:24PM +0200, Miklos Szeredi wrote:
> 
> > Introducing a new per-sb lock should be OK.
> > 
> > Another idea, which could have subtler effects, is simply not to kill
> > a dentry that is on the shrink list (indicated by
> > DCACHE_SHRINK_LIST), since it's bound to get killed anyway.  But
> > that's a change in behaviour...
> 
> Umm...  You mean, if final dput() finds dentry already on shrink list,
> just leave it there and return?  Might get really painful - the code
> that knows it's holding the last reference to already unhashed dentry
> might get a nasty surprise when dput() returns before it's killed off.

I wonder if we could have dput() side of thinks check if we are on the
shrink list, mark it "I'll be killing it anyway" and go ahead without
removal from the shrink list and instead of freeing mark it "I'm done
with it".  With shrink_dentry_list(), on the other hand, checking for those
marks, treating the former as "just move it to private list and keep
going".  After the list of victims is dealt with, keep picking dentries
from the second list, wait for them to get the second mark and do actual
freeing.  That ought to avoid any extra locks and preserve all ordering,
except for that of kmem_cache_free(), AFAICS...

Comments?
