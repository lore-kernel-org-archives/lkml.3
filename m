Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3EIUgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:36:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25252 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3EIUgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:36:21 -0400
Date: Thu, 9 May 2013 13:36:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: dm-cache not writing out cache metadata at reboot?
Message-ID: <20130509203616.GA5713@blackbox.djwong.org>
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508220526.GA24132@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 06:05:26PM -0400, Mike Snitzer wrote:
> On Wed, May 08 2013 at  5:48pm -0400,
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > Hi,
> > 
> > So I've been watching the hit/miss counters in dmcache and I've noticed a
> > couple of things that look like errors to me:
> > 
> > First, I noticed that if I reboot the system, neither cache_postsuspend nor
> > cache_dtr get called.  This might simply be expected behavior, but it means
> > that the in-memory superblock structure doesn't get written out to disk upon
> > reboot.  Just to be sure, I put a printk into __commit_transaction.  It prints
> > out for 'dmsetup info' and 'dmsetup remove' but nothing at reboot.
> 
> We don't have reboot notifiers that auto-magically tear down an
> artbitrary DM stack.  Typically the device shutdown includes unmounting
> filesystems, stopping LVM (which tears down DM devices, etc).
> 
> So given that we don't have any userspace LVM2 support for dm-cache yet
> I'm not surprised by this.  In fact it is expected.
>  
> > Second, cache_status calls dm_cache_commit, which writes out a superblock to
> > the metadata device.  However, there's no call to save_stats to copy the
> > current values of the counters out to the disk's copy prior to calling
> > dm_cache_commit.  Therefore, we seem to be writing out stale copies of
> > superblock fields.
> > 
> > The second one seems fixable with the attached patch
> 
> I'll defer to Joe on this but I think sync_metadata() is pretty heavy to
> be doing every 'dmsetup info'.  BTW, with just dm_cache_commit() the
> superblock fields aren't stale; only the on-disk hints are.

Hrmm, how about this: dmsetup info will call save_stats so that the superblock
gets written with the freshest hit/miss counts, and I'll create a new dmsetup
message command that actually flushes everything out?

--D
