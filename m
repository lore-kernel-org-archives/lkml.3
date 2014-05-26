Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaEZHtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:49:22 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:41357 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaEZHtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:49:20 -0400
Date: Mon, 26 May 2014 09:49:23 +0200
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chris Ball <chris@printf.net>
Subject: Re: [PATCH RFC] mmc: add slot argument to mmc_of_parse
Message-ID: <20140526074923.GC12777@ldesroches-Latitude-E6320>
Mail-Followup-To: Jaehoon Chung <jh80.chung@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Chris Ball <chris@printf.net>
References: <1399457217-22846-1-git-send-email-ludovic.desroches@atmel.com>
 <CAPDyKFqeunnWmguTH89byNc5Yy+CBY4avMeeon3ZSfNMmGJa9Q@mail.gmail.com>
 <537ED0AE.7040901@samsung.com>
 <20140526070301.GA12777@ldesroches-Latitude-E6320>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140526070301.GA12777@ldesroches-Latitude-E6320>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 09:03:01AM +0200, Ludovic Desroches wrote:
> Hi,
> 
> Sorry I was on vacation, I'll send a cleaner patch updating other drivers
> this week.

Continuing to clear out my inbox, I have seen you send a patch for it.
Thanks. 

> 
> Regards
> 
> Ludovic
> 
> On Fri, May 23, 2014 at 01:38:06PM +0900, Jaehoon Chung wrote:
> > Hi, All.
> > 
> > This patch is working on progress?
> > I want to merge this patch for fixing dw-mmc controller problem.
> > 
> > If this patch didn't work on progress, i will send the patch based-on this patch.
> > 
> > Best Regards,
> > Jaehoon Chung
> > 
> > On 05/14/2014 06:53 PM, Ulf Hansson wrote:
> > > On 7 May 2014 12:06, Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
> > >> Some hosts manage several slots. In these case information such as the bus
> > >> width, chip detect and others are into the slot node. So we have to parse
> > >> child nodes. If not NULL, slot node will be used instead of the device
> > >> node.
> > >>
> > >> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> > >> ---
> > >>
> > >> Hi,
> > >>
> > >> Since this patch is only a RFC, I have not yet updated drivers using this
> > >> function.
> > >>
> > >> I would like to use mmc_of_parse to reduce code duplication. My issue is that
> > >> atmel mci is a bit different from others mci host since it can provide
> > >> several slots, so it allocates several mmc hosts. By the way, it is not the
> > >> only one.
> > >>
> > >> When calling mmc_alloc_host, host->parent is set to &pdev->dev. mmc_of_parse
> > >> uses host->parent->of_node but in my case settings are in the slot nodes so in
> > >> the child nodes. That's why I would like to have a way to tell which node I
> > >> want to use.
> > > 
> > > Seems reasonable, thanks for working on this!
> > > 
> > >>
> > >>
> > >> Regards
> > >>
> > >> Ludovic
> > >>
> > >>
> > >>
> > >>  drivers/mmc/core/host.c |    9 +++++++--
> > >>  1 file changed, 7 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> > >> index fdea825..ed6cea5 100644
> > >> --- a/drivers/mmc/core/host.c
> > >> +++ b/drivers/mmc/core/host.c
> > >> @@ -300,13 +300,15 @@ static inline void mmc_host_clk_sysfs_init(struct mmc_host *host)
> > >>  /**
> > >>   *     mmc_of_parse() - parse host's device-tree node
> > >>   *     @host: host whose node should be parsed.
> > >> + *     @slot: some devices provide several slots so the node to parse
> > >> + *     is not the host one.
> > >>   *
> > >>   * To keep the rest of the MMC subsystem unaware of whether DT has been
> > >>   * used to to instantiate and configure this host instance or not, we
> > >>   * parse the properties and set respective generic mmc-host flags and
> > >>   * parameters.
> > >>   */
> > >> -int mmc_of_parse(struct mmc_host *host)
> > >> +int mmc_of_parse(struct mmc_host *host, struct device_node *slot)
> > >>  {
> > >>         struct device_node *np;
> > >>         u32 bus_width;
> > >> @@ -317,7 +319,10 @@ int mmc_of_parse(struct mmc_host *host)
> > >>         if (!host->parent || !host->parent->of_node)
> > >>                 return 0;
> > >>
> > >> -       np = host->parent->of_node;
> > >> +       if (slot)
> > >> +               np = slot;
> > >> +       else
> > >> +               np = host->parent->of_node;
> > >>
> > >>         /* "bus-width" is translated to MMC_CAP_*_BIT_DATA flags */
> > >>         if (of_property_read_u32(np, "bus-width", &bus_width) < 0) {
> > >> --
> > >> 1.7.9.5
> > >>
> > > 
> > > How about adding a new API, __mmc_of_parse((struct mmc_host *host,
> > > struct device_node *slot)
> > > Then let the old API mmc_of_parse() remain as is, but let it call the
> > > new API with slot == NULL.
> > > 
> > > Atmel can then use the new API, but the other drivers can remain as is.
> > > 
> > > Kind regards
> > > Ulf Hansson
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
