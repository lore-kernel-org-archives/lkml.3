Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab3HTJEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:04:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:51944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3HTJEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:04:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,918,1367996400"; 
   d="scan'208";a="383559055"
Date: Tue, 20 Aug 2013 13:50:49 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: kgene.kim@samsung.com, Dan Williams <djbw@fb.com>,
        linus.walleij@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/4] dmaengine: add driver for Samsung s3c24xx SoCs
Message-ID: <20130820082049.GD5810@intel.com>
References: <201308141359.13872.heiko@sntech.de>
 <201308141400.25681.heiko@sntech.de>
 <20130819044811.GR32147@intel.com>
 <201308201023.50594.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201308201023.50594.heiko@sntech.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:23:49AM +0200, Heiko Stübner wrote:
> Hi Vinod,
> 
> Am Montag, 19. August 2013, 06:48:12 schrieb Vinod Koul:
> > On Wed, Aug 14, 2013 at 02:00:25PM +0200, Heiko Stübner wrote:
> > > This adds a new driver to support the s3c24xx dma using the dmaengine
> > > and makes the old one in mach-s3c24xx obsolete in the long run.
> > > 
> > > Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> > > with numerous virtual channels being mapped to a lot less physical ones.
> > > The driver therefore borrows a lot from the amba-pl08x driver in this
> > > regard. Functionality-wise the driver gains a memcpy ability in addition
> > > to the slave_sg one.
> > 
> > If that is the case why cant we have this driver supported from pl08x
> > driver? If the delta is only mapping then can that be seprated or both
> > mapping hanlded? Maybe you and Linus have already though about that?
> 
> Yes we have ... As Tomasz has already written the hardware itself is very much 
> different. It's only the concept of mapping virtual channels to physical 
> channels that is somehow similar.
> 
> It seems my patch message is lacking in making this clearer ;-) .
The above made me believ they are similar contrlllers with differnt mapping!,
hence the question...

> > > +#define DMASKTRIG_STOP		(1 << 2)
> > > +#define DMASKTRIG_ON		(1 << 1)
> > > +#define DMASKTRIG_SWTRIG	(1 << 0)
> > > +
> > > +#define DMAREQSEL		(0x24)
> > > +#define DMAREQSEL_HW		(1 << 0)
> > 
> > This is proper namespacing...
> 
> Hmm, I don't understand meaning of this sentence. Is it a suggestion to change 
> anything?
Sorry above should be read as "this need proper namespacing". The macros like
DMAREQSEL asre farliy egneric and can collide with others. SO the recommendation
is to use something like S3_DMAREQSEL etc

> > > +static irqreturn_t s3c24xx_dma_irq(int irq, void *data)
> > > +{
> > > +	struct s3c24xx_dma_phy *phy = data;
> > > +	struct s3c24xx_dma_chan *s3cchan = phy->serving;
> > > +	struct s3c24xx_txd *txd;
> > > +
> > > +	dev_dbg(&phy->host->pdev->dev, "interrupt on channel %d\n", phy->id);
> > > +
> > > +	if (!s3cchan) {
> > > +		dev_err(&phy->host->pdev->dev, "interrupt on unused channel 
> %d\n",
> > > +			phy->id);
> > > +		return IRQ_NONE;
> > 
> > hmmm, these channles belong to you. So if one of them is behvaing badly,
> > then not handling the interrupt will make things worse...
> 
> hmm ... I'm not sure what a valid handling would be for this.
> 
> The interrupt is only asserted when a transfer is completed - there are no 
> other interrupt-triggers. But when phy->serving is NULL, this also means that 
> the clock of the channel is disabled at this time. So this _should_ never 
> happen.
if that is the case we dont need above, but you added that just for the small
iota of if

> And as written above, the interrupt is only triggered when a transfer was 
> completed and the channel is idle again, so if there is no virtual channel 
> being served, there is nothing else to do.
But if we do get such an interrupt, it means:
a) bug in SW
b) erratic hw behaviour

if you handle and dump the issue at least you have recovered. Rather than
returning and controller asserting interrupt again and again as it is not
cleared.

~Vinod
