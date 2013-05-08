Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3EHPUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:20:36 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:51877 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab3EHPUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:20:30 -0400
Date: Wed, 8 May 2013 16:20:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 20/63] dmaengine: ste_dma40: Remove unnecessary call to
 d40_phy_cfg()
Message-ID: <20130508152025.GL3459@gmail.com>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-21-git-send-email-lee.jones@linaro.org>
 <CACRpkdbx_-wcatRaUpRw5LJY6qsoqDc3iqwk+UVmoBWR1M35KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbx_-wcatRaUpRw5LJY6qsoqDc3iqwk+UVmoBWR1M35KQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Linus Walleij wrote:

> On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > All configuration left in d40_phy_cfg() is runtime configurable and
> > there is already a call into it from d40_runtime_config(), so let's
> > rely on that.
> >
> > Acked-by: Vinod Koul <vnod.koul@intel.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> (...)
> 
> > @@ -2027,6 +2027,14 @@ static int d40_config_memcpy(struct d40_chan *d40c)
> >         } else if (dma_has_cap(DMA_MEMCPY, cap) &&
> >                    dma_has_cap(DMA_SLAVE, cap)) {
> >                 d40c->dma_cfg = dma40_memcpy_conf_phy;
> > +
> > +               /* Generate interrrupt at end of transfer or relink. */
> > +               d40c->dst_def_cfg |= BIT(D40_SREG_CFG_TIM_POS);
> > +
> > +               /* Generate interrupt on error. */
> > +               d40c->src_def_cfg |= BIT(D40_SREG_CFG_EIM_POS);
> > +               d40c->dst_def_cfg |= BIT(D40_SREG_CFG_EIM_POS);
> > +
> 
> This hunk looks like it's fixing a bug introduced in patch 19/63.

What makes you say that?

This patch is removing the d40_phy_cfg() invocation from the channel
allocation code, as all slaves now call dmaengine_slave_config(),
where this should happen. The ramification is that memcpy channels
won't be configured correctly, as they do not call the runtime
configuration code. Hence this hunk. It's taking the only important
bit which is relevant for physical memcpy channels and placing it
here instead. It has nothing to do with a bugfix from patch 19.

> Do you try to run a memcpy test after patch 19?

Yes, it works fine.

> Breaking the drive in one patch and fixing it in the next is
> a no-no because of bisection.

We're not doing that.

> Maybe things work fine if you just move this hunk of the
> patch over to 19/63?

That makes no sense.

> Apart from this the patch looks fine.
> 
> Yours,
> Linus Walleij

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
