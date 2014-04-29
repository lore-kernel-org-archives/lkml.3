Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbaD2XEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:04:13 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:49899 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaD2XEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140429214842.GL18016@ZenIV.linux.org.uk>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
	<CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
	<20140429181610.GJ18016@ZenIV.linux.org.uk>
	<20140429191015.GK18016@ZenIV.linux.org.uk>
	<20140429211851.GA32204@dastard>
	<20140429214842.GL18016@ZenIV.linux.org.uk>
Date: Tue, 29 Apr 2014 16:04:11 -0700
X-Google-Sender-Auth: WwLSDWsfj7taJPwPhAhpxvDCGoI
Message-ID: <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 2:48 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Ummm...  You mean, have d_lookup() et.al. fail on something that is on
> a shrink list?

So I tried to see if that would work just consider it dead by the time
it hits the shrink list, and if somebody does a lookup on the dentry,
fail on it and just allocate a new dentry and do a real lookup.

But at a minimum, we have "d_op->d_prune()" that would now be possibly
be called for the old dentry *after* a new dentry has been allocated.
Not to mention the inode not having been dropped. So it looks like a
disaster where the filesystem now ends up having concurrent "live"
dentries for the same entry.  Even if one of them is on its way out,
it's still visible to the filesystem. That makes me very
uncomfortable.

I'm starting to think that Miklos' original patch (perhaps with the
spinlock split to at least be one per superblock) is the most
straightforward approach after all. It's annoying having to add locks
here, but the whole pruning path should not be a hotpath, so maybe
it's not actually a big deal.

               Linus
