Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaAOAWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:22:22 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:21273 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbaAOAWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:22:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMKAKrT1VJ5LKVw/2dsb2JhbABagwuDOrJthVmBERd0giUBAQEEOhwjEAgDGAklDwUlAyETiAPERxcWjnEHhDcEmB2KTIdKg0Eo
Date: Wed, 15 Jan 2014 11:22:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Li Wang <liwang@ubuntukylin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Zefan Li <lizefan@huawei.com>, Matthew Wilcox <matthew@wil.cx>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH 2/3] Add shrink_pagecache_parent
Message-ID: <20140115002215.GP3469@dastard>
References: <cover.1388409686.git.liwang@ubuntukylin.com>
 <249cbd3edaa84dd58a0626780fb546ddf7c1dc11.1388409687.git.liwang@ubuntukylin.com>
 <20140102155534.9b0cd498209d835d0c93837e@linux-foundation.org>
 <52CCB2A7.2000300@ubuntukylin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CCB2A7.2000300@ubuntukylin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 10:06:31AM +0800, Li Wang wrote:
> Hi,
> 
> On 01/03/2014 07:55 AM, Andrew Morton wrote:
> >On Mon, 30 Dec 2013 21:45:17 +0800 Li Wang <liwang@ubuntukylin.com> wrote:
> >
> >>Analogous to shrink_dcache_parent except that it collects inodes.
> >>It is not very appropriate to be put in dcache.c, but d_walk can only
> >>be invoked from here.
> >However...  most inodes will be on an LRU list, won't they?  Doesn't
> >this reuse of i_lru mean that many inodes will fail to be processed?
> >If so, we might need to add a new list_head to the inode, which will be
> >problematic.
> >
> As far as I know, fix me if i am wrong, only when inode has zero
> reference count, it will be put into superblock lru list. For most
> situations, there is at least a dentry refers to it, so it will not
> be on any lru list.

Yes, that's when they get added to the LRU, but they don't get
removed if they are referenced again by a dentry. Hence dentries can
be reclaimed, which puts the inode on it's LRU, but then the
directory is read again and a new dentry allocated to point to it.
We do not remove the inode from the LRU at this point in time.
Hence you can have referenced inodes that are on the LRU, and in
many workloads most of the referenced inodes in the system are on
the LRU....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
