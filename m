Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaL0QOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 11:14:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaL0QOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 11:14:33 -0500
Date: Sat, 27 Dec 2014 18:14:14 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH repost 12/16] parisc/uaccess: fix sparse errors
Message-ID: <20141227161414.GA2571@redhat.com>
References: <1419499661-8566-1-git-send-email-mst@redhat.com>
 <1419499661-8566-13-git-send-email-mst@redhat.com>
 <549C91B9.8080009@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549C91B9.8080009@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 11:37:45PM +0100, Helge Deller wrote:
> Hi Michael,
> 
> On 12/25/2014 10:29 AM, Michael S. Tsirkin wrote:
> >virtio wants to read bitwise types from userspace using get_user.  At the
> 
> I don't know the virtio code much yet, but does it makes sense to read bitwise types?
> Will virtio then get possible troubles because of endianess correct as well?

There's no conversion: we are reading from __virtio16 __user *
pointer into __virtio16 v value.

> Do you have a code example, or the sparse error message ?
> 
> Helge

Sure. the code is upstream now.
The warning is below.

sparse warnings: (new ones prefixed by >>)

>> drivers/vhost/vringh.c:554:18: sparse: cast to restricted __virtio16

vim +554 drivers/vhost/vringh.c

   538                                                           __virtio16 *p, u16 val))
   539  {
   540          if (!vrh->event_indices) {
   541                  /* Old-school; update flags. */
   542                  if (putu16(vrh, &vrh->vring.used->flags,
   543                             VRING_USED_F_NO_NOTIFY)) {
   544                          vringh_bad("Setting used flags %p",
   545                                     &vrh->vring.used->flags);
   546                  }
   547          }
   548  }
   549
   550  /* Userspace access helpers: in this case, addresses are really userspace. */
   551  static inline int getu16_user(const struct vringh *vrh, u16 *val, const __virtio16 *p)
   552  {
   553          __virtio16 v = 0;
 > 554          int rc = get_user(v, (__force __virtio16 __user *)p);
   555          *val = vringh16_to_cpu(vrh, v);
   556          return rc;
   557  }
   558
   559  static inline int putu16_user(const struct vringh *vrh, __virtio16 *p, u16 val)
   560  {
   561          __virtio16 v = cpu_to_vringh16(vrh, val);
   562          return put_user(v, (__force __virtio16 __user *)p);



> 
> >moment this triggers sparse errors, since the value is passed through an
> >integer.
> >
> >Fix that up using __force.
> >
> >Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >---
> >  arch/parisc/include/asm/uaccess.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/arch/parisc/include/asm/uaccess.h b/arch/parisc/include/asm/uaccess.h
> >index a5cb070..3a20da6 100644
> >--- a/arch/parisc/include/asm/uaccess.h
> >+++ b/arch/parisc/include/asm/uaccess.h
> >@@ -104,7 +104,7 @@ struct exception_data {
> >  	    }                                           \
> >  	}                                               \
> >  							\
> >-	(x) = (__typeof__(*(ptr))) __gu_val;            \
> >+	(x) = (__force __typeof__(*(ptr))) __gu_val;            \
> >  	__gu_err;                                       \
> >  })
> >
> >
