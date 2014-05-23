Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaEWG6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 02:58:52 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:33850 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaEWG6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 02:58:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140519100316.GE7138@ulmo>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
 <1400483458-9648-5-git-send-email-acourbot@nvidia.com> <20140519090202.GC7138@ulmo>
 <1400491331.8467.8.camel@weser.hi.pengutronix.de> <20140519100316.GE7138@ulmo>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 23 May 2014 15:58:30 +0900
Message-ID: <CAAVeFu+TaRahuv+7e90W5ZOH86jT4Nt3k0O24dZKX-DgQQqp5w@mail.gmail.com>
Subject: Re: [PATCH 4/4] drm/nouveau: introduce CPU cache flushing macro
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 7:03 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, May 19, 2014 at 11:22:11AM +0200, Lucas Stach wrote:
>> Am Montag, den 19.05.2014, 11:02 +0200 schrieb Thierry Reding:
>> > On Mon, May 19, 2014 at 04:10:58PM +0900, Alexandre Courbot wrote:
>> > > Some architectures (e.g. ARM) need the CPU buffers to be explicitely
>> > > flushed for a memory write to take effect. Not doing so results in
>> > > synchronization issues, especially after writing to BOs.
>> >
>> > It seems to me that the above is generally true for all architectures,
>> > not just ARM.
>> >
>> No, on PCI coherent arches, like x86 and some PowerPCs, the GPU will
>> snoop the CPU caches and therefore an explicit cache flush is not
>> required.
>
> I was criticizing the wording in the commit message. Perhaps it could be
> enhanced with what you just said.
>
>> > > diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
>> > [...]
>> > > index 0886f47e5244..b9c9729c5733 100644
>> > > --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
>> > > +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
>> > > @@ -437,8 +437,10 @@ nouveau_bo_wr16(struct nouveau_bo *nvbo, unsigned index, u16 val)
>> > >   mem = &mem[index];
>> > >   if (is_iomem)
>> > >           iowrite16_native(val, (void __force __iomem *)mem);
>> > > - else
>> > > + else {
>> > >           *mem = val;
>> > > +         nv_cpu_cache_flush_area(mem, 2);
>> > > + }
>> > >  }
>> > >
>> > >  u32
>> > > @@ -461,8 +463,10 @@ nouveau_bo_wr32(struct nouveau_bo *nvbo, unsigned index, u32 val)
>> > >   mem = &mem[index];
>> > >   if (is_iomem)
>> > >           iowrite32_native(val, (void __force __iomem *)mem);
>> > > - else
>> > > + else {
>> > >           *mem = val;
>> > > +         nv_cpu_cache_flush_area(mem, 4);
>> > > + }
>> >
>> > This looks rather like a sledgehammer to me. Effectively this turns nvbo
>> > into an uncached buffer. With additional overhead of constantly flushing
>> > caches. Wouldn't it make more sense to locate the places where these are
>> > called and flush the cache after all the writes have completed?
>> >
>> I don't think the explicit flushing for those things makes sense. I
>> think it is a lot more effective to just map the BOs write-combined on
>> PCI non-coherent arches. This way any writes will be buffered. Reads
>> will be slow, but I don't think nouveau is reading back a lot from those
>> buffers.
>> Using the write-combining buffer doesn't need any additional
>> synchronization as it will get flushed on pushbuf kickoff anyways.
>
> Sounds good to me.

I will need to wrap my head around TTM some more to understand how to
do this the right way, but it is true that brute-forcing in-memory BO
mappings to be WC make the addition of nv_cpu_cache_flush_area()
unneeded. Is that the direction we want to take with this?
