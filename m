Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3CNXBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:01:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3CNXBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:01:12 -0400
Date: Thu, 14 Mar 2013 16:01:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Shuge <shugelinux@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, Kevin <kevin@allwinneretch.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] bounce:fix bug, avoid to flush dcache on slab page from
 jbd2.
Message-Id: <20130314160110.a0fe092cb103bfe6720d3009@linux-foundation.org>
In-Reply-To: <20130314224243.GI5313@blackbox.djwong.org>
References: <5139DB90.5090302@gmail.com>
	<20130312153221.0d26fe5599d4885e51bb0c7c@linux-foundation.org>
	<20130313011020.GA5313@blackbox.djwong.org>
	<20130313085021.GA29730@quack.suse.cz>
	<20130313194429.GE5313@blackbox.djwong.org>
	<20130313210216.GA7754@quack.suse.cz>
	<20130314224243.GI5313@blackbox.djwong.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013 15:42:43 -0700 "Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> Subject: [PATCH] mm: Make snapshotting pages for stable writes a per-bio operation
> 
> Walking a bio's page mappings has proved problematic, so create a new bio flag
> to indicate that a bio's data needs to be snapshotted in order to guarantee
> stable pages during writeback.  Next, for the one user (ext3/jbd) of
> snapshotting, hook all the places where writes can be initiated without
> PG_writeback set, and set BIO_SNAP_STABLE there.  Finally, the MS_SNAP_STABLE
> mount flag (only used by ext3) is now superfluous, so get rid of it.

whoa, that looks way better.

Must do this though:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix

rename _submit_bh()'s `flags' to `bio_flags', delobotomize the _submit_bh declaration

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    4 ++--
 include/linux/buffer_head.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/buffer.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix fs/buffer.c
--- a/fs/buffer.c~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix
+++ a/fs/buffer.c
@@ -2949,7 +2949,7 @@ static void guard_bh_eod(int rw, struct
 	}
 }
 
-int _submit_bh(int rw, struct buffer_head * bh, unsigned long flags)
+int _submit_bh(int rw, struct buffer_head * bh, unsigned long bio_flags)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -2984,7 +2984,7 @@ int _submit_bh(int rw, struct buffer_hea
 
 	bio->bi_end_io = end_bio_bh_io_sync;
 	bio->bi_private = bh;
-	bio->bi_flags |= flags;
+	bio->bi_flags |= bio_flags;
 
 	/* Take care of bh's that straddle the end of the device */
 	guard_bh_eod(rw, bio, bh);
diff -puN include/linux/buffer_head.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix
+++ a/include/linux/buffer_head.h
@@ -181,7 +181,7 @@ void ll_rw_block(int, int, struct buffer
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, int rw);
 void write_dirty_buffer(struct buffer_head *bh, int rw);
-int _submit_bh(int, struct buffer_head *, unsigned long);
+int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags);
 int submit_bh(int, struct buffer_head *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
_

