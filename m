Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaAINmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:42:20 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52245 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaAINmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:42:12 -0500
Date: Thu, 9 Jan 2014 06:42:10 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Easier printing of unknown-size quantities
Message-ID: <20140109134210.GC29910@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We have a number of types whose sizes are architecture- or
config-dependent such as pgoff_t or sector_t.  The recommendation for
printing them is to cast them to (unsigned long long) and print them with
%Lu/%llx/...  That's entirely reasonable except that it's so verbose.
I was wishing that C had a more succinct way to express that, when it
struct me that we can fix this without changing the compiler or language
spec, viz:

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index ecb8754..011b55e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -28,7 +28,7 @@
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
 #define SIZE_MAX	(~(size_t)0)
+#define ULL(x)		((unsigned long long)(x))
 
 #define STACK_MAGIC	0xdeadbeef
 

For demonstration purposes only (because I have another patch series
that would conflict with this):

diff --git a/fs/buffer.c b/fs/buffer.c
index 6024877..50e2596 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -148,7 +148,7 @@ static void buffer_io_error(struct buffer_head *bh)
 {
 	char b[BDEVNAME_SIZE];
 	printk(KERN_ERR "Buffer I/O error on device %s, logical block %Lu\n",
-			bdevname(bh->b_bdev, b),
-			(unsigned long long)bh->b_blocknr);
+			bdevname(bh->b_bdev, b), ULL(bh->b_blocknr));
 }
 
 /*
@@ -257,8 +256,7 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 
 		printk("__find_get_block_slow() failed. "
 			"block=%llu, b_blocknr=%llu\n",
-			(unsigned long long)block,
-			(unsigned long long)bh->b_blocknr);
+			ULL(block), ULL(bh->b_blocknr));
 		printk("b_state=0x%08lx, b_size=%zu\n",
 			bh->b_state, bh->b_size);
 		printk("device %s blocksize: %d\n", bdevname(bdev, b),
@@ -1083,8 +1081,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
 		char b[BDEVNAME_SIZE];
 
 		printk(KERN_ERR "%s: requested out-of-range block %llu for "
-			"device %s\n",
-			__func__, (unsigned long long)block,
+			"device %s\n", __func__, ULL(block),
 			bdevname(bdev, b));
 		return -EIO;
 	}

Seems like a clear win to me.  What do others think?  Might create a bit
of churn, but I find the "after" version easier to read than the former.

This is an RFC, not a PATCH, so I have deliberately mangled the patches to
not apply.  I'm happy to supply working patches after we've bikeshedded
this one around a bit.  I'm also happy to introduce it, but forbid any
mass conversion patches for a year until code has had the chance to
start using it.

In fact, let me help start the bikeshedding.  I was trying to decide
what I wanted this to print:

	unsigned int x, y;
	x = y = 0x80000000;
	printf("%llx\n", ULL(x+y));

I decided that I didn't want to magically fix the overflow, but rather
expose it.  After all, if the user wants the promotion, they can always
write ULL(x)+y.  That's why there are extra parens in the definition
of ULL.

I also considered naming the macro Lu(x) so you could use it like this:

	printf("%Lu\n", Lu(x));

which is kind of cute, but it seemed clearer to me to name it the same
as the integer suffixes.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
