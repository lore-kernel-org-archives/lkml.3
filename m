Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3GBXNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:13:23 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:51362
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312Ab3GBXNW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:13:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
Date: Tue, 2 Jul 2013 18:13:06 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 2/2] DMA: Freescale: update driver to support 8-channel
 DMA engine
To: <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <vakul@freescale.com>,
        <leoLi@freescale.com>, <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <1372650378-2936-2-git-send-email-hongbo.zhang@freescale.com>
	(from hongbo.zhang@freescale.com on Sun Jun 30 22:46:18 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1372806786.8183.127@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2013 10:46:18 PM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> This patch adds support to 8-channel DMA engine, thus the driver  
> works for both
> the new 8-channel and the legacy 4-channel DMA engines.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  drivers/dma/fsldma.c |   48  
> ++++++++++++++++++++++++++++++++++--------------
>  drivers/dma/fsldma.h |    4 ++--
>  2 files changed, 36 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 4fc2980..0f453ea 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -1119,27 +1119,33 @@ static irqreturn_t fsldma_ctrl_irq(int irq,  
> void *data)
>  	struct fsldma_device *fdev = data;
>  	struct fsldma_chan *chan;
>  	unsigned int handled = 0;
> -	u32 gsr, mask;
> +	u8 chan_sr[round_up(FSL_DMA_MAX_CHANS_PER_DEVICE, 4)];
> +	u32 gsr;
>  	int i;
> 
> -	gsr = (fdev->feature & FSL_DMA_BIG_ENDIAN) ? in_be32(fdev->regs)
> -						   :  
> in_le32(fdev->regs);
> -	mask = 0xff000000;
> -	dev_dbg(fdev->dev, "IRQ: gsr 0x%.8x\n", gsr);
> +	memset(&chan_sr, 0, sizeof(chan_sr));
> +	gsr = (fdev->feature & FSL_DMA_BIG_ENDIAN) ?  
> in_be32(fdev->regs0)
> +						   :  
> in_le32(fdev->regs0);
> +	memcpy(&chan_sr[0], &gsr, 4);
> +	dev_dbg(fdev->dev, "IRQ: gsr0 0x%.8x\n", gsr);
> +
> +	if (of_device_is_compatible(fdev->dev->of_node,  
> "fsl,eloplus-dma2")) {

NACK; Figure out what sort of device you've got when you first probe  
the device, and store the information for later.  Do not call device  
tree stuff in an interrupt handler.

> +		gsr = (fdev->feature & FSL_DMA_BIG_ENDIAN) ?
> +			in_be32(fdev->regs1) : in_le32(fdev->regs1);
> +		memcpy(&chan_sr[4], &gsr, 4);
> +		dev_dbg(fdev->dev, "IRQ: gsr1 0x%.8x\n", gsr);
> +	}

Do these memcpy()s get inlined?  If not (and maybe even if they do),  
it'd be better to use a union instead.

Wait a second -- how are we even getting into this code on these new  
DMA controllers?  All 85xx-family DMA controllers use fsldma_chan_irq  
directly.

> @@ -1341,13 +1349,22 @@ static int fsldma_of_probe(struct  
> platform_device *op)
>  	INIT_LIST_HEAD(&fdev->common.channels);
> 
>  	/* ioremap the registers for use */
> -	fdev->regs = of_iomap(op->dev.of_node, 0);
> -	if (!fdev->regs) {
> -		dev_err(&op->dev, "unable to ioremap registers\n");
> +	fdev->regs0 = of_iomap(op->dev.of_node, 0);
> +	if (!fdev->regs0) {
> +		dev_err(&op->dev, "unable to ioremap register0\n");
>  		err = -ENOMEM;
>  		goto out_free_fdev;
>  	}
> 
> +	if (of_device_is_compatible(op->dev.of_node,  
> "fsl,eloplus-dma2")) {

Not "fsl,eloplusplus-dma"? :-)

More seriously, if we're sticking with this "elo" naming, maybe  
"fsl,elo3-dma" would be better.  It would be odd to have "2" in the  
name of the third generation of this hardware.

> diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
> index f5c3879..880664d 100644
> --- a/drivers/dma/fsldma.h
> +++ b/drivers/dma/fsldma.h
> @@ -112,10 +112,10 @@ struct fsldma_chan_regs {
>  };
> 
>  struct fsldma_chan;
> -#define FSL_DMA_MAX_CHANS_PER_DEVICE 4
> +#define FSL_DMA_MAX_CHANS_PER_DEVICE 8
> 
>  struct fsldma_device {
> -	void __iomem *regs;	/* DGSR register base */
> +	void __iomem *regs0, *regs1;	/* DGSR registers */

Either give these meaningful names, or use an array.  Or both (dgsr[2]).

Or just get rid of this, since I don't see why we need DGSR1 at all, as  
previously noted.

-Scott
