Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaKGIBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:01:16 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53774 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaKGIBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:01:13 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-1d-545c7c46955c
Message-id: <1415347269.8532.1.camel@AMDC1943>
Subject: Re: [PATCH v10 3/5] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 07 Nov 2014 09:01:09 +0100
In-reply-to: <3262760.d60MN56YDG@vostro.rjw.lan>
References: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
 <1415263010-7992-4-git-send-email-k.kozlowski@samsung.com>
 <3262760.d60MN56YDG@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xq7puNTEhBjuXmFhsnLGe1WL61AuM
	Fqun/mW1eLr5MZPF2aY37BZLJs9nteicuITdYtaUvUwWl3fNYbP43HuE0eL2ZV6LtUfuslu8
	exlhcffUUTaLM6cvsVpM+H2BzeL42nCLl337WRyEPFqae9g8ZnfMZPVYvOclk8emVZ1sHneu
	7WHzWPLmEKvHlqvtLB6z7/5g9OjbsorRY8Xq7+wenzfJeez9/JslgCeKyyYlNSezLLVI3y6B
	K2PShIdMBR/FKtas2cbSwPhPsIuRk0NCwERi9b8eZghbTOLCvfVsILaQwFJGieaO5C5GLiD7
	M6PEjaVLmUASvAJ6Eu0/5jOC2MICWRLPtp9jAbHZBIwlNi9fAtYsIqAtMbfnFDNIM7PAXFaJ
	S9N3gxWxCKhK3GhZBVbEKWAgcXzhRlaIDSsZJW6dawXbwCygLjFp3iKgbg6gk5QlGvvdIBYL
	SvyYfI8FokReYvOat8wTGAVmIemYhaRsFpKyBYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNz
	NzFCovLrDsalx6wOMQpwMCrx8D4QiQkRYk0sK67MPcQowcGsJMIrFQQU4k1JrKxKLcqPLyrN
	SS0+xMjEwSnVwMgotk1CRaNW9fmeVOvMi1+mPXp9ospr+rqJHxuPStUfSuQL2qXK4P1i+pno
	0NdLGVs4FS9kSvlpKrFs3OSkILJNuMl7wr8FTUvTa3PeZAQz9T8x1I+2YmC+/vX+u7kH2ZO3
	pcR4L1VSXXnpBqfsp9xrqasszu1aVpYf0S/sujklXuCGJKPsYiWW4oxEQy3mouJEAAhVXlOo	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-06 at 23:52 +0100, Rafael J. Wysocki wrote:
> On Thursday, November 06, 2014 09:36:48 AM Krzysztof Kozlowski wrote:
> > The AMBA bus driver defines runtime Power Management functions which
> > disable and unprepare AMBA bus clock. This is problematic for runtime PM
> > because unpreparing a clock might sleep so it is not interrupt safe.
> > 
> > However some drivers may want to implement runtime PM functions in
> > interrupt-safe way (see pm_runtime_irq_safe()). In such case the AMBA
> > bus driver should only disable/enable the clock in runtime suspend and
> > resume callbacks.
> > 
> > Detect the device driver behavior during runtime suspend. During runtime
> > resume deal with clocks according to stored value.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/amba/bus.c       | 17 +++++++++++++----
> >  include/linux/amba/bus.h |  1 +
> >  2 files changed, 14 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> > index 47bbdc1b5be3..356f906c6966 100644
> > --- a/drivers/amba/bus.c
> > +++ b/drivers/amba/bus.c
> > @@ -95,8 +95,14 @@ static int amba_pm_runtime_suspend(struct device *dev)
> >  	struct amba_device *pcdev = to_amba_device(dev);
> >  	int ret = pm_generic_runtime_suspend(dev);
> >  
> > -	if (ret == 0 && dev->driver)
> > -		clk_disable_unprepare(pcdev->pclk);
> > +	if (ret == 0 && dev->driver) {
> > +		pcdev->irq_safe = dev->power.irq_safe;
> > +
> > +		if (pcdev->irq_safe)
> > +			clk_disable(pcdev->pclk);
> > +		else
> > +			clk_disable_unprepare(pcdev->pclk);
> > +	}
> >  
> >  	return ret;
> >  }
> > @@ -107,7 +113,10 @@ static int amba_pm_runtime_resume(struct device *dev)
> >  	int ret;
> >  
> >  	if (dev->driver) {
> > -		ret = clk_prepare_enable(pcdev->pclk);
> > +		if (pcdev->irq_safe)
> > +			ret = clk_enable(pcdev->pclk);
> > +		else
> > +			ret = clk_prepare_enable(pcdev->pclk);
> >  		/* Failure is probably fatal to the system, but... */
> >  		if (ret)
> >  			return ret;
> > @@ -115,7 +124,7 @@ static int amba_pm_runtime_resume(struct device *dev)
> >  
> >  	return pm_generic_runtime_resume(dev);
> >  }
> > -#endif
> > +#endif /* CONFIG_PM */
> >  
> >  static const struct dev_pm_ops amba_pm = {
> >  	.suspend	= pm_generic_suspend,
> > diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> > index ac02f9bd63dc..c4bae79851fb 100644
> > --- a/include/linux/amba/bus.h
> > +++ b/include/linux/amba/bus.h
> > @@ -32,6 +32,7 @@ struct amba_device {
> >  	struct clk		*pclk;
> >  	unsigned int		periphid;
> >  	unsigned int		irq[AMBA_NR_IRQS];
> > +	unsigned int		irq_safe:1;
> 
> Why do we need the new flag?  Seems redundant to me.

Some poorly written driver could set irq_safe somewhere between suspend
and resume (e.g. in suspend callback).

Best regards,
Krzysztof


