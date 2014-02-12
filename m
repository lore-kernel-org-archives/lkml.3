Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaBLJG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:06:27 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:57590 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaBLJFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:05:53 -0500
Date: Wed, 12 Feb 2014 12:02:28 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/4] zram: introduce compressing backend abstraction
Message-ID: <20140212090228.GB2176@swordfish>
References: <1392157266-13488-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1392157266-13488-2-git-send-email-sergey.senozhatsky@gmail.com>
 <20140212070650.GB19818@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212070650.GB19818@bbox>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/12/14 16:06), Minchan Kim wrote:
[..]
> > +{
> > +	kfree(workmem);
> > +}
> 
> It's okay to name "workmem" for lzo because lzo needs only work buffer to work
> but let's think about zlib. It needs z_streamp which has many feilds
> to work as well as work memory. That's why I don't like "workmem" name which
> is very specific. Anyway, it's okay for lzo backend now.
> 

ok. will use zcomp_strm

[..]
> > +	return workmem;
> > +fail:
> > +	workmem_free(comp, workmem);
> > +	return NULL;
> > +}
> 
> Hmm, you introduced workmem again. :(
> As I said above, workmem is too specific.
> It's only valid for lzo and lz4 so I don't want to expose workmem out of zcomp
> and that's why I suggested zcomp_strm or zcomp_stream.
> It seems "stream" is more general term for compressor.
> 

> > +/* add workmem back to idle list and wake up waiter (if any) */
> > +void zcomp_workmem_put(struct zram_comp *comp,
> > +		struct zcomp_workmem *workmem)
> > +{
> > +	spin_lock(&comp->buffer_lock);
> > +	list_add_tail(&workmem->list, &comp->idle_workmem);
> 
> Why do you implement queue instead of stack?
> 

zcomp gets the first element from a list and never iterates it,
so it's O(1).
kfifo with copying and write memory barriers... I don't think
it will be a better choice here. and we don't have `first in,
first out' pattern, zcomp does not care about order.

> > +	spin_unlock(&comp->buffer_lock);
> > +
> > +	if (waitqueue_active(&comp->workmem_wait))
> 
> Possible losting wakeup?

hm, could be.

> > +		wake_up(&comp->workmem_wait);
> > +}
> > +
> > +int zcomp_compress(struct zram_comp *comp, struct zcomp_workmem *workmem,
> > +		const unsigned char *src, size_t src_len, size_t *dst_len)
> > +{
> 
> As I said, I don't like zcomp_workmem.
> Please use zcomp_strm and let's make naming clear.
> Something is zcomp and sometime is zram_comp.
> I prefer zcomp but it depends on you.

ok. I drop zram part. zcomp and zcomp_strm

> > +	return comp->backend->compress(src, src_len, workmem->buffer,
> > +			dst_len, workmem->private);
> > +}
> > +
> > +int zcomp_decompress(struct zram_comp *comp, const unsigned char *src,
> > +		size_t src_len, unsigned char *dst, size_t *dst_len)
> > +{
> > +	return comp->backend->decompress(src, src_len, dst, dst_len);
> > +}
> > +
> > +/* free allocated workmem buffers and zram_comp */
> > +void zcomp_destroy(struct zram_comp *comp)
> > +{
> > +	struct zcomp_workmem *wm;
> > +	while (!list_empty(&comp->idle_workmem)) {
> > +		wm = list_entry(comp->idle_workmem.next,
> > +				struct zcomp_workmem, list);
> > +		list_del(&wm->list);
> > +		workmem_free(comp, wm);
> > +	}
> > +	kfree(comp);
> > +}
> > +
> > +static struct zram_comp_backend *find_backend(const char *compress)
> > +{
> > +	if (sysfs_streq(compress, "lzo"))
> > +		return &zcomp_lzo;
> > +	return NULL;
> > +}
> > +
> > +/* search available compressors for requested algorithm.
> 
> Please correct comment style.

I'll take a look (checkpatch didn't complain).

> > +/* static compression backend */
> > +struct zram_comp_backend {
> > +	int (*compress)(const unsigned char *src, size_t src_len,
> > +			unsigned char *dst, size_t *dst_len, void *wrkmem);
> 
> zram works based on PAGE so I like compress_page so maybe we couldn't
> reduce a argument "src_len".
> 

yes and no.

zram can see partial IOs

static inline int is_partial_io(struct bio_vec *bvec)
{
	return bvec->bv_len != PAGE_SIZE;
}

so, in general yes -- we can drop src_len and compress PAGE_SIZE bytes,
but at the same time `bvec->bv_len < PAGE_SIZE' is possible (if it's not
then we can greatly simplify zram).

	-ss

> > +
> > +	int (*decompress)(const unsigned char *src, size_t src_len,
> > +			unsigned char *dst, size_t *dst_len);
> > +
> > +	void *(*create)(void);
> > +	void (*destroy)(void *workmem);
> > +
> > +	const char *name;
> > +};
> > +
> > +/* dynamic per-device compression frontend */
> > +struct zram_comp {
> > +	/* protect workmem list */
> > +	spinlock_t buffer_lock;
> > +	/* list of available workmems */
> > +	struct list_head idle_workmem;
> > +	wait_queue_head_t workmem_wait;
> > +	struct zram_comp_backend *backend;
> > +};
> > +
> > +struct zram_comp *zcomp_create(const char *comp);
> > +void zcomp_destroy(struct zram_comp *comp);
> > +
> > +struct zcomp_workmem *zcomp_workmem_get(struct zram_comp *comp);
> > +void zcomp_workmem_put(struct zram_comp *comp,
> > +		struct zcomp_workmem *workmem);
> > +
> > +int zcomp_compress(struct zram_comp *comp, struct zcomp_workmem *workmem,
> > +		const unsigned char *src, size_t src_len, size_t *dst_len);
> > +
> > +int zcomp_decompress(struct zram_comp *comp, const unsigned char *src,
> > +		size_t src_len, unsigned char *dst, size_t *dst_len);
> > +#endif /* _ZRAM_COMP_H_ */
> > -- 
> > 1.9.0.rc3.244.g3497008
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Kind regards,
> Minchan Kim
> 
