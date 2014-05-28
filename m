Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaE1OTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:19:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53366 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbaE1OTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:19:42 -0400
Date: Wed, 28 May 2014 15:19:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140528141937.GZ18016@ZenIV.linux.org.uk>
References: <20140526182644.GP18016@ZenIV.linux.org.uk>
 <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
 <20140527014054.GR18016@ZenIV.linux.org.uk>
 <20140527031415.GS18016@ZenIV.linux.org.uk>
 <20140527040026.GT18016@ZenIV.linux.org.uk>
 <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
 <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528131136.GA1643@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 04:11:36PM +0300, Mika Westerberg wrote:

> I added this on top of your previus patch and unfortunately the livelock
> is still there :-(
> 
> >From the previous log, it looks like udev is doing exactly same operation
> (check_submounts_and_drop) on 4 of the CPUs in paraller:

4 threads trying to resolve some pathnames in that subtree for some reason.
All of them hitting ->d_revalidate() on the spot - basically, the first
invalidated directory...

OK, it's not ->i_lock, it's ->d_lock on parent being grabbed after that on
child, while d_walk() keeps taking them in opposite order.  Hmm...

In principle we could do the following:
	* split dentry_kill() into the part that is taking locks and
the rest of it.
	* in case of trylock failure have shrink_dentry_list() do
read_seqlock_excl(&rename_lock) (which will stabilize ->d_parent) and
take ->d_lock in the right order, drop rename_lock and call __dentry_kill().

AFAICS, that would kill the livelock for good.  We still have ->i_lock
trylock failures to deal with, but those are less of a problem - d_walk()
won't step on ->i_lock at all.  I'm going to grab a couple of hours of sleep
and try to put together something along those lines...
