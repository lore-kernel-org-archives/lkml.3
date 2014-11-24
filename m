Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaKXMPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:15:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbaKXMPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:15:31 -0500
Date: Mon, 24 Nov 2014 14:15:03 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, Nicholas Bellinger <nab@linux-iscsi.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        Anup Patel <anup.patel@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
        stephen hemminger <stephen@networkplumber.org>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3 04/41] virtio: memory access APIs
Message-ID: <20141124121503.GB14353@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
 <1416829787-14252-5-git-send-email-mst@redhat.com>
 <CAMuHMdWiCqbaOs-oBW3QU+_d3GsH19A2Ynv9EB_eF2sTvcWy4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWiCqbaOs-oBW3QU+_d3GsH19A2Ynv9EB_eF2sTvcWy4w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 01:03:24PM +0100, Geert Uytterhoeven wrote:
> On Mon, Nov 24, 2014 at 12:52 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > virtio 1.0 makes all memory structures LE, so
> > we need APIs to conditionally do a byteswap on BE
> > architectures.
> >
> > To make it easier to check code statically,
> > add virtio specific types for multi-byte integers
> > in memory.
> >
> > Add low level wrappers that do a byteswap conditionally, these will be
> > useful e.g. for vhost.  Add high level wrappers that
> > query device endian-ness and act accordingly.
> 
> > diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
> > new file mode 100644
> > index 0000000..824ed0b
> > --- /dev/null
> > +++ b/include/linux/virtio_byteorder.h
> 
> > +static inline u16 __virtio16_to_cpu(bool little_endian, __virtio16 val)
> > +{
> > +       if (little_endian)
> > +               return le16_to_cpu((__force __le16)val);
> > +       else
> > +               return (__force u16)val;
> > +}
> 
> What's wrong with just using le16-to_cpu() ...

le16-to_cpu() is simply wrong: virtio needs to be
LE or native endian, depending on whether it's running
in 0.9 or 1.0 mode.

> > --- a/include/uapi/linux/virtio_ring.h
> > +++ b/include/uapi/linux/virtio_ring.h
> 
> >  /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
> >  struct vring_desc {
> >         /* Address (guest-physical). */
> > -       __u64 addr;
> > +       __virtio64 addr;
> 
> ... and __le64?
> 
> There's already lots of precedence or this, even in include/uapi/.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert

__le would make people think they can use le16-to_cpu() which is wrong.

-- 
MST
