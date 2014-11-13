Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335AbaKMWXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:23:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:23:35 -0500
Date: Thu, 13 Nov 2014 14:23:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfs 1/2] lib: implement ptrset
Message-Id: <20141113142333.39fc29592019a397131fb03c@linux-foundation.org>
In-Reply-To: <20141113220927.GF2598@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 17:09:27 -0500 Tejun Heo <tj@kernel.org> wrote:

> Implement set of pointers.  Pointers can be added, deleted and
> iterated.  It's currently implemented as a thin rbtree wrapper making
> addition and removal O(log N).  A drawback is that iteration isn't RCU
> safe, which is okay for now.  This will be used to remove
> inode->i_devices.
> 

Confused.

>
> --- /dev/null
> +++ b/include/linux/ptrset.h
> @@ -0,0 +1,74 @@
> +/*
> + * include/linux/ptrset.h - set of pointers
> + *
> + * Copyright (C) 2014		Tejun Heo, Red Hat Inc.
> + *
> + * A ptrset contains an unordered set of pointers.  Pointers can be added,
> + * deleted and iterated.  Addition and removal complexities are O(log N)
> + * where N is the total number of elements in the ptrset.
> + */
> +
> +#ifndef __PTRSET_H
> +#define __PTRSET_H
> +
> +#include <linux/preempt.h>
> +#include <linux/rbtree.h>
> +
> +struct ptrset {
> +	struct rb_root		root;
> +};
> +
> +struct ptrset_elem {
> +	void			*ptr;
> +	struct rb_node		node;
> +};
> +
> +struct ptrset_iter {
> +	struct ptrset_elem	*pos;
> +	struct ptrset_elem	*next;
> +};

This seems rather slow and bloaty.  Why not

struct tjpointer {
	struct list_head list;
	void *pointer;
};

And then callers do things like

	struct tjpointer *tjp;

	lock();

	for_each_tjpointer(tjp, &my_tjpointer_list) {
		foo(tjp->ptr);
	}

	tjpointer_del(tjp);

	unlock();

That's less storage, vastly less support code, insertion and removal
are O(1) and it doesn't need the ghastly preload thing.


