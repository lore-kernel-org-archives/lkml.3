Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3DZTqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:46:51 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61381 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab3DZTqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:46:46 -0400
Date: Fri, 26 Apr 2013 12:46:42 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, James.Bottomley@hansenpartnership.com,
        snitzer@redhat.com
Subject: Re: Bcache v. whatever
Message-ID: <20130426194642.GC9931@google.com>
References: <20130114223202.GV26407@google.com>
 <20130425161704.3f0fc3b6af55cf75acbc9d9e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425161704.3f0fc3b6af55cf75acbc9d9e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 04:17:04PM -0700, Andrew Morton wrote:
> On Mon, 14 Jan 2013 14:32:02 -0800 Kent Overstreet <koverstreet@google.com> wrote:
> 
> > Bcache: a block layer SSD cache
> 
> sparc64 gcc-3.4.5:
> 
> drivers/md/bcache/btree.c: In function `bch_btree_read':
> drivers/md/bcache/btree.c:266: error: invalid operands to binary +
> drivers/md/bcache/btree.c: In function `__btree_write':
> drivers/md/bcache/btree.c:379: error: invalid operands to binary +
> drivers/md/bcache/btree.c: In function `btree_node_free':
> drivers/md/bcache/btree.c:980: error: invalid operands to binary +
> drivers/md/bcache/btree.c: In function `btree_insert_key':
> drivers/md/bcache/btree.c:1857: error: invalid operands to binary +
> drivers/md/bcache/btree.c:1857: error: invalid operands to binary +
> drivers/md/bcache/btree.c:1859: error: invalid operands to binary +
> drivers/md/bcache/btree.c:1859: error: invalid operands to binary +
> drivers/md/bcache/btree.c:1864: error: invalid operands to binary +
> drivers/md/bcache/btree.c:1864: error: invalid operands to binary +
> drivers/md/bcache/btree.c: In function `btree_split':
> drivers/md/bcache/btree.c:1934: error: invalid operands to binary +
> drivers/md/bcache/btree.c: In function `bch_btree_set_root':
> drivers/md/bcache/btree.c:2159: error: invalid operands to binary +
> drivers/md/bcache/btree.c: In function `bch_btree_search_recurse':
> drivers/md/bcache/btree.c:2262: error: invalid operands to binary +
> drivers/md/bcache/btree.c: In function `bch_btree_refill_keybuf':
> drivers/md/bcache/btree.c:2330: error: invalid operands to binary +
> 
> due to
> 
> #define pbtree(b)       (&bch_pbtree(b).s[0])
> 
> I don't know why this is happening (presumably a gcc glitch), but
> returning an 80-byte struct by value from bch_pkey() and bch_pbtree()
> is just gruesome.  The compiler has to allocate the space on the caller
> stack, pass a hidden pointer into the callee and the callee copies its
> return value into that caller stack slot.  It's slow and consumes stack.
> 
> Something different, please.

Well, it is kind of... perverse but really the compiler's doing exactly
what I would've had to do otherwise - stick a char buf[80] on the
caller's stack and pass it to bch_pbtree(). With the caveat that I
haven't looked at the generated code.

As far as I can tell the only real improvement would be to add a %p
format string to vsnprintf, but adding a global extension would obviously be
inappropriate for this. It'd be really nice to have a mechanism for
adding file/module private format strings to vsnprintf, but I haven't
cared enough yet to implement it myself.

Of course if you know a better solution I'm all ears.

Uhm, as for the actual bug - that is a fairly ancient gcc, I wasn't
aware we were supporting compilers that old but I'm sure you wouldn't be
bugging me about it if we weren't...

If you _really_ want me to rip out the macro/struct return hack I
will... but this is just debug code and I hate making it more verbose if
I don't have to.

Otherwise, I'll set up gcc-3.4.5 (hopefully it doesn't have to be a
sparc compiler :P) and see if I can get gcc to stop complaining.
