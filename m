Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab3CTI3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:29:39 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:39860 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab3CTI3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:29:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839h944hd25hd2bhf0ah107ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14afh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Wed, 20 Mar 2013 17:29:31 -0400
From: Anson Huang <b20788@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/3] ARM: imx: enable periphery well bias for suspend
Message-ID: <20130320212931.GB13929@ubuntu>
References: <1363801180-8284-1-git-send-email-b20788@freescale.com>
 <1363801180-8284-2-git-send-email-b20788@freescale.com>
 <20130320074905.GD26941@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130320074905.GD26941@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:49:08PM +0800, Shawn Guo wrote:
> Forgot mentioning in patch #1, for patches touching arch/arm/, it's
> good enough to send them to linux-arm-kernel list.  Copying list
> linux-kernel isn't so necessary.
Accepted, will pay attention to it.
> 
> On Wed, Mar 20, 2013 at 01:39:39PM -0400, Anson Huang wrote:
> > enable periphery charge pump for well biasing
> > at suspend to reduce periphery leakage.
> > 
> > Signed-off-by: Anson Huang <b20788@freescale.com>
> > ---
> >  arch/arm/mach-imx/clk-imx6q.c |   22 +++++++++++++++++++++-
> >  arch/arm/mach-imx/common.h    |    4 ++--
> >  arch/arm/mach-imx/pm-imx6q.c  |    4 +++-
> >  3 files changed, 26 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
> > index 2f9ff93..b365efc 100644
> > --- a/arch/arm/mach-imx/clk-imx6q.c
> > +++ b/arch/arm/mach-imx/clk-imx6q.c
> > @@ -1,5 +1,5 @@
> >  /*
> > - * Copyright 2011 Freescale Semiconductor, Inc.
> > + * Copyright 2011-2013 Freescale Semiconductor, Inc.
> >   * Copyright 2011 Linaro Ltd.
> >   *
> >   * The code contained herein is licensed under the GNU General Public
> > @@ -23,6 +23,9 @@
> >  #include "clk.h"
> >  #include "common.h"
> >  
> > +#define CCR				0x0
> > +#define BM_CCR_WB_COUNT			(0x7 << 16)
> > +
> >  #define CCGR0				0x68
> >  #define CCGR1				0x6c
> >  #define CCGR2				0x70
> > @@ -67,6 +70,23 @@ void imx6q_set_chicken_bit(void)
> >  	writel_relaxed(val, ccm_base + CGPR);
> >  }
> >  
> > +void imx6q_set_wb(bool enable)
> > +{
> > +	u32 val;
> > +
> > +	/* configurate well bias enable bit */
> 
> s/configurate/configure
Accepted.
> 
> > +	val = readl_relaxed(ccm_base + CLPCR);
> > +	val &= ~BM_CLPCR_WB_PER_AT_LPM;
> > +	val |= enable ? BM_CLPCR_WB_PER_AT_LPM : 0;
> > +	writel_relaxed(val, ccm_base + CLPCR);
> > +
> > +	/* configurate well bias count */
> 
> Ditto
Accepted.
> 
> > +	val = readl_relaxed(ccm_base + CCR);
> > +	val &= ~BM_CCR_WB_COUNT;
> > +	val |= enable ? BM_CCR_WB_COUNT : 0;
> > +	writel_relaxed(val, ccm_base + CCR);
> > +}
> > +
> >  int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
> >  {
> >  	u32 val = readl_relaxed(ccm_base + CLPCR);
> > diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
> > index 004c2b3..b9125cf 100644
> > --- a/arch/arm/mach-imx/common.h
> > +++ b/arch/arm/mach-imx/common.h
> > @@ -1,5 +1,5 @@
> >  /*
> > - * Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
> > + * Copyright 2004-2013 Freescale Semiconductor, Inc. All Rights Reserved.
> >   */
> >  
> >  /*
> > @@ -134,7 +134,7 @@ extern void imx_anatop_pre_suspend(void);
> >  extern void imx_anatop_post_resume(void);
> >  extern int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode);
> >  extern void imx6q_set_chicken_bit(void);
> > -
> 
> Unnecessary new line.
Accepted.
> 
> > +extern void imx6q_set_wb(bool enable);
> >  extern void imx_cpu_die(unsigned int cpu);
> >  extern int imx_cpu_kill(unsigned int cpu);
> >  
> > diff --git a/arch/arm/mach-imx/pm-imx6q.c b/arch/arm/mach-imx/pm-imx6q.c
> > index 05b26cd..57ca274 100644
> > --- a/arch/arm/mach-imx/pm-imx6q.c
> > +++ b/arch/arm/mach-imx/pm-imx6q.c
> > @@ -1,5 +1,5 @@
> >  /*
> > - * Copyright 2011 Freescale Semiconductor, Inc.
> > + * Copyright 2011-2013 Freescale Semiconductor, Inc.
> >   * Copyright 2011 Linaro Ltd.
> >   *
> >   * The code contained herein is licensed under the GNU General Public
> > @@ -36,8 +36,10 @@ static int imx6q_pm_enter(suspend_state_t state)
> >  		imx_gpc_pre_suspend();
> >  		imx_anatop_pre_suspend();
> >  		imx_set_cpu_jump(0, v7_cpu_resume);
> > +		imx6q_set_wb(true);
> 
> Is it possible to have it called inside imx6q_set_lpm()?  If so, we can
> 
> 1) Have imx6q_set_wb() be a static function in clk-imx6q.c
> 2) Apply the function for both STOP and WAIT mode
Good idea, will move it to imx6q_set_lpm(), but for now, I will only enable
this well bias for stop mode, if we need to enable it in wait mode, will
create another patch, as we are not so confident whether it can be applied
in WAIT mode, many modules are still working in WAIT mode.
> 
> Shawn
> 
> >  		/* Zzz ... */
> >  		cpu_suspend(0, imx6q_suspend_finish);
> > +		imx6q_set_wb(false);
> >  		imx_smp_prepare();
> >  		imx_anatop_post_resume();
> >  		imx_gpc_post_resume();
> > -- 
> > 1.7.9.5
> > 
> > 

