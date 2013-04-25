Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab3DYXRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:17:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746Ab3DYXRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:17:07 -0400
Date: Thu, 25 Apr 2013 16:17:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, James.Bottomley@hansenpartnership.com,
        snitzer@redhat.com
Subject: Re: Bcache v. whatever
Message-Id: <20130425161704.3f0fc3b6af55cf75acbc9d9e@linux-foundation.org>
In-Reply-To: <20130114223202.GV26407@google.com>
References: <20130114223202.GV26407@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013 14:32:02 -0800 Kent Overstreet <koverstreet@google.com> wrote:

> Bcache: a block layer SSD cache

sparc64 gcc-3.4.5:

drivers/md/bcache/btree.c: In function `bch_btree_read':
drivers/md/bcache/btree.c:266: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `__btree_write':
drivers/md/bcache/btree.c:379: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `btree_node_free':
drivers/md/bcache/btree.c:980: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `btree_insert_key':
drivers/md/bcache/btree.c:1857: error: invalid operands to binary +
drivers/md/bcache/btree.c:1857: error: invalid operands to binary +
drivers/md/bcache/btree.c:1859: error: invalid operands to binary +
drivers/md/bcache/btree.c:1859: error: invalid operands to binary +
drivers/md/bcache/btree.c:1864: error: invalid operands to binary +
drivers/md/bcache/btree.c:1864: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `btree_split':
drivers/md/bcache/btree.c:1934: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `bch_btree_set_root':
drivers/md/bcache/btree.c:2159: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `bch_btree_search_recurse':
drivers/md/bcache/btree.c:2262: error: invalid operands to binary +
drivers/md/bcache/btree.c: In function `bch_btree_refill_keybuf':
drivers/md/bcache/btree.c:2330: error: invalid operands to binary +

due to

#define pbtree(b)       (&bch_pbtree(b).s[0])

I don't know why this is happening (presumably a gcc glitch), but
returning an 80-byte struct by value from bch_pkey() and bch_pbtree()
is just gruesome.  The compiler has to allocate the space on the caller
stack, pass a hidden pointer into the callee and the callee copies its
return value into that caller stack slot.  It's slow and consumes stack.

Something different, please.


