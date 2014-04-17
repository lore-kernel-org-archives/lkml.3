Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaDQXBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:01:37 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:34303 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaDQXBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:01:32 -0400
Message-ID: <53505D3F.9000108@mm-sol.com>
Date: Fri, 18 Apr 2014 02:01:19 +0300
From: Stanimir Vabanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>
CC: devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/2] dmaengine: qcom_bam_dma: Add v1.3.0 driver support
References: <1397684719-30065-1-git-send-email-agross@codeaurora.org> <1397684719-30065-2-git-send-email-agross@codeaurora.org>
In-Reply-To: <1397684719-30065-2-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Thanks for the patch!

On 04/17/2014 12:45 AM, Andy Gross wrote:
> This patch adds support for the v1.3.0 version of the BAM dma ip block.  This
> patch adds register access abstraction to deal with the changes to the register
> map between the two versions.  Blocks of registers moved around within the
> address space, and multipliers used for calculating the pipe registers changed
> as well.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  drivers/dma/qcom_bam_dma.c |  177 ++++++++++++++++++++++++++++----------------
>  1 file changed, 114 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
> index 82c9231..02f7fef 100644
> --- a/drivers/dma/qcom_bam_dma.c
> +++ b/drivers/dma/qcom_bam_dma.c
> @@ -74,35 +74,49 @@ struct bam_async_desc {
>  	struct bam_desc_hw desc[0];
>  };
>  
> -#define BAM_CTRL			0x0000
> -#define BAM_REVISION			0x0004
> -#define BAM_SW_REVISION			0x0080
> -#define BAM_NUM_PIPES			0x003C
> -#define BAM_TIMER			0x0040
> -#define BAM_TIMER_CTRL			0x0044
> -#define BAM_DESC_CNT_TRSHLD		0x0008
> -#define BAM_IRQ_SRCS			0x000C
> -#define BAM_IRQ_SRCS_MSK		0x0010
> -#define BAM_IRQ_SRCS_UNMASKED		0x0030
> -#define BAM_IRQ_STTS			0x0014
> -#define BAM_IRQ_CLR			0x0018
> -#define BAM_IRQ_EN			0x001C
> -#define BAM_CNFG_BITS			0x007C
> -#define BAM_IRQ_SRCS_EE(ee)		(0x0800 + ((ee) * 0x80))
> -#define BAM_IRQ_SRCS_MSK_EE(ee)		(0x0804 + ((ee) * 0x80))
> -#define BAM_P_CTRL(pipe)		(0x1000 + ((pipe) * 0x1000))
> -#define BAM_P_RST(pipe)			(0x1004 + ((pipe) * 0x1000))
> -#define BAM_P_HALT(pipe)		(0x1008 + ((pipe) * 0x1000))
> -#define BAM_P_IRQ_STTS(pipe)		(0x1010 + ((pipe) * 0x1000))
> -#define BAM_P_IRQ_CLR(pipe)		(0x1014 + ((pipe) * 0x1000))
> -#define BAM_P_IRQ_EN(pipe)		(0x1018 + ((pipe) * 0x1000))
> -#define BAM_P_EVNT_DEST_ADDR(pipe)	(0x182C + ((pipe) * 0x1000))
> -#define BAM_P_EVNT_REG(pipe)		(0x1818 + ((pipe) * 0x1000))
> -#define BAM_P_SW_OFSTS(pipe)		(0x1800 + ((pipe) * 0x1000))
> -#define BAM_P_DATA_FIFO_ADDR(pipe)	(0x1824 + ((pipe) * 0x1000))
> -#define BAM_P_DESC_FIFO_ADDR(pipe)	(0x181C + ((pipe) * 0x1000))
> -#define BAM_P_EVNT_TRSHLD(pipe)		(0x1828 + ((pipe) * 0x1000))
> -#define BAM_P_FIFO_SIZES(pipe)		(0x1820 + ((pipe) * 0x1000))
> +/* Register base offset and multplier values.  Use version of map as index */
> +static unsigned int ctrl_offs[] = { 0xf80, 0x0 };
> +static unsigned int pipe_offs[] = { 0x0, 0x1000 };
> +static unsigned int ee_offs[] = { 0x1800, 0x800 };
> +static unsigned int evnt_offs[] = { 0x1000, 0x1800 };
> +static unsigned int pipe_mult[] = { 0x80, 0x1000 };
> +static unsigned int evnt_mult[] = { 0x40, 0x1000 };
> +
> +/* relative offset from ctrl register base */
> +#define BAM_CTRL			0x00
> +#define BAM_REVISION			0x04
> +#define BAM_DESC_CNT_TRSHLD		0x08
> +#define BAM_IRQ_SRCS			0x0C
> +#define BAM_IRQ_SRCS_MSK		0x10
> +#define BAM_IRQ_STTS			0x14
> +#define BAM_IRQ_CLR			0x18
> +#define BAM_IRQ_EN			0x1C
> +#define BAM_IRQ_SRCS_UNMASKED		0x30
> +#define BAM_NUM_PIPES			0x3c
> +#define BAM_TIMER			0x40
> +#define BAM_TIMER_CTRL			0x44
> +#define BAM_CNFG_BITS			0x7c
> +
> +/* relative offset from irq register base */
> +#define BAM_IRQ_SRCS_EE			0x00
> +#define BAM_IRQ_SRCS_MSK_EE		0x04
> +
> +/* relative offset from pipe register base */
> +#define BAM_P_CTRL			0x00
> +#define BAM_P_RST			0x04
> +#define BAM_P_HALT			0x08
> +#define BAM_P_IRQ_STTS			0x10
> +#define BAM_P_IRQ_CLR			0x14
> +#define BAM_P_IRQ_EN			0x18
> +
> +/* relative offset from event register base */
> +#define BAM_P_SW_OFSTS			0x00
> +#define BAM_P_EVNT_REG			0x18
> +#define BAM_P_DESC_FIFO_ADDR		0x1C
> +#define BAM_P_FIFO_SIZES		0x20
> +#define BAM_P_DATA_FIFO_ADDR		0x24
> +#define BAM_P_EVNT_TRSHLD		0x28
> +#define BAM_P_EVNT_DEST_ADDR		0x2C
>  
>  /* BAM CTRL */
>  #define BAM_SW_RST			BIT(0)
> @@ -292,6 +306,8 @@ struct bam_device {
>  	/* execution environment ID, from DT */
>  	u32 ee;
>  
> +	u32 reg_ver;
> +
>  	struct clk *bamclk;
>  	int irq;
>  
> @@ -299,6 +315,36 @@ struct bam_device {
>  	struct tasklet_struct task;
>  };
>  
> +static inline void __iomem *ctrl_addr(struct bam_device *bdev, u32 reg)
> +{
> +	return bdev->regs + ctrl_offs[bdev->reg_ver] + reg;
> +}
> +
> +static inline void __iomem *ee_addr(struct bam_device *bdev, u32 reg)
> +{
> +	u32 offset = ee_offs[bdev->reg_ver] + reg + (bdev->ee * 0x80);
> +
> +	return bdev->regs + offset;
> +}
> +
> +static inline void __iomem *pipe_addr(struct bam_device *bdev, u32 pipe,
> +	u32 reg)
> +{
> +	u32 offset = pipe_offs[bdev->reg_ver] + reg;
> +
> +	offset += pipe_mult[bdev->reg_ver] * pipe;
> +	return bdev->regs + offset;
> +}
> +
> +static inline void __iomem *evnt_addr(struct bam_device *bdev, u32 pipe,
> +	u32 reg)
> +{
> +	u32 offset = evnt_offs[bdev->reg_ver] + reg;
> +
> +	offset += evnt_mult[bdev->reg_ver] * pipe;
> +	return bdev->regs + offset;
> +}
> +
>  /**
>   * bam_reset_channel - Reset individual BAM DMA channel
>   * @bchan: bam channel
> @@ -312,8 +358,8 @@ static void bam_reset_channel(struct bam_chan *bchan)
>  	lockdep_assert_held(&bchan->vc.lock);
>  
>  	/* reset channel */
> -	writel_relaxed(1, bdev->regs + BAM_P_RST(bchan->id));
> -	writel_relaxed(0, bdev->regs + BAM_P_RST(bchan->id));
> +	writel_relaxed(1, pipe_addr(bdev, bchan->id, BAM_P_RST));
> +	writel_relaxed(0, pipe_addr(bdev, bchan->id, BAM_P_RST));
>  

<snip>

>  
>  static const struct of_device_id bam_of_match[] = {
> +	{ .compatible = "qcom,bam-v1.3.0", },
>  	{ .compatible = "qcom,bam-v1.4.0", },

you could use the of_device_id::data field to switch between different
versions.

I mean this:

static const struct of_device_id bam_of_match[] = {
	{ .compatible = "qcom,bam-v1.3.0", .data = &reg_offs_v1_3 },
  	{ .compatible = "qcom,bam-v1.4.0", .data = &reg_offs_v1_4 },
}

and during .probe you will get the correct offsets per version. It then
could be assigned to a variable in bdev.

Then the defines could be:

#define BAM_CTRL(bdev)	(bdev->reg_offs->ctrl_offs + 0x00)

I'm not sure how many additional code this will be but it looks clearer.

regards,
Stan
