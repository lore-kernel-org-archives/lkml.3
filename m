Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab3IIMvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:51:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39339 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3IIMvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:51:06 -0400
Date: Mon, 9 Sep 2013 15:49:42 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130909124942.GA2221@swordfish.minsk.epam.com>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909123329.GZ19256@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Calling handle_pending_slot_free() for every RW operation may
> > cause unneccessary slot_free_lock locking, because most likely
> > process will see NULL slot_free_rq. handle_pending_slot_free()
> > only when current detects that slot_free_rq is not NULL.
> > 
> > v2: protect handle_pending_slot_free() with zram rw_lock.
> > 
> 
> zram->slot_free_lock protects zram->slot_free_rq but shouldn't the zram
> rw_lock be wrapped around the whole operation like the original code
> does?  I don't know the zram code, but the original looks like it makes
> sense but in this one it looks like the locks are duplicative.
> 
> Is the down_read() in the original code be changed to down_write()?
>

I'm not touching locking around existing READ/WRITE commands.

the original code:

static void handle_pending_slot_free(struct zram *zram)
{
        struct zram_slot_free *free_rq;

        spin_lock(&zram->slot_free_lock);
        while (zram->slot_free_rq) {
                free_rq = zram->slot_free_rq;
                zram->slot_free_rq = free_rq->next;
                zram_free_page(zram, free_rq->index);
                kfree(free_rq);
        }
        spin_unlock(&zram->slot_free_lock);
}

static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
                        int offset, struct bio *bio, int rw)
{
        int ret;

        if (rw == READ) {
                down_read(&zram->lock);
                handle_pending_slot_free(zram);
                ret = zram_bvec_read(zram, bvec, index, offset, bio);
                up_read(&zram->lock);
        } else {
                down_write(&zram->lock);
                handle_pending_slot_free(zram);
                ret = zram_bvec_write(zram, bvec, index, offset);
                up_write(&zram->lock);
        }

        return ret;
}



the new one:

static void handle_pending_slot_free(struct zram *zram)
{
        struct zram_slot_free *free_rq;

        down_write(&zram->lock);
        spin_lock(&zram->slot_free_lock);
        while (zram->slot_free_rq) {
                free_rq = zram->slot_free_rq;
                zram->slot_free_rq = free_rq->next;
                zram_free_page(zram, free_rq->index);
                kfree(free_rq);
        }
        spin_unlock(&zram->slot_free_lock);
        up_write(&zram->lock);
}

static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
                        int offset, struct bio *bio, int rw)
{
        int ret;

        if (zram->slot_free_rq)
                handle_pending_slot_free(zram);

        if (rw == READ) {
                down_read(&zram->lock);
                ret = zram_bvec_read(zram, bvec, index, offset, bio);
                up_read(&zram->lock);
        } else {
                down_write(&zram->lock);
                ret = zram_bvec_write(zram, bvec, index, offset);
                up_write(&zram->lock);
        }

        return ret;
}


both READ and WRITE operations are still protected by down_read() for READ path
and down_write() for WRITE path. however, there is no handle_pending_slot_free()
and zram->slot_free_lock locking on every READ/WRITE, instead handle_pending_slot_free()
is called only when zram->slot_free_rq is not NULL. handle_pending_slot_free() in
turn protects zram_free_page() call by down_write(), so no READ/WRITE operations
are affected.

	-ss
