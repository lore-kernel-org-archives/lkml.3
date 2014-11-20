Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbaKTLu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:50:59 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:65309 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbaKTLu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:50:56 -0500
Date: Thu, 20 Nov 2014 06:50:52 -0500
From: Tejun Heo <tj@kernel.org>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 2/2] {block|char}_dev: remove inode->i_devices
Message-ID: <20141120115052.GA32237@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
 <20141113221139.GG2598@htj.dyndns.org>
 <546DC5AD.3040606@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546DC5AD.3040606@plexistor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

On Thu, Nov 20, 2014 at 12:42:53PM +0200, Boaz Harrosh wrote:
> if I understand correctly the motivation here is that the allocation
> of the internal element is done GFP_KERNEL at this call
> 
> Then the add() below can be under the spin_lock.
> 
> So why don't you just return an element here to caller and give it to
> add below. No Preemption-disable, no percpu variable, simple. Like:

Hmmm... mostly because preloading is more convenient and but also
because it provides better separation from internal implementation
details.  e.g. This may be implemented using a different data
structure (e.g. bonsai tree) which may require differing number of new
elements even on success.  With the scheme you're describing, the
operation would be constantly allocating and freeing memory areas
(which may be multiple) unnecessarily.

One thing which is debatable is how to handle preloading errors.  We
can have the preload fail and then assume that the later insertion
won't fail with -ENOMEM (often through BUG/WARN_ON()); however, it
often, but not always, is that those insertion operations may fail
with different error codes too and requires error handling anyway, so
overall it seems better to defer the allocation error to the actual
insertion point.  It also makes conceptual sense.  The preloading
simply upgrades the allocation mask the insertion operation uses.

Thanks.

-- 
tejun
