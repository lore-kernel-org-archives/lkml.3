Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3ANRfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:35:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab3ANRfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:35:34 -0500
Date: Mon, 14 Jan 2013 19:39:14 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
Message-ID: <20130114173914.GB19207@redhat.com>
References: <871ug75vp1.fsf@rustcorp.com.au>
 <1354718230-4486-1-git-send-email-sjur@brendeland.net>
 <20121206102750.GF10837@redhat.com>
 <877goc0wac.fsf@rustcorp.com.au>
 <CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com>
 <87pq1f2rj0.fsf@rustcorp.com.au>
 <87wqvl1g9s.fsf@rustcorp.com.au>
 <CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com>
 <87pq1c1uj4.fsf@rustcorp.com.au>
 <877gnk1ayv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gnk1ayv.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 05:07:44PM +1030, Rusty Russell wrote:
> Untested, but I wanted to post before the weekend.
> 
> I think the implementation is a bit nicer, and though we have a callback
> to get the guest-to-userspace offset, it might be faster since I think
> most cases will re-use the same mapping.
> 
> Feedback on API welcome!
> Rusty.
> 
> virtio_host: host-side implementation of virtio rings (untested!)
> 
> Getting use of virtio rings correct is tricky, and a recent patch saw
> an implementation of in-kernel rings (as separate from userspace).
> 
> This patch attempts to abstract the business of dealing with the
> virtio ring layout from the access (userspace or direct); to do this,
> we use function pointers, which gcc inlines correctly.
> 
> FIXME: strong barriers a-la virtio weak_barrier flag.
> FIXME: separate notify call with flag if we wrapped.
> FIXME: move to vhost/vringh.c.
> FIXME: test :)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 202bba6..38ec470 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -1,6 +1,7 @@
>  config VHOST_NET
>  	tristate "Host kernel accelerator for virtio net (EXPERIMENTAL)"
>  	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP) && EXPERIMENTAL
> +	select VHOST
>  	---help---
>  	  This kernel module can be loaded in host kernel to accelerate
>  	  guest networking with virtio_net. Not to be confused with virtio_net
> diff --git a/drivers/vhost/Kconfig.tcm b/drivers/vhost/Kconfig.tcm
> index a9c6f76..f4c3704 100644
> --- a/drivers/vhost/Kconfig.tcm
> +++ b/drivers/vhost/Kconfig.tcm
> @@ -1,6 +1,7 @@
>  config TCM_VHOST
>  	tristate "TCM_VHOST fabric module (EXPERIMENTAL)"
>  	depends on TARGET_CORE && EVENTFD && EXPERIMENTAL && m
> +	select VHOST
>  	default n
>  	---help---
>  	Say M here to enable the TCM_VHOST fabric module for use with virtio-scsi guests
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 8d5bddb..fd95d3e 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -5,6 +5,12 @@ config VIRTIO
>  	  bus, such as CONFIG_VIRTIO_PCI, CONFIG_VIRTIO_MMIO, CONFIG_LGUEST,
>  	  CONFIG_RPMSG or CONFIG_S390_GUEST.
>  
> +config VHOST
> +	tristate
> +	---help---
> +	  This option is selected by any driver which needs to access
> +	  the host side of a virtio ring.
> +
>  menu "Virtio drivers"
>  
>  config VIRTIO_PCI
> diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
> index 9076635..9833cd5 100644
> --- a/drivers/virtio/Makefile
> +++ b/drivers/virtio/Makefile
> @@ -2,3 +2,4 @@ obj-$(CONFIG_VIRTIO) += virtio.o virtio_ring.o
>  obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
>  obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
>  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
> +obj-$(CONFIG_VHOST) += virtio_host.o
> diff --git a/drivers/virtio/virtio_host.c b/drivers/virtio/virtio_host.c
> new file mode 100644
> index 0000000..7416741
> --- /dev/null
> +++ b/drivers/virtio/virtio_host.c
> @@ -0,0 +1,618 @@
> +/*
> + * Helpers for the host side of a virtio ring.
> + *
> + * Since these may be in userspace, we use (inline) accessors.
> + */
> +#include <linux/virtio_host.h>
> +#include <linux/kernel.h>
> +#include <linux/ratelimit.h>
> +#include <linux/uaccess.h>
> +#include <linux/slab.h>
> +
> +static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
> +{
> +	static DEFINE_RATELIMIT_STATE(vringh_rs,
> +				      DEFAULT_RATELIMIT_INTERVAL,
> +				      DEFAULT_RATELIMIT_BURST);
> +	if (__ratelimit(&vringh_rs)) {
> +		va_list ap;
> +		va_start(ap, fmt);
> +		printk(KERN_NOTICE "vringh:");
> +		vprintk(fmt, ap);
> +		va_end(ap);
> +	}
> +}
> +
> +/* Returns vring->num if empty, -ve on error. */
> +static inline int __vringh_get_head(const struct vringh *vrh,
> +				    int (*getu16)(u16 *val, const u16 *p),
> +				    u16 *last_avail_idx)
> +{
> +	u16 avail_idx, i, head;
> +	int err;
> +
> +	err = getu16(&avail_idx, &vrh->vring.avail->idx);
> +	if (err) {
> +		vringh_bad("Failed to access avail idx at %p",
> +			   &vrh->vring.avail->idx);
> +		return err;
> +	}
> +
> +	err = getu16(last_avail_idx, &vring_avail_event(&vrh->vring));
> +	if (err) {
> +		vringh_bad("Failed to access last avail idx at %p",
> +			   &vring_avail_event(&vrh->vring));
> +		return err;
> +	}
> +
> +	if (*last_avail_idx == avail_idx)
> +		return vrh->vring.num;
> +
> +	/* Only get avail ring entries after they have been exposed by guest. */
> +	smp_rmb();
> +
> +	i = *last_avail_idx & (vrh->vring.num - 1);
> +
> +	err = getu16(&head, &vrh->vring.avail->ring[i]);
> +	if (err) {
> +		vringh_bad("Failed to read head: idx %d address %p",
> +			   *last_avail_idx, &vrh->vring.avail->ring[i]);
> +		return err;
> +	}
> +
> +	if (head >= vrh->vring.num) {
> +		vringh_bad("Guest says index %u > %u is available",
> +			   head, vrh->vring.num);
> +		return -EINVAL;
> +	}
> +	return head;
> +}
> +
> +/* Copy some bytes to/from the iovec.  Returns num copied. */
> +static inline ssize_t vringh_iov_xfer(struct vringh_iov *iov,
> +				      void *ptr, size_t len,
> +				      int (*xfer)(void __user *addr, void *ptr,
> +						  size_t len))
> +{
> +	int err, done = 0;
> +
> +	while (len && iov->i < iov->max) {
> +		size_t partlen;
> +
> +		partlen = min(iov->iov[iov->i].iov_len, len);
> +		err = xfer(iov->iov[iov->i].iov_base, ptr, partlen);
> +		if (err)
> +			return err;
> +		done += partlen;
> +		iov->iov[iov->i].iov_base += partlen;
> +		iov->iov[iov->i].iov_len -= partlen;
> +
> +		if (iov->iov[iov->i].iov_len == 0)
> +			iov->i++;
> +	}
> +	return done;
> +}
> +
> +static inline bool check_range(u64 addr, u32 len,
> +			       struct vringh_range *range,
> +			       bool (*getrange)(u64, struct vringh_range *))
> +{
> +	if (addr < range->start || addr > range->end_incl) {
> +		if (!getrange(addr, range))
> +			goto bad;
> +	}
> +	BUG_ON(addr < range->start || addr > range->end_incl);
> +
> +	/* To end of memory? */
> +	if (unlikely(addr + len == 0)) {
> +		if (range->end_incl == -1ULL)
> +			return true;
> +		goto bad;
> +	}
> +
> +	/* Otherwise, don't wrap. */
> +	if (unlikely(addr + len < addr))
> +		goto bad;
> +	if (unlikely(addr + len > range->end_incl))
> +		goto bad;
> +	return true;
> +
> +bad:
> +	vringh_bad("Malformed descriptor address %u@0x%llx", len, addr);
> +	return false;
> +}
> +
> +/* No reason for this code to be inline. */
> +static int move_to_indirect(int *up_next, u16 *i, void *addr,
> +			    const struct vring_desc *desc,
> +			    struct vring_desc **descs, int *desc_max)
> +{
> +	/* Indirect tables can't have indirect. */
> +	if (*up_next != -1) {
> +		vringh_bad("Multilevel indirect %u->%u", *up_next, *i);
> +		return -EINVAL;
> +	}
> +
> +	if (unlikely(desc->len % sizeof(struct vring_desc))) {
> +		vringh_bad("Strange indirect len %u", desc->len);
> +		return -EINVAL;
> +	}
> +
> +	/* We will check this when we follow it! */
> +	if (desc->flags & VRING_DESC_F_NEXT)
> +		*up_next = desc->next;
> +	else
> +		*up_next = -2;
> +	*descs = addr;
> +	*desc_max = desc->len / sizeof(struct vring_desc);
> +
> +	/* Now, start at the first indirect. */
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int resize_iovec(struct vringh_iov *iov, gfp_t gfp)
> +{
> +	struct iovec *new;
> +	unsigned int new_num = iov->max * 2;

We must limit this I think, this is coming
from userspace. How about UIO_MAXIOV?

> +
> +	if (new_num < 8)
> +		new_num = 8;
> +
> +	if (iov->allocated)
> +		new = krealloc(iov->iov, new_num * sizeof(struct iovec), gfp);
> +	else {
> +		new = kmalloc(new_num * sizeof(struct iovec), gfp);
> +		if (new) {
> +			memcpy(new, iov->iov, iov->i * sizeof(struct iovec));
> +			iov->allocated = true;
> +		}
> +	}
> +	if (!new)
> +		return -ENOMEM;
> +	iov->iov = new;
> +	iov->max = new_num;
> +	return 0;
> +}
> +
> +static u16 __cold return_from_indirect(const struct vringh *vrh, int *up_next,
> +				       struct vring_desc **descs, int *desc_max)

Not sure it should be cold like that - virtio net uses indirect on data
path.

> +{
> +	u16 i = *up_next;
> +
> +	*up_next = -1;
> +	*descs = vrh->vring.desc;
> +	*desc_max = vrh->vring.num;
> +	return i;
> +}
> +
> +static inline int
> +__vringh_iov(struct vringh *vrh, u16 i,
> +	     struct vringh_iov *riov,
> +	     struct vringh_iov *wiov,
> +	     bool (*getrange)(u64 addr, struct vringh_range *r),
> +	     gfp_t gfp,
> +	     int (*getdesc)(struct vring_desc *dst, const struct vring_desc *s))
> +{
> +	int err, count = 0, up_next, desc_max;
> +	struct vring_desc desc, *descs;
> +	struct vringh_range range = { -1ULL, 0 };
> +
> +	/* We start traversing vring's descriptor table. */
> +	descs = vrh->vring.desc;
> +	desc_max = vrh->vring.num;
> +	up_next = -1;
> +
> +	riov->i = wiov->i = 0;
> +	for (;;) {
> +		void *addr;
> +		struct vringh_iov *iov;
> +
> +		err = getdesc(&desc, &descs[i]);
> +		if (unlikely(err))
> +			goto fail;
> +
> +		/* Make sure it's OK, and get offset. */
> +		if (!check_range(desc.addr, desc.len, &range, getrange)) {
> +			err = -EINVAL;
> +			goto fail;
> +		}

Hmm this looks like it will translate and
validate immediate descriptors same way as indirect ones.
vhost-net has different translation for regular descriptors
and indirect ones, both for speed and to allow ring aliasing,
so it has to know which is which.



> +		addr = (void *)(long)desc.addr + range.offset;

I really dislike raw pointers that we must never dereference.
Since we are forcing everything to __user anyway, why don't we
tag all addresses as __user? The kernel users of this API
can cast that away, this will keep the casts to minimum.

Failing that, we can add our own class
# define __virtio         __attribute__((noderef, address_space(2)))


> +
> +		if (unlikely(desc.flags & VRING_DESC_F_INDIRECT)) {
> +			err = move_to_indirect(&up_next, &i, addr, &desc,
> +					       &descs, &desc_max);
> +			if (err)
> +				goto fail;
> +			continue;
> +		}
> +
> +		if (desc.flags & VRING_DESC_F_WRITE)
> +			iov = wiov;
> +		else {
> +			iov = riov;
> +			if (unlikely(wiov->i)) {
> +				vringh_bad("Readable desc %p after writable",
> +					   &descs[i]);
> +				err = -EINVAL;
> +				goto fail;
> +			}
> +		}
> +
> +		if (unlikely(iov->i == iov->max)) {
> +			err = resize_iovec(iov, gfp);
> +			if (err)
> +				goto fail;
> +		}
> +
> +		iov->iov[iov->i].iov_base = (__force __user void *)addr;
> +		iov->iov[iov->i].iov_len = desc.len;
> +		iov->i++;


This looks like it won't do the right thing if desc.len spans multiple
ranges. I don't know if this happens in practice but this is something
vhost supports ATM.

> +
> +		if (++count == vrh->vring.num) {
> +			vringh_bad("Descriptor loop in %p", descs);
> +			err = -ELOOP;
> +			goto fail;
> +		}
> +
> +		if (desc.flags & VRING_DESC_F_NEXT) {
> +			i = desc.next;
> +		} else {
> +			/* Just in case we need to finish traversing above. */
> +			if (unlikely(up_next > 0))
> +				i = return_from_indirect(vrh, &up_next,
> +							 &descs, &desc_max);
> +			else
> +				break;
> +		}
> +
> +		if (i >= desc_max) {
> +			vringh_bad("Chained index %u > %u", i, desc_max);
> +			err = -EINVAL;
> +			goto fail;
> +		}
> +	}
> +
> +	/* Reset for fresh iteration. */
> +	riov->i = wiov->i = 0;
> +	return 0;
> +
> +fail:
> +	if (riov->allocated)
> +		kfree(riov->iov);
> +	if (wiov->allocated)
> +		kfree(wiov->iov);
> +	return err;
> +}
> +
> +static inline int __vringh_complete(struct vringh *vrh, u16 idx, u32 len,
> +				    int (*getu16)(u16 *val, const u16 *p),
> +				    int (*putu16)(u16 *p, u16 val),
> +				    int (*putused)(struct vring_used_elem *dst,
> +						   const struct vring_used_elem
> +						   *s),
> +				    bool *notify)
> +{
> +	struct vring_used_elem used;
> +	struct vring_used *used_ring;
> +	int err;
> +	u16 used_idx, old, used_event;
> +
> +	used.id = idx;
> +	used.len = len;
> +
> +	err = getu16(&used_idx, &vring_used_event(&vrh->vring));
> +	if (err) {
> +		vringh_bad("Failed to access used event %p",
> +			   &vring_used_event(&vrh->vring));
> +		return err;
> +	}
> +
> +	used_ring = vrh->vring.used;
> +
> +	err = putused(&used_ring->ring[used_idx % vrh->vring.num], &used);
> +	if (err) {
> +		vringh_bad("Failed to write used entry %u at %p",
> +			   used_idx % vrh->vring.num,
> +			   &used_ring->ring[used_idx % vrh->vring.num]);
> +		return err;
> +	}
> +
> +	/* Make sure buffer is written before we update index. */
> +	smp_wmb();
> +
> +	old = vrh->last_used_idx;
> +	vrh->last_used_idx++;
> +
> +	err = putu16(&vrh->vring.used->idx, vrh->last_used_idx);
> +	if (err) {
> +		vringh_bad("Failed to update used index at %p",
> +			   &vrh->vring.used->idx);
> +		return err;
> +	}
> +
> +	/* If we already know we need to notify, skip re-checking */
> +	if (*notify)
> +		return 0;
> +
> +	/* Flush out used index update. This is paired with the
> +	 * barrier that the Guest executes when enabling
> +	 * interrupts. */
> +	smp_mb();
> +
> +	/* Old-style, without event indices. */
> +	if (!vrh->event_indices) {
> +		u16 flags;
> +		err = getu16(&flags, &vrh->vring.avail->flags);
> +		if (err) {
> +			vringh_bad("Failed to get flags at %p",
> +				   &vrh->vring.avail->flags);
> +			return err;
> +		}
> +		if (!(flags & VRING_AVAIL_F_NO_INTERRUPT))
> +			*notify = true;
> +		return 0;
> +	}
> +
> +	/* Modern: we know where other side is up to. */
> +	err = getu16(&used_event, &vring_used_event(&vrh->vring));
> +	if (err) {
> +		vringh_bad("Failed to get used event idx at %p",
> +			   &vring_used_event(&vrh->vring));
> +		return err;
> +	}
> +	if (vring_need_event(used_event, vrh->last_used_idx, old))
> +		*notify = true;
> +	return 0;
> +}
> +
> +static inline bool __vringh_notify_enable(struct vringh *vrh,
> +					  int (*getu16)(u16 *val, const u16 *p),
> +					  int (*putu16)(u16 *p, u16 val))
> +{
> +	u16 avail;
> +
> +	/* Already enabled? */
> +	if (vrh->listening)
> +		return false;
> +
> +	vrh->listening = true;
> +
> +	if (!vrh->event_indices) {
> +		/* Old-school; update flags. */
> +		if (putu16(&vrh->vring.used->flags, 0) != 0) {
> +			vringh_bad("Clearing used flags %p",
> +				   &vrh->vring.used->flags);
> +			return false;
> +		}
> +	} else {
> +		if (putu16(&vring_avail_event(&vrh->vring),
> +			   vrh->last_avail_idx) != 0) {
> +			vringh_bad("Updating avail event index %p",
> +				   &vring_avail_event(&vrh->vring));
> +			return false;
> +		}
> +	}
> +
> +	/* They could have slipped one in as we were doing that: make
> +	 * sure it's written, then check again. */
> +	smp_mb();
> +
> +	if (getu16(&avail, &vrh->vring.avail->idx) != 0) {
> +		vringh_bad("Failed to check avail idx at %p",
> +			   &vrh->vring.avail->idx);
> +		return false;
> +	}
> +
> +	/* This is so unlikely, we just leave notifications enabled. */
> +	return avail != vrh->last_avail_idx;
> +}
> +
> +static inline void __vringh_notify_disable(struct vringh *vrh,
> +					   int (*putu16)(u16 *p, u16 val))
> +{
> +	/* Already disabled? */
> +	if (!vrh->listening)
> +		return;
> +
> +	vrh->listening = false;
> +	if (!vrh->event_indices) {
> +		/* Old-school; update flags. */
> +		if (putu16(&vrh->vring.used->flags, VRING_USED_F_NO_NOTIFY)) {
> +			vringh_bad("Setting used flags %p",
> +				   &vrh->vring.used->flags);
> +		}
> +	}
> +}
> +
> +/* Userspace access helpers. */
> +static inline int getu16_user(u16 *val, const u16 *p)
> +{
> +	return get_user(*val, (__force u16 __user *)p);
> +}
> +
> +static inline int putu16_user(u16 *p, u16 val)
> +{
> +	return put_user(val, (__force u16 __user *)p);
> +}
> +
> +static inline int getdesc_user(struct vring_desc *dst,
> +			       const struct vring_desc *src)
> +{
> +	return copy_from_user(dst, (__force void *)src, sizeof(*dst)) == 0 ? 0 :
> +		-EFAULT;
> +}
> +
> +static inline int putused_user(struct vring_used_elem *dst,
> +			       const struct vring_used_elem *s)
> +{
> +	return copy_to_user((__force void __user *)dst, s, sizeof(*dst)) == 0
> +		? 0 : -EFAULT;
> +}
> +
> +static inline int xfer_from_user(void *src, void *dst, size_t len)
> +{
> +	return copy_from_user(dst, (__force void *)src, len) == 0 ? 0 :
> +		-EFAULT;
> +}
> +
> +static inline int xfer_to_user(void *dst, void *src, size_t len)
> +{
> +	return copy_to_user((__force void *)dst, src, len) == 0 ? 0 :
> +		-EFAULT;
> +}
> +
> +/**
> + * vringh_init_user - initialize a vringh for a userspace vring.
> + * @vrh: the vringh to initialize.
> + * @features: the feature bits for this ring.
> + * @num: the number of elements.
> + * @desc: the userpace descriptor pointer.
> + * @avail: the userpace avail pointer.
> + * @used: the userpace used pointer.
> + *
> + * Returns an error if num is invalid: you should check pointers
> + * yourself!
> + */
> +int vringh_init_user(struct vringh *vrh, u32 features,
> +		     unsigned int num,
> +		     struct vring_desc __user *desc,
> +		     struct vring_avail __user *avail,
> +		     struct vring_used __user *used)
> +{
> +	/* Sane power of 2 please! */
> +	if (!num || num > 0xffff || (num & (num - 1))) {
> +		vringh_bad("Bad ring size %zu", num);
> +		return -EINVAL;
> +	}
> +
> +	vrh->event_indices = (features & VIRTIO_RING_F_EVENT_IDX);
> +	vrh->listening = false;
> +	vrh->last_avail_idx = 0;
> +	vrh->last_used_idx = 0;
> +	vrh->vring.num = num;
> +	vrh->vring.desc = (__force struct vring_desc *)desc;
> +	vrh->vring.avail = (__force struct vring_avail *)avail;
> +	vrh->vring.used = (__force struct vring_used *)used;
> +	return 0;
> +}
> +
> +/**
> + * vringh_getdesc_user - get next available descriptor from userspace ring.
> + * @vrh: the userspace vring.
> + * @riov: where to put the readable descriptors.
> + * @wiov: where to put the writable descriptors.
> + * @getrange: function to call to check ranges.
> + * @head: head index we received, for passing to vringh_complete_user().
> + * @gfp: flags for allocating larger riov/wiov.
> + *
> + * Returns 0 if there was no descriptor, 1 if there was, or -errno.
> + *
> + * If it returns 1, riov->allocated and wiov->allocated indicate if you
> + * have to kfree riov->iov and wiov->iov respectively.
> + */
> +int vringh_getdesc_user(struct vringh *vrh,
> +			struct vringh_iov *riov,
> +			struct vringh_iov *wiov,
> +			bool (*getrange)(u64 addr, struct vringh_range *r),
> +			u16 *head,
> +			gfp_t gfp)
> +{
> +	int err;
> +
> +	err = __vringh_get_head(vrh, getu16_user, &vrh->last_avail_idx);
> +	if (err < 0)
> +		return err;
> +
> +	/* Empty... */
> +	if (err == vrh->vring.num)
> +		return 0;
> +
> +	*head = err;
> +	err = __vringh_iov(vrh, *head, riov, wiov, getrange, gfp, getdesc_user);
> +	if (err)
> +		return err;
> +
> +	return 1;
> +}
> +
> +/**
> + * vringh_iov_pull_user - copy bytes from vring_iov.
> + * @riov: the riov as passed to vringh_getdesc_user() (updated as we consume)
> + * @dst: the place to copy.
> + * @len: the maximum length to copy.
> + *
> + * Returns the bytes copied <= len or a negative errno.
> + */
> +ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len)
> +{
> +	return vringh_iov_xfer(riov, dst, len, xfer_from_user);
> +}
> +
> +/**
> + * vringh_iov_push_user - copy bytes into vring_iov.
> + * @wiov: the wiov as passed to vringh_getdesc_user() (updated as we consume)
> + * @dst: the place to copy.
> + * @len: the maximum length to copy.
> + *
> + * Returns the bytes copied <= len or a negative errno.
> + */
> +ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
> +			     const void *src, size_t len)
> +{
> +	return vringh_iov_xfer(wiov, (void *)src, len, xfer_to_user);
> +}
> +
> +/**
> + * vringh_abandon_user - we've decided not to handle the descriptor(s).
> + * @vrh: the vring.
> + * @num: the number of descriptors to put back (ie. num
> + *	 vringh_get_user() to undo).
> + *
> + * The next vringh_get_user() will return the old descriptor(s) again.
> + */
> +void vringh_abandon_user(struct vringh *vrh, unsigned int num)
> +{
> +	/* We only update vring_avail_event(vr) when we want to be notified,
> +	 * so we haven't changed that yet. */
> +	vrh->last_avail_idx -= num;
> +}
> +
> +/**
> + * vringh_complete_user - we've finished with descriptor, publish it.
> + * @vrh: the vring.
> + * @head: the head as filled in by vringh_getdesc_user.
> + * @len: the length of data we have written.
> + * @notify: set if we should notify the other side, otherwise left alone.
> + */
> +int vringh_complete_user(struct vringh *vrh, u16 head, u32 len,
> +			 bool *notify)
> +{
> +	return __vringh_complete(vrh, head, len,
> +				 getu16_user, putu16_user, putused_user,
> +				 notify);
> +}
> +
> +/**
> + * vringh_notify_enable_user - we want to know if something changes.
> + * @vrh: the vring.
> + *
> + * This always enables notifications, but returns true if there are
> + * now more buffers available in the vring.
> + */
> +bool vringh_notify_enable_user(struct vringh *vrh)
> +{
> +	return __vringh_notify_enable(vrh, getu16_user, putu16_user);
> +}
> +
> +/**
> + * vringh_notify_disable_user - don't tell us if something changes.
> + * @vrh: the vring.
> + *
> + * This is our normal running state: we disable and then only enable when
> + * we're going to sleep.
> + */
> +void vringh_notify_disable_user(struct vringh *vrh)
> +{
> +	__vringh_notify_disable(vrh, putu16_user);
> +}
> diff --git a/include/linux/virtio_host.h b/include/linux/virtio_host.h
> new file mode 100644
> index 0000000..07bb4f6
> --- /dev/null
> +++ b/include/linux/virtio_host.h
> @@ -0,0 +1,88 @@
> +/*
> + * Linux host-side vring helpers; for when the kernel needs to access
> + * someone else's vring.
> + *
> + * Copyright IBM Corporation, 2013.
> + * Parts taken from drivers/vhost/vhost.c Copyright 2009 Red Hat, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Written by: Rusty Russell <rusty@rustcorp.com.au>
> + */
> +#ifndef _LINUX_VIRTIO_HOST_H
> +#define _LINUX_VIRTIO_HOST_H
> +#include <uapi/linux/virtio_ring.h>
> +#include <uapi/linux/uio.h>
> +
> +/* virtio_ring with information needed for host access. */
> +struct vringh {
> +	/* Guest publishes used event idx (note: we always do). */
> +	bool event_indices;
> +
> +	/* Have we told the other end we want to be notified? */
> +	bool listening;
> +
> +	/* Last available index we saw (ie. where we're up to). */
> +	u16 last_avail_idx;
> +
> +	/* Last index we used. */
> +	u16 last_used_idx;
> +
> +	/* The vring (note: it may contain user pointers!) */
> +	struct vring vring;
> +};
> +
> +/* The memory the vring can access, and what offset to apply. */
> +struct vringh_range {
> +	u64 start, end_incl;
> +	u64 offset;
> +};
> +
> +/* All the information about an iovec. */
> +struct vringh_iov {
> +	struct iovec *iov;
> +	unsigned i, max;
> +	bool allocated;

MAybe set iov = NULL when not allocated?

> +};
> +
> +/* Helpers for userspace vrings. */
> +int vringh_init_user(struct vringh *vrh, u32 features,
> +		     unsigned int num,
> +		     struct vring_desc __user *desc,
> +		     struct vring_avail __user *avail,
> +		     struct vring_used __user *used);
> +
> +/* Convert a descriptor into iovecs. */
> +int vringh_getdesc_user(struct vringh *vrh,
> +			struct vringh_iov *riov,
> +			struct vringh_iov *wiov,
> +			bool (*getrange)(u64 addr, struct vringh_range *r),
> +			u16 *head,
> +			gfp_t gfp);
> +
> +/* Copy bytes from readable vsg, consuming it (and incrementing wiov->i). */
> +ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len);
> +
> +/* Copy bytes into writable vsg, consuming it (and incrementing wiov->i). */
> +ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
> +			     const void *src, size_t len);
> +
> +/* Mark a descriptor as used.  Sets notify if you should fire eventfd. */
> +int vringh_complete_user(struct vringh *vrh, u16 head, u32 len,
> +			 bool *notify);
> +
> +/* Pretend we've never seen descriptor (for easy error handling). */
> +void vringh_abandon_user(struct vringh *vrh, unsigned int num);
> +#endif /* _LINUX_VIRTIO_HOST_H */
