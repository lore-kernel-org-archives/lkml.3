Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaLaSis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 13:38:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaLaSiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 13:38:46 -0500
Date: Wed, 31 Dec 2014 20:38:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH repost 12/16] parisc/uaccess: fix sparse errors
Message-ID: <20141231183824.GA32430@redhat.com>
References: <1419499661-8566-1-git-send-email-mst@redhat.com>
 <1419499661-8566-13-git-send-email-mst@redhat.com>
 <549C91B9.8080009@gmx.de>
 <20141227161414.GA2571@redhat.com>
 <1420046240.2085.3.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420046240.2085.3.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 09:17:20AM -0800, James Bottomley wrote:
> On Sat, 2014-12-27 at 18:14 +0200, Michael S. Tsirkin wrote:
> > On Thu, Dec 25, 2014 at 11:37:45PM +0100, Helge Deller wrote:
> > > Hi Michael,
> > > 
> > > On 12/25/2014 10:29 AM, Michael S. Tsirkin wrote:
> > > >virtio wants to read bitwise types from userspace using get_user.  At the
> > > 
> > > I don't know the virtio code much yet, but does it makes sense to read bitwise types?
> > > Will virtio then get possible troubles because of endianess correct as well?
> > 
> > There's no conversion: we are reading from __virtio16 __user *
> > pointer into __virtio16 v value.
> > 
> > > Do you have a code example, or the sparse error message ?
> > > 
> > > Helge
> > 
> > Sure. the code is upstream now.
> > The warning is below.
> > 
> > sparse warnings: (new ones prefixed by >>)
> > 
> > >> drivers/vhost/vringh.c:554:18: sparse: cast to restricted __virtio16
> > 
> > vim +554 drivers/vhost/vringh.c
> > 
> >    538                                                           __virtio16 *p, u16 val))
> >    539  {
> >    540          if (!vrh->event_indices) {
> >    541                  /* Old-school; update flags. */
> >    542                  if (putu16(vrh, &vrh->vring.used->flags,
> >    543                             VRING_USED_F_NO_NOTIFY)) {
> >    544                          vringh_bad("Setting used flags %p",
> >    545                                     &vrh->vring.used->flags);
> >    546                  }
> >    547          }
> >    548  }
> >    549
> >    550  /* Userspace access helpers: in this case, addresses are really userspace. */
> >    551  static inline int getu16_user(const struct vringh *vrh, u16 *val, const __virtio16 *p)
> >    552  {
> >    553          __virtio16 v = 0;
> >  > 554          int rc = get_user(v, (__force __virtio16 __user *)p);
> >    555          *val = vringh16_to_cpu(vrh, v);
> >    556          return rc;
> >    557  }
> >    558
> >    559  static inline int putu16_user(const struct vringh *vrh, __virtio16 *p, u16 val)
> >    560  {
> >    561          __virtio16 v = cpu_to_vringh16(vrh, val);
> >    562          return put_user(v, (__force __virtio16 __user *)p);
> 
> OK, parisc developers still being dense, but this does look like an
> abuse of the bitwise type.

To give you another example:

	__le16 __user *p;
	__le16 foo;
	int rc = get_user(v, p);

really should be fine, ATM this gives a warning.


>  bitwise is supposed to be consumed by endian
> specific accessors.

Surely, assignment is OK too? get_user is exactly that.

vringh16_to_cpu is an endian specific accessor.
Look up it's definition please. The reason for that __force is
because we are adding __user.
It's a decision Rusty made to reduce code duplication:
we have some code that handles both kernel and userspace pointers.

>  get/put_user have no endian tags because they
> really can't do this ... the potential for width mismatch between the
> user and kernel address spaces could cause havoc if people get this
> wrong, so the warning looks correct to me.


I'm sorry I don't understand.

Why is

	access_ok
	__get_user

safer than

	get_user

?

It does not trigger the warning, because
__get_user does not have the cast to long internally.

Also, on some architectures get_user does not cast to long
internally so there's no warning.

> If we take your proposed patch we lose the type checking on all
> accessors because of the __force.


Did you try?  In my testing, this is not at all true.

For example with my patch:


             u16 v = 0;
             int rc = get_user(v, (__force __virtio16 __user *)p);

correctly triggers a warning.



>  Why not, instead, alter your code to
> tell the kernel you know what you're doing:
> 
>         __u16 v = 0;
>         int rc = get_user(v, (__force __u16 __user *)p);
>         *val = vringh16_to_cpu(vrh, (__force __virtio16)v);
>         return rc;
> 
> That way the accessors still warn if anyone else tries this

Hmm I don't understand, sorry. Tries what?
Can you please show me an invalid use of get_user that
produces a warning currently but won't with my patch?

> but your
> warning is gone and the code basically says you knew the u16 was really
> an endianness specific virtio quantity?
> 
> James
> 


(__force __virtio16 __user *)
tells get_user exactly that pointer is to type __virtio16.
It does not get any more explicit.

What you are proposing is really discarding type
information by a bunch of __force calls.

I am very reluctant to do this.
In fact, because of the static checking I added,
conversion to virtio 1.0 went so smoothly:
most drivers worked right away after the conversion.
I'm very sure without static checking, or with
__force thrown around liberally, I would have



vringh specifically has one __force cast anyway because
it's mixing userspace and kernel pointers.

But, I also have an out of tree patch that use structures
like this:

	struct foo {
		__virtio16 bar;
	};


Now with my patches I can do:

       __virtio16 v = 0;
	struct foo __user *p;
       int rc = get_user(v, &p->bar);


-- 
MST
