Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452AbaKMWko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:40:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:40:43 -0500
Date: Thu, 13 Nov 2014 14:40:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfs 1/2] lib: implement ptrset
Message-Id: <20141113144041.23bff773808562c699507621@linux-foundation.org>
In-Reply-To: <20141113222736.GH2598@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
	<20141113142333.39fc29592019a397131fb03c@linux-foundation.org>
	<20141113222736.GH2598@htj.dyndns.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 17:27:36 -0500 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Thu, Nov 13, 2014 at 02:23:33PM -0800, Andrew Morton wrote:
> > This seems rather slow and bloaty.  Why not
> > 
> > struct tjpointer {
> > 	struct list_head list;
> > 	void *pointer;
> > };
> > 
> > And then callers do things like
> > 
> > 	struct tjpointer *tjp;
> > 
> > 	lock();
> > 
> > 	for_each_tjpointer(tjp, &my_tjpointer_list) {
> > 		foo(tjp->ptr);
> > 	}
> > 
> > 	tjpointer_del(tjp);
> > 
> > 	unlock();
> > 
> > That's less storage, vastly less support code, insertion and removal
> > are O(1) and it doesn't need the ghastly preload thing.
> 
> The goal is moving the memory necessary for indexing to the indexer
> instead of the indexees.  In the above case, the indexee would have to
> either embed tjpointer inside it or at least have a pointer pointing
> at it.

In that case tjpointer_add() would need to do a kmalloc() for each inode
which is added to the bdev/cdev, just as ptrset_add() is doing.

That might require a nasty preload thing.  But really, for just two
known callers it would be better to require the caller to create the
storage.


	struct tjpointer *new_tpj;

	new_tpj = kmalloc(...);
	lock();
	tjpointer_add(&my_tjp_list, new_tjp, my_pointer);
	unlock();

Basically what I'm saying is nuke the rbtree and use lists.
