Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaL1SWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 13:22:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39469 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaL1SWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 13:22:01 -0500
Date: Sun, 28 Dec 2014 18:21:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/ufs/super.c: remove unnecessary casting
Message-ID: <20141228182158.GJ22149@ZenIV.linux.org.uk>
References: <1419780509-4582-1-git-send-email-fabf@skynet.be>
 <20141228153311.GI22149@ZenIV.linux.org.uk>
 <1419785144.20894.10.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419785144.20894.10.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 08:45:44AM -0800, Joe Perches wrote:
> On Sun, 2014-12-28 at 15:33 +0000, Al Viro wrote:
> > On Sun, Dec 28, 2014 at 04:28:29PM +0100, Fabian Frederick wrote:
> > > Fix the following coccinelle warning:
> > > fs/ufs/super.c:1418:7-28: WARNING: casting value returned by memory
> > > allocation function to (struct ufs_inode_info *) is useless.
> > 
> > ... except that it makes allocations harder to grep for.
> 
> How does it do that?

search for \<struct[ 	]*$NAME[ 	]*($|[^ 	*]|[*][ 	]*[)])
generally gives a lot of interesting information (variables of that type,
members of anything having that type, sizeof, container_of, explicit casts)
with relatively little noise.

BTW, that's why I really don't like the stuff like
	struct foo *p = kmalloc(sizeof(*p), GFP_KERNEL);
It's bloody hard to spot.

In case of UFS we still catch "sizeof(struct ufs_inode_info)" in
        ufs_inode_cachep = kmem_cache_create("ufs_inode_cache",
                                             sizeof(struct ufs_inode_info),
                                             0, (SLAB_RECLAIM_ACCOUNT|
                                                SLAB_MEM_SPREAD),
                                             init_once);
which gives the obvious secondary search pattern, so it's not _that_ terrible,
but in general it's not something to do without thinking - such a cast could
be placed there exactly to make it stand out on grep.
