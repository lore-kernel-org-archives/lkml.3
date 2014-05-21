Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaEUKFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:05:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:47192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaEUKF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:05:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,879,1392192000"; 
   d="scan'208";a="544144774"
Date: Wed, 21 May 2014 13:05:11 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mike Turquette <mturquette@linaro.org>, Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/4] ACPI / LPSS: custom power domain for LPSS
Message-ID: <20140521100511.GA29349@xps8300>
References: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1400161226-24067-3-git-send-email-heikki.krogerus@linux.intel.com>
 <3202918.AHHS8JP9gx@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3202918.AHHS8JP9gx@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Tue, May 20, 2014 at 11:33:09PM +0200, Rafael J. Wysocki wrote:
> > +#ifdef CONFIG_PM
> 
> It would be good to add a kerneldoc explaining what's being saved here and why.

OK.

> > +static void acpi_lpss_save_ctx(struct device *dev)
> > +{
> > +	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
> > +	int i;
> > +
> > +	for (i = 0; i < LPSS_PRV_REG_COUNT; i++) {
> > +		pdata->prv_reg_ctx[i] = __lpss_reg_read(pdata, i * sizeof(u32));
> > +		dev_dbg(dev, "saving 0x%08x from LPSS reg at offset 0x%02x\n",
> > +			pdata->prv_reg_ctx[i], (unsigned int)(i * sizeof(u32)));
> > +	}
> > +}
> > +
> > +static void acpi_lpss_restore_ctx(struct device *dev)
> > +{
> > +	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
> > +	int i;
> > +
> > +	/* PCI spec expects 10ms delay when resuming from D3 to D0 */
> > +	msleep(10);
> 
> Two questions here.
> 
> First, is the 10 ms sleep really necessary?  I'd expect the AML to take care of
> such delays (this is not a PCI device formally).

Unfortunately that is not the case. There is nothing in the AML for
this. Mika, correct me if I'm wrong.

> And because this is not a PCI device formally, why is the comment talking about
> the PCI spec?  Why is PCI relevant in any way here?

Under the hood the devices are still PCI devices, even if they
formally aren't. Maybe I should point that out in the comment..

We put the sleep there because without it there was no guarantee if
the device was properly resumed by the time the drivers resume hooks
were called. The symptom in case of a failure was simply that the
registers could not be written, which leads into timeouts at least in
case of the I2C and UART and making them unusable until the next
suspend followed by resume.


Thanks,

-- 
heikki
