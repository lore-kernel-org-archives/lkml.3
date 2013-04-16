Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3DPMpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:45:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab3DPMpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:45:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH/RFC 3/6] DMA: shdma: add DT support
Date: Tue, 16 Apr 2013 14:45:14 +0200
Message-ID: <24397789.N1LYZfBEh2@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1304152328320.32574@axis700.grange>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de> <201304152318.42913.arnd@arndb.de> <Pine.LNX.4.64.1304152328320.32574@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Zyx+cVjnyYlosXXWjh1anqNACUY73dbrAYfbznUeDu2
 G/ve81nCK9iQ0swqVpwBywASq4lz7fhXweLgp+B4E96vQQXLAG
 PY/N1mQlSK2ZKS6vwVOe2amyor3YWcJnQDQtHXgY9UQRikMYxe
 2VwjQ4bqzbWagY9Qvj0mJ2vvCyFd6l2wul4XO+IjcegnIV5OBj
 t+l1FIyJwhx2r02PseVlMWa+ercHybRCvASyp3smQbnQwb1RYX
 BDD677gZU9hKT8c1E/ZmENOHGYZENGy2M5Z9oBNf/f0vJlUb7k
 fKCKbz0uXGQJ25W8qZNp0ATrNdhHavE41jvGsrlZ7SUjjbb12l
 n8HuCQtlPECNRaHI/4jM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 April 2013 23:34:57 Guennadi Liakhovetski wrote:
> 
> > 
> > This patch is missing the DT binding document, which is necessary for a proper
> > review, and as a documentation for anyone trying to write device tree source
> > files.
> 
> The documentation was left off consciously, because this driver isn't 
> using any non-standard DMA DT bindings, only those, already described in 
> Documentation/devicetree/bindings/dma/dma.txt.
>
> > In particular, it is not clear what mid/rid refer to here and whether they should
> > be represented as one or two cells. The driver here uses one cell, which is probably
> > ok, but I'd like to understand that anyway.
> 
> Yes, mid/rid is a kind of a DMA request line number on these controllers, 
> IIUC. It does have some internal hardware meaning, so, it's not a plane 
> index, but for a high-level view it's just an 8-bit DMA request ID.

Ok, this needs to be in the binding then.

You have to at least describe the meaning of the dma descriptor, because
the generic binding only defines that the descriptor contains a phandle of the
dma engine device, followed by a hardware specific number of cells to identify
a channel. The description of the device itself should mention the valid
strings for the "compatible" property and the required value of #dma-cells (<1>).

> > > > + * NOTE 2: This filter function is also used in the DT case by shdma_xlate().
> > > > + * In that case the MID-RID value is used for slave channel filtering and is
> > > > + * passed to this function in the "arg" parameter.
> > > >   */
> > > >  bool shdma_chan_filter(struct dma_chan *chan, void *arg)
> > > >  {
> > > >   struct shdma_chan *schan = to_shdma_chan(chan);
> > > >   struct shdma_dev *sdev = to_shdma_dev(schan->dma_chan.device);
> > > >   const struct shdma_ops *ops = sdev->ops;
> > > > - int slave_id = (int)arg;
> > > > + int match = (int)arg;
> > > >   int ret;
> > > >  
> > > > - if (slave_id < 0)
> > > > + if (match < 0)
> > > >           /* No slave requested - arbitrary channel */
> > > >           return true;
> > > >  
> > > > - if (slave_id >= slave_num)
> > > > + if (!schan->dev->of_node && match >= slave_num)
> > > >           return false;
> > > >  
> > > > - ret = ops->set_slave(schan, slave_id, true);
> > > > + ret = ops->set_slave(schan, match, true);
> > > >   if (ret < 0)
> > > >           return false;
> > 
> > The filter function should really ensure that the dma_chan.device matches
> > the device passed as the argument before accessing any members of
> > the outer structures. This seems to be a preexisting bug.
> 
> Also this I wouldn't necessarily call a bug, but a pre-existing and known 
> limitation  So far no platform, using such DMA controllers, has DMA 
> controllers, driven by different dmaengine drivers, so, no confusion is 
> possible, since those request line IDs are unique across SoCs. If in the 
> future need arises, this limitation can certainly be lifted.

I think it's a bit dangerous to rely on this. There are PCI add-on cards
with general-purpose DMA engines on them, so all it takes to make this
a real bug is a system with a PCI slot.

	Arnd
