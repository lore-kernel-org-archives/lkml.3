Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaA2KbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:31:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:52656 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaA2KbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:31:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,741,1384329600"; 
   d="scan'208";a="474378608"
Date: Wed, 29 Jan 2014 12:38:13 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "xinhui.pan" <xinhuix.pan@intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        yanmin_zhang@linux.intel.com, bo.he@intel.com
Subject: Re: [PATCH] i2c-designware-pcidrv: fix the incorrect return of idle
 callback
Message-ID: <20140129103813.GN18029@intel.com>
References: <52E744AC.2050606@intel.com>
 <20140128183035.GC20789@katana>
 <20140129083548.GG18029@intel.com>
 <52E8D13A.1060100@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52E8D13A.1060100@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 06:00:26PM +0800, xinhui.pan wrote:
> 
> 
> 于 2014年01月29日 16:35, Mika Westerberg 写道:
> > On Tue, Jan 28, 2014 at 07:30:35PM +0100, Wolfram Sang wrote:
> >> On Tue, Jan 28, 2014 at 01:48:28PM +0800, xinhui.pan wrote:
> >>> From: "xinhui.pan" <xinhuix.pan@intel.com>
> >>>
> >>> i2c_dw_pci_runtime_idle should return -EBUSY rather than zero if it do success.
> >>
> >> I don't understand...
> >>
> >>> Otherwise rpm_idle will call pm_suspend again and that may cause pm_schedule_suspend delay invalidate.
> >>> 	
> >>> Signed-off-by: bo.he <bo.he@intel.com>
> >>> Signed-off-by: xinhui.pan <xinhuix.pan@intel.com>
> >>> ---
> >>>  drivers/i2c/busses/i2c-designware-pcidrv.c |    4 ++--
> >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
> >>> index f6ed06c..96e81f6 100644
> >>> --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> >>> +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> >>> @@ -190,8 +190,8 @@ static int i2c_dw_pci_runtime_idle(struct device *dev)
> >>>  	int err = pm_schedule_suspend(dev, 500);
> >>>  	dev_dbg(dev, "runtime_idle called\n");
> >>>  
> >>> -	if (err != 0)
> >>> -		return 0;
> >>> +	if (err)
> >>> +		return err;
> >>>  	return -EBUSY;
> >>
> >> ... it does return EBUSY when pm_schedule_suspend() succeeds? It only
> >> returns 0 if it does not succeed (for which I don't know if this is an
> >> apropriate behaviour). Mika?
> > 
> > If I understand correctly, pm_schedule_suspend(dev, 500) is there because
> > we want to runtime suspend in 500 ms. It then returns -EBUSY to prevent PM
> > runtime from carrying on suspend on it's own. However, I have no idea where
> > this magical 500 ms requirement comes from.
> > 
> > If we fail to schedule suspend we let the PM core to do whatever it thinks
> > suitable (in this case I suppose it suspends the device).
> > 
> 
> Hi ,Mika
>   If the callback returns 0,it means pm_schedule_suspend fails,
> also means rpm_check_suspend_allowed(pm_schedule_suspend calls it) 
> returns nonzero value.As a result,rpm_suspend will be called by rpm_idle.
>   However in rpm_idle, rpm_check_suspend_allowed is called at first,too.
> and the return value is treated as it is.But rpm_idle just returns 
> without doing anything(rpm_suspend is not called). 
>   in both case above,why goes in different ways? I am confused.

To be honest, I don't know ;-)

> > I think the whole idle dance could be replaced with a use of runtime PM
> > autosuspend, just like we do in the platform version of the driver.
> > 
> > Xinghui,
> > 
> > Is this a real problem that you are trying to solve?
> > 
> 
> To be honest,we got many panic when testing.
> But is not caused by this driver I think.
> while checking problems,we found these confusing codes by accident.

OK, so if this is not a problem, I would suggest keeping the code as is for
now as someone who introduced the pm_schedule_suspend() thing probably
tested it and it worked then.

In fact, I think that the PCI part of that driver needs an audit since it
does some PCI power management magic itself which drivers aren't supposed
to do anymore.
