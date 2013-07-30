Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab3G3JWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:22:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab3G3JWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:22:41 -0400
Date: Tue, 30 Jul 2013 11:22:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Simon Horman <horms@verge.net.au>
cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Olof Johansson <olof@lixom.net>, Linux-SH <linux-sh@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH resend] shdma: fixup sh_dmae_get_partial() calculation
 error
In-Reply-To: <20130730084957.GA17209@verge.net.au>
Message-ID: <Pine.LNX.4.64.1307301114020.25629@axis700.grange>
References: <1373422152-29976-1-git-send-email-horms+renesas@verge.net.au>
 <20130716012041.GA942@verge.net.au> <20130723023907.GC14983@quad.lixom.net>
 <20130723041220.GA22253@verge.net.au> <87zjtddgtg.wl%kuninori.morimoto.gx@renesas.com>
 <20130724034009.GA18355@verge.net.au> <87d2q8v6fs.wl%kuninori.morimoto.gx@renesas.com>
 <87bo5sv63u.wl%kuninori.morimoto.gx@renesas.com> <20130730084957.GA17209@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:QOMzdSaeIdSH9RfHAYaAU2xYel37l9lhwrVhlPYjyQU
 4vr+Ov6W2BCOFDTzZ3GBBH4cspUle14RPILL/ZW0uS7B+mJix7
 7Syn+Dx+XLGJgl4XktJabmLpxNqWfsMBJN7dAJOBpkze/bgzwS
 NRcPgOjkfTCbUGsJQpehDLe7FLHVa09+25qvo9ez0DZ9w5IWAC
 n6fvkI1hDry2aSh+K5MbKqV40zEChKPlFeJp1v3nGtB/j8jkpK
 ykGr0WX4uoNxdP8n/vruB7vXol6KFeUoFaNUCOGFHibsV2IHt8
 TMvdchLpbliQ4w7dI5LGzTD4YvaNpnnrhhJXUW5kExfysxhBDv
 cEscFC82TGlKaqaLqx1hbEAut7k0rPddH77VB1tZISD5wh4C0y
 4zhCm2+wwnMZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon

On Tue, 30 Jul 2013, Simon Horman wrote:

> [ Cc Vinod ]
> 
> On Tue, Jul 23, 2013 at 11:12:41PM -0700, Kuninori Morimoto wrote:
> > sh_desc->hw.tcr is controlling real data size,
> > and, register TCR is controlling data transfer count
> > which was xmit_shifted value of hw.tcr.
> > Current sh_dmae_get_partial() is calculating in different unit.
> > This patch fixes it.
> > 
> > Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Can I confirm that this was a regression introduced by
> 4f46f8ac80416b0e8fd3aba6a0d842205fb29140                   
> ("dmaengine: shdma: restore partial transfer calculation") ?

No, don't think so. That patch only restores what was accidentally deleted 
from the driver before. So, you cannot say, that before that patch the 
calculation was correct. And even the way it restores it was already wrong 
before. The error goes back to the original implementation:

commit c014906a870ce70e009def0c9d170ccabeb0be63
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Thu Feb 18 16:30:02 2010 +0000

    dmaengine: shdma: extend .device_terminate_all() to record partial transfer

Thanks
Guennadi

> 
> > ---
> > >> Guennadi
> > 
> > Could you please check this patch, and give it your Acked-by ?
> > 
> >  drivers/dma/sh/shdma.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
> > index b70709b..d670b8b 100644
> > --- a/drivers/dma/sh/shdma.c
> > +++ b/drivers/dma/sh/shdma.c
> > @@ -388,8 +388,8 @@ static size_t sh_dmae_get_partial(struct shdma_chan *schan,
> >  						    shdma_chan);
> >  	struct sh_dmae_desc *sh_desc = container_of(sdesc,
> >  					struct sh_dmae_desc, shdma_desc);
> > -	return (sh_desc->hw.tcr - sh_dmae_readl(sh_chan, TCR)) <<
> > -		sh_chan->xmit_shift;
> > +	return sh_desc->hw.tcr -
> > +		(sh_dmae_readl(sh_chan, TCR) << sh_chan->xmit_shift);
> >  }
> >  
> >  /* Called from error IRQ or NMI */
> > -- 
> > 1.7.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
