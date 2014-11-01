Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbaKABBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 21:01:30 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51950 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757367AbaKABB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 21:01:29 -0400
Date: Sat, 1 Nov 2014 01:01:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v8 3/5] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
Message-ID: <20141101010113.GA3831@n2100.arm.linux.org.uk>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <1413795888-18559-4-git-send-email-k.kozlowski@samsung.com>
 <1479283.dvHduzBoyf@vostro.rjw.lan>
 <20141101005514.GY27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141101005514.GY27405@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 12:55:14AM +0000, Russell King - ARM Linux wrote:
> On Sat, Nov 01, 2014 at 01:45:47AM +0100, Rafael J. Wysocki wrote:
> > On Monday, October 20, 2014 11:04:46 AM Krzysztof Kozlowski wrote:
> > > @@ -198,8 +217,10 @@ static int amba_probe(struct device *dev)
> > >  		pm_runtime_enable(dev);
> > >  
> > >  		ret = pcdrv->probe(pcdev, id);
> > > -		if (ret == 0)
> > > +		if (ret == 0) {
> > > +			pcdev->irq_safe = pm_runtime_is_irq_safe(dev);
> > 
> > This looks racy.
> > 
> > Is it guaranteed that runtime PM callbacks won't be run for the device
> > after pcdrv->probe() has returned and before setting pcdev->irq_safe?
> > If not, inconsistent behavior may ensue.
> 
> You are absolutely correct.  So that knocks that idea on its head.

Actually, I think we shouldn't give up hope here.  Currently, we do this:

                pm_runtime_get_noresume(dev);
                pm_runtime_set_active(dev);
                pm_runtime_enable(dev);

                ret = pcdrv->probe(pcdev, id);

What we could do is:

		pm_runtime_get_noresume(dev);
                pm_runtime_get_noresume(dev);
                pm_runtime_set_active(dev);
                pm_runtime_enable(dev);

                ret = pcdrv->probe(pcdev, id);
		if (ret == 0) {
			pcdev->irq_safe = pm_runtime_is_irq_safe(dev);
			pm_runtime_put(dev);
			break;
		}

                pm_runtime_disable(dev);
                pm_runtime_set_suspended(dev);
                pm_runtime_put_noidle(dev);
                pm_runtime_put_noidle(dev);

which would ensure that we hold a usecount until after the probe function
has returned.  Would that work?

I'll give you that it's pretty horrid.

Would another possible solution be to remember the irq-safeness in the
suspend handler, and use that in the resume handler?  Resume should
/always/ undo what the suspend handler previously did wrt clk API stuff.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
