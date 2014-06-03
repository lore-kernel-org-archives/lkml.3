Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaFCIlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:41:37 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:46022 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbaFCIle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:41:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AodxALeJjVN5LL1sPGdsb2JhbABZgweDRYUIoxQBAgaYGwGBCxcDAQEBATg1giUBAQQBOhwjEAgDGAklDwUlAwcaE4g6B9E7FxaFP4h9B4MrgRUEmX+LHItcKw
Date: Tue, 3 Jun 2014 18:41:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140603084130.GF14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
 <7106937.MLk03lftzD@wuerfel>
 <20140603003227.GP6677@dastard>
 <5082342.alZgfaU1Q0@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5082342.alZgfaU1Q0@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:33:36AM +0200, Arnd Bergmann wrote:
> On Tuesday 03 June 2014 10:32:27 Dave Chinner wrote:
> > On Mon, Jun 02, 2014 at 01:43:44PM +0200, Arnd Bergmann wrote:
> > > On Monday 02 June 2014 10:28:22 Dave Chinner wrote:
> > > > On Sun, Jun 01, 2014 at 10:24:37AM +1000, Dave Chinner wrote:
> > > > > On Sat, May 31, 2014 at 05:37:52PM +0200, Arnd Bergmann wrote:
> > > My patch set
> > > (at least with the 64-bit tv_sec) just gets 32-bit kernels to behave
> > > more like 64-bit kernels regarding inode time stamps, which does
> > > impact all the file systems that the a 64-bit time or the NFS
> > > unsigned epoch (1970-2106), while your patch extends the file
> > > system internal epoch (1901-2038 for XFS) so it can be used by
> > > anything that knows how to handle larger than 32-bit second values
> > > (either 64-bit kernel or 32-bit with inode_time patch).
> > 
> > Right, but the issue is that 64 bit second counters are broken right
> > now because most filesystems can't support more than 32 bit values.
> > So it doesn't matter whether it's 32 bit or 64 bit machines, just
> > adding explicit support for >32 bit second counters without doing
> > anything else just extends that brokenness into the indefinite
> > future.
> 
> Of course, "most filesystems" are obsolete, and most of the modern
> file systems already support >32 bit timestamps: ext4, btrfs, cifs,
> f2fs, 9p, nfsv4, ntfs, gfs2, ocfs2, fuse, ufs2. Everything else
> except xfs, ext2/3 and exofs uses the nfsv3 interpretation on
> 64-bit systems, which interprets time stamps with the high bit
> set as years 2038-2106 rather than 1903-1969.

I'm not sure that's an entirely correct representation - the
remainder of the 32 bit-only timestamp filesystems don't actively
interpret the time stamp at all - it's just an opaque 32 bit value.
hence the interpretation of the value is dependent on whether the
kernel treats it as signed or unsigned....

> > infrastructure), then we'll *never be able to fix it* and we'll be
> > stuck with timestamps that do really weird things when you pass
> > arbitrary future dates to the kernel.
> 
> We already have that. I agree it's fixable and we should fix it,
> but I don't see how this is different from what we had 20 years
> ago when Linux on Alpha first introduced a 64-bit time_t. It's
> been this way on every 64-bit Linux system since.

I see it differently: we've got 20 years more experience than when
the 64 bit time_t was introduced. That experience tells us that best
practices for API design are to range check every input to prevent
unintended side effects from occurring due to out-of-range data....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
