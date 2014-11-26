Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaKZDlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 22:41:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaKZDlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 22:41:07 -0500
Date: Tue, 25 Nov 2014 22:41:04 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: dm-bufio: fix memleak when using a dm_buffer's inline bio
Message-ID: <20141126034103.GA26585@redhat.com>
References: <20141126014515.GE10050@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126014515.GE10050@birch.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25 2014 at  8:45pm -0500,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> When dm-bufio sets out to use the bio built into a struct dm_buffer to
> issue an IO, it needs to call bio_reset after it's done with the bio
> so that we can free things attached to the bio such as the integrity
> payload.  Therefore, inject our own endio callback to take care of
> the bio_reset after calling submit_io's end_io callback.
> 
> Test case:
> 1. modprobe scsi_debug delay=0 dif=1 dix=199 ato=1 dev_size_mb=300
> 2. Set up a dm-bufio client, e.g. dm-verity, on the scsi_debug device
> 3. Repeatedly read metadata and watch kmalloc-192 leak!
> 
> Fix is against 3.18-rc6.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks for reporting/fixing this.

Alternatively I think we could just call bio_reset() in submit_io(),
e.g.:

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index afe7971..e7036e3 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -579,6 +579,8 @@ static void submit_io(struct dm_buffer *b, int rw, sector_t block,
 	if (rw == WRITE && b->c->write_callback)
 		b->c->write_callback(b);
 
+	bio_reset(&b->bio);
+
 	if (b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE &&
 	    b->data_mode != DATA_MODE_VMALLOC)
 		use_inline_bio(b, rw, block, end_io);

What do you think?
