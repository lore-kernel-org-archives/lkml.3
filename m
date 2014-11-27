Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaK0X2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:28:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:59272 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaK0X2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:28:17 -0500
Date: Fri, 28 Nov 2014 00:28:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Xunlei Pang <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH 2/4] rtc: Convert rtc_class_ops.set_mmss() to use
 time64_t
In-Reply-To: <3958728.Cz3JcLN4Uc@wuerfel>
Message-ID: <alpine.DEB.2.11.1411280026120.3961@nanos>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org> <1417089760-26848-3-git-send-email-pang.xunlei@linaro.org> <alpine.DEB.2.11.1411280003020.3961@nanos> <3958728.Cz3JcLN4Uc@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014, Arnd Bergmann wrote:
> On Friday 28 November 2014 00:05:34 Thomas Gleixner wrote:
> > On Thu, 27 Nov 2014, Xunlei Pang wrote:
> > > -static int coh901331_set_mmss(struct device *dev, unsigned long secs)
> > > +static int coh901331_set_mmss(struct device *dev, time64_t secs)
> > >  {
> > >       struct coh901331_port *rtap = dev_get_drvdata(dev);
> > >  
> > >       clk_enable(rtap->clk);
> > > +     /*
> > > +      * y2106 issue:
> > > +      *   On 32bit systems the time64_t secs value gets cast to
> > > +      *   a 32bit long, and thus we can only write a maximum value
> > > +      *   of y2016
> > 
> > That really makes a lot of sense. Before that patch the driver was
> > safe up to 2038. Now it is facing the y2016 problem.
> 
> Actually the comment is still wrong with the number fixed, I hadn't
> noticed when I looked at the patch earlier:
> 
> The cast happens on both 32-bit and 64-bit, as we cast into a u32
> value through the writel(). The behavior of this driver doesn't
> even change with this patch, it was good until y2106 and stays
> that way because 'unsigned long', 'time64_t' and 'u32' can all represent
> at least times between 1970 and 2106, the change is just to document
> the time at which it will break, while changing the API.

Indeed. I did not bother to think about that as I was already in
grumpy mode due to the general aproach of creating the maximal churn
for no value.
 
Thanks,

	tglx
