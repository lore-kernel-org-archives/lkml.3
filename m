Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaKRUq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:46:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaKRUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:46:26 -0500
Date: Tue, 18 Nov 2014 12:46:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfs 1/2] lib: implement ptrset
Message-Id: <20141118124624.ff0b3140068a090b2860f202@linux-foundation.org>
In-Reply-To: <20141114131202.GB21209@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
	<20141113142333.39fc29592019a397131fb03c@linux-foundation.org>
	<20141113222736.GH2598@htj.dyndns.org>
	<20141113144041.23bff773808562c699507621@linux-foundation.org>
	<20141114131202.GB21209@htj.dyndns.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 08:12:02 -0500 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Thu, Nov 13, 2014 at 02:40:41PM -0800, Andrew Morton wrote:
> > In that case tjpointer_add() would need to do a kmalloc() for each inode
> > which is added to the bdev/cdev, just as ptrset_add() is doing.
> > 
> > That might require a nasty preload thing.  But really, for just two
> > known callers it would be better to require the caller to create the
> > storage.
> > 
> > 
> > 	struct tjpointer *new_tpj;
> > 
> > 	new_tpj = kmalloc(...);
> > 	lock();
> > 	tjpointer_add(&my_tjp_list, new_tjp, my_pointer);
> > 	unlock();
> > 
> > Basically what I'm saying is nuke the rbtree and use lists.
> 
> Hah?  Then, each removal would be O(N) where N is the number of total
> block devices and there are cases where massive number of block
> devices exist and many are added / removed back-to-back.  I don't
> think making those operations O(N^2) is a good idea.
> 

bdev_evict_inode() walks all the inodes attached to the bdev and
unlinks them from the bdev.  That can be done with
list_for_each_safe(), just as it is (effectively) in current mainline.

IOW, all we need to do is to remove the list_head from struct inode and
create a new, separately allocated { struct list_head l; void *inode }
to point at the inode.  IOW, simply convert the intrusive list to a
nonintrusive list.


This is proving a painful way of extracting a changelog :( Perhaps I'm
still not getting it and you should have another go, this time
explaining the reasoning behind the design choices.
