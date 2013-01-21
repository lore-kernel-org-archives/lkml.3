Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3AUMBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:01:21 -0500
Received: from ozlabs.org ([203.10.76.45]:51658 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3AUMBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:01:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
In-Reply-To: <20130117095845.GD14388@redhat.com>
References: <CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com> <87pq1f2rj0.fsf@rustcorp.com.au> <87wqvl1g9s.fsf@rustcorp.com.au> <CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com> <87pq1c1uj4.fsf@rustcorp.com.au> <877gnk1ayv.fsf@rustcorp.com.au> <20130114173914.GB19207@redhat.com> <874nihzuoz.fsf@rustcorp.com.au> <20130116081606.GB11465@redhat.com> <87k3rcy2y2.fsf@rustcorp.com.au> <20130117095845.GD14388@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 21 Jan 2013 22:25:37 +1030
Message-ID: <87pq0yvjgm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Thu, Jan 17, 2013 at 12:40:29PM +1030, Rusty Russell wrote:
>> I resist sprinkling __user everywhere because it's *not* always user
>> addresses, and it's deeply misleading to anyone reading it.  I'd rather
>> have it in one place with a big comment.
>> I can try using a union of kvec and iovec, since they are the same
>> layout in practice AFAICT.
>
> I suggest the following easy fix: as you say, it's
> in one place with a bug comment.
>
> /* On the host side we often communicate to untrusted
>  * entities over virtio, so set __user tag on addresses
>  * we get helps make sure we don't directly dereference the addresses,
>  * while making it possible to pass the addresses in iovec arrays
>  * without casts.
>  */
> #define __virtio __user
>
> /* A helper to discard __virtio tag - only call when
>  * you are communicating to a trusted entity.
>  */
> static inline void *virtio_raw_addr(__virtio void *addr)
> {
> 	return (__force void *)addr;
> }
>
> Hmm?

The two problems are iovec, which contains a __user address, and that
gets exposed via the API, and vring, which *doesn't* use __user
addresses.

This is ugly, but works:

vringh: use vringh_kiov for _kern functions, and internally.

This makes user of vringh perfectly __user-clean, and removes an
internal cast.

This only works because of -fno-strict-aliasing!

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index ab10da8..2ba087d 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -65,9 +65,9 @@ static inline int __vringh_get_head(const struct vringh *vrh,
 }
 
 /* Copy some bytes to/from the iovec.  Returns num copied. */
-static inline ssize_t vringh_iov_xfer(struct vringh_iov *iov,
+static inline ssize_t vringh_iov_xfer(struct vringh_kiov *iov,
 				      void *ptr, size_t len,
-				      int (*xfer)(void __user *addr, void *ptr,
+				      int (*xfer)(void *addr, void *ptr,
 						  size_t len))
 {
 	int err, done = 0;
@@ -149,9 +149,9 @@ static int move_to_indirect(int *up_next, u16 *i, void *addr,
 	return 0;
 }
 
-static int resize_iovec(struct vringh_iov *iov, gfp_t gfp)
+static int resize_iovec(struct vringh_kiov *iov, gfp_t gfp)
 {
-	struct iovec *new;
+	struct kvec *new;
 	unsigned int new_num = iov->max * 2;
 
 	if (new_num < 8)
@@ -186,8 +186,8 @@ static u16 __cold return_from_indirect(const struct vringh *vrh, int *up_next,
 
 static inline int
 __vringh_iov(struct vringh *vrh, u16 i,
-	     struct vringh_iov *riov,
-	     struct vringh_iov *wiov,
+	     struct vringh_kiov *riov,
+	     struct vringh_kiov *wiov,
 	     bool (*getrange)(u64 addr, struct vringh_range *r),
 	     gfp_t gfp,
 	     int (*getdesc)(struct vring_desc *dst, const struct vring_desc *s))
@@ -204,7 +204,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 	riov->i = wiov->i = 0;
 	for (;;) {
 		void *addr;
-		struct vringh_iov *iov;
+		struct vringh_kiov *iov;
 
 		err = getdesc(&desc, &descs[i]);
 		if (unlikely(err))
@@ -249,7 +249,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 				goto fail;
 		}
 
-		iov->iov[iov->i].iov_base = (__force __user void *)addr;
+		iov->iov[iov->i].iov_base = addr;
 		iov->iov[iov->i].iov_len = desc.len;
 		iov->i++;
 
@@ -438,7 +438,7 @@ static inline void __vringh_notify_disable(struct vringh *vrh,
 	}
 }
 
-/* Userspace access helpers. */
+/* Userspace access helpers: in this case, addresses are really userspace. */
 static inline int getu16_user(u16 *val, const u16 *p)
 {
 	return get_user(*val, (__force u16 __user *)p);
@@ -452,27 +452,27 @@ static inline int putu16_user(u16 *p, u16 val)
 static inline int getdesc_user(struct vring_desc *dst,
 			       const struct vring_desc *src)
 {
-	return copy_from_user(dst, (__force void *)src, sizeof(*dst)) == 0 ? 0 :
-		-EFAULT;
+	return copy_from_user(dst, (__force void __user *)src, sizeof(*dst)) ?
+		-EFAULT : 0;
 }
 
 static inline int putused_user(struct vring_used_elem *dst,
 			       const struct vring_used_elem *s)
 {
-	return copy_to_user((__force void __user *)dst, s, sizeof(*dst)) == 0
-		? 0 : -EFAULT;
+	return copy_to_user((__force void __user *)dst, s, sizeof(*dst)) ?
+		-EFAULT : 0;
 }
 
 static inline int xfer_from_user(void *src, void *dst, size_t len)
 {
-	return copy_from_user(dst, (__force void *)src, len) == 0 ? 0 :
-		-EFAULT;
+	return copy_from_user(dst, (__force void __user *)src, len) ?
+		-EFAULT : 0;
 }
 
 static inline int xfer_to_user(void *dst, void *src, size_t len)
 {
-	return copy_to_user((__force void *)dst, src, len) == 0 ? 0 :
-		-EFAULT;
+	return copy_to_user((__force void __user *)dst, src, len) ?
+		-EFAULT : 0;
 }
 
 /**
@@ -506,6 +506,7 @@ int vringh_init_user(struct vringh *vrh, u32 features,
 	vrh->last_avail_idx = 0;
 	vrh->last_used_idx = 0;
 	vrh->vring.num = num;
+	/* vring expects kernel addresses, but only used via accessors. */
 	vrh->vring.desc = (__force struct vring_desc *)desc;
 	vrh->vring.avail = (__force struct vring_avail *)avail;
 	vrh->vring.used = (__force struct vring_used *)used;
@@ -543,8 +544,30 @@ int vringh_getdesc_user(struct vringh *vrh,
 	if (err == vrh->vring.num)
 		return 0;
 
+	/* We need the layouts to be the indentical for this to work */
+	BUILD_BUG_ON(sizeof(struct vringh_kiov) != sizeof(struct vringh_iov));
+	BUILD_BUG_ON(offsetof(struct vringh_kiov, iov) !=
+		     offsetof(struct vringh_iov, iov));
+	BUILD_BUG_ON(offsetof(struct vringh_kiov, i) !=
+		     offsetof(struct vringh_iov, i));
+	BUILD_BUG_ON(offsetof(struct vringh_kiov, max) !=
+		     offsetof(struct vringh_iov, max));
+	BUILD_BUG_ON(offsetof(struct vringh_kiov, allocated) !=
+		     offsetof(struct vringh_iov, allocated));
+	BUILD_BUG_ON(sizeof(struct iovec) != sizeof(struct kvec));
+	BUILD_BUG_ON(offsetof(struct iovec, iov_base) !=
+		     offsetof(struct kvec, iov_base));
+	BUILD_BUG_ON(offsetof(struct iovec, iov_len) !=
+		     offsetof(struct kvec, iov_len));
+	BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_base)
+		     != sizeof(((struct kvec *)NULL)->iov_base));
+	BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_len)
+		     != sizeof(((struct kvec *)NULL)->iov_len));
+
 	*head = err;
-	err = __vringh_iov(vrh, *head, riov, wiov, getrange, gfp, getdesc_user);
+	err = __vringh_iov(vrh, *head, (struct vringh_kiov *)riov,
+			   (struct vringh_kiov *)wiov,
+			   getrange, gfp, getdesc_user);
 	if (err)
 		return err;
 
@@ -561,7 +584,8 @@ int vringh_getdesc_user(struct vringh *vrh,
  */
 ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len)
 {
-	return vringh_iov_xfer(riov, dst, len, xfer_from_user);
+	return vringh_iov_xfer((struct vringh_kiov *)riov,
+			       dst, len, xfer_from_user);
 }
 
 /**
@@ -575,7 +599,8 @@ ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len)
 ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
 			     const void *src, size_t len)
 {
-	return vringh_iov_xfer(wiov, (void *)src, len, xfer_to_user);
+	return vringh_iov_xfer((struct vringh_kiov *)wiov,
+			       (void *)src, len, xfer_to_user);
 }
 
 /**
@@ -734,8 +759,8 @@ int vringh_init_kern(struct vringh *vrh, u32 features,
  * have to kfree riov->iov and wiov->iov respectively.
  */
 int vringh_getdesc_kern(struct vringh *vrh,
-			struct vringh_iov *riov,
-			struct vringh_iov *wiov,
+			struct vringh_kiov *riov,
+			struct vringh_kiov *wiov,
 			u16 *head,
 			gfp_t gfp)
 {
@@ -766,7 +791,7 @@ int vringh_getdesc_kern(struct vringh *vrh,
  *
  * Returns the bytes copied <= len or a negative errno.
  */
-ssize_t vringh_iov_pull_kern(struct vringh_iov *riov, void *dst, size_t len)
+ssize_t vringh_iov_pull_kern(struct vringh_kiov *riov, void *dst, size_t len)
 {
 	return vringh_iov_xfer(riov, dst, len, xfer_kern);
 }
@@ -779,7 +804,7 @@ ssize_t vringh_iov_pull_kern(struct vringh_iov *riov, void *dst, size_t len)
  *
  * Returns the bytes copied <= len or a negative errno.
  */
-ssize_t vringh_iov_push_kern(struct vringh_iov *wiov,
+ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
 			     const void *src, size_t len)
 {
 	return vringh_iov_xfer(wiov, (void *)src, len, xfer_kern);
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 9df86e9..b3345e9 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -24,7 +24,7 @@
 #ifndef _LINUX_VRINGH_H
 #define _LINUX_VRINGH_H
 #include <uapi/linux/virtio_ring.h>
-#include <uapi/linux/uio.h>
+#include <linux/uio.h>
 #include <asm/barrier.h>
 
 /* virtio_ring with information needed for host access. */
@@ -64,6 +64,13 @@ struct vringh_iov {
 	bool allocated;
 };
 
+/* All the information about a kvec. */
+struct vringh_kiov {
+	struct kvec *iov;
+	unsigned i, max;
+	bool allocated;
+};
+
 /* Helpers for userspace vrings. */
 int vringh_init_user(struct vringh *vrh, u32 features,
 		     unsigned int num, bool weak_barriers,
@@ -103,13 +110,13 @@ int vringh_init_kern(struct vringh *vrh, u32 features,
 		     struct vring_used *used);
 
 int vringh_getdesc_kern(struct vringh *vrh,
-			struct vringh_iov *riov,
-			struct vringh_iov *wiov,
+			struct vringh_kiov *riov,
+			struct vringh_kiov *wiov,
 			u16 *head,
 			gfp_t gfp);
 
-ssize_t vringh_iov_pull_kern(struct vringh_iov *riov, void *dst, size_t len);
-ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
+ssize_t vringh_iov_pull_kern(struct vringh_kiov *riov, void *dst, size_t len);
+ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
 			     const void *src, size_t len);
 void vringh_abandon_kern(struct vringh *vrh, unsigned int num);
 int vringh_complete_kern(struct vringh *vrh, u16 head, u32 len);
