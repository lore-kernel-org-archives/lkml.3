Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaJWJLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:11:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaJWJLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:11:51 -0400
Date: Thu, 23 Oct 2014 12:15:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
        Anup Patel <anup.patel@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux-foundation.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Piotr =?iso-8859-1?Q?Kr=F3l?= <piotr.krol@3mdeb.com>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH RFC v3 01/16] virtio: memory access APIs
Message-ID: <20141023091502.GA7028@redhat.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
 <1414003404-505-2-git-send-email-mst@redhat.com>
 <20141023095405.6bdd5a1a.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023095405.6bdd5a1a.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 09:54:05AM +0200, Cornelia Huck wrote:
> On Wed, 22 Oct 2014 21:44:08 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > virtio 1.0 makes all memory structures LE, so
> > we need APIs to conditionally do a byteswap on BE
> > architectures.
> > 
> > To make it easier to check code statically,
> > add virtio specific types for multi-byte integers
> > in memory.
> > 
> > Add low level wrappers that do a byteswap conditionally, these will be
> > useful e.g. for vhost.  Add high level wrappers that will (in the
> > future) query device endian-ness and act accordingly.
> > 
> > At the moment, stub them out and assume native endian-ness everywhere.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/virtio_byteorder.h | 29 ++++++++++++++++++++++++
> >  include/linux/virtio_config.h    | 16 +++++++++++++
> >  include/uapi/linux/virtio_ring.h | 49 ++++++++++++++++++++--------------------
> >  include/uapi/linux/Kbuild        |  1 +
> >  4 files changed, 71 insertions(+), 24 deletions(-)
> >  create mode 100644 include/linux/virtio_byteorder.h
> > 
> > diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
> > new file mode 100644
> > index 0000000..7afdd8a
> > --- /dev/null
> > +++ b/include/linux/virtio_byteorder.h
> > @@ -0,0 +1,29 @@
> > +#ifndef _LINUX_VIRTIO_BYTEORDER_H
> > +#define _LINUX_VIRTIO_BYTEORDER_H
> > +#include <linux/types.h>
> > +#include <uapi/linux/virtio_types.h>
> > +
> > +/* Memory accessors for handling virtio in modern little endian and in
> > + * compatibility big endian format. */
> 
> s/big/native/

Thanks.

> > +
> > +#define __DEFINE_VIRTIO_XX_TO_CPU(bits) \
> > +static inline u##bits __virtio##bits##_to_cpu(bool little_endian, __virtio##bits val) \
> > +{ \
> > +	if (little_endian) \
> > +		return le##bits##_to_cpu((__force __le##bits)val); \
> > +	else \
> > +		return (__force u##bits)val; \
> > +} \
> > +static inline __virtio##bits __cpu_to_virtio##bits(bool little_endian, u##bits val) \
> > +{ \
> > +	if (little_endian) \
> > +		return (__force __virtio##bits)cpu_to_le##bits(val); \
> > +	else \
> > +		return val; \
> > +}
> > +
> > +__DEFINE_VIRTIO_XX_TO_CPU(16)
> > +__DEFINE_VIRTIO_XX_TO_CPU(32)
> > +__DEFINE_VIRTIO_XX_TO_CPU(64)
> 
> ...although I'm still not too happy with macro-generated helpers.

I'm fine with open-coding them.

> > +
> > +#endif /* _LINUX_VIRTIO_BYTEORDER */
> 
> > diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
> > index a99f9b7..6c00632 100644
> > --- a/include/uapi/linux/virtio_ring.h
> > +++ b/include/uapi/linux/virtio_ring.h
> 
> > @@ -61,32 +62,32 @@
> >  /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
> >  struct vring_desc {
> >  	/* Address (guest-physical). */
> > -	__u64 addr;
> > +	__virtio64 addr;
> >  	/* Length. */
> > -	__u32 len;
> > +	__virtio32 len;
> >  	/* The flags as indicated above. */
> > -	__u16 flags;
> > +	__virtio16 flags;
> >  	/* We chain unused descriptors via this, too */
> > -	__u16 next;
> > +	__virtio16 next;
> >  };
> 
> I think all of these __virtio types need an explanation somewhere as to
> what they mean, e.g.:
> 
> /*
>  * __virtio{16,32,64} have the following meaning:
>  * - __u{16,32,64} for virtio devices in legacy mode,
>  *   accessed in native endian
>  * - __le{16,32,64} for standard-compliant virtio devices
>  */

Will do.

-- 
MST
