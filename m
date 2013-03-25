Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab3CYJEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:04:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:56987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757255Ab3CYJEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:04:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208";a="284131636"
Message-ID: <1364202254.18714.101.camel@smile>
Subject: Re: [PATCH 3/4] dw_dmac: make build of DT related methods optional
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Date: Mon, 25 Mar 2013 11:04:14 +0200
In-Reply-To: <201303221519.14108.arnd@arndb.de>
References: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1363963401-7924-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <201303221519.14108.arnd@arndb.de>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 15:19 +0000, Arnd Bergmann wrote: 
> On Friday 22 March 2013, Andy Shevchenko wrote:
> > There is no reason to build custom filter function and translation function
> > inside the driver in case we have no DT platform.
> > 
> > This patch introduces new method dw_dma_of_controller_register() and moves all
> > DT related stuff under #ifdef CONFIG_OF. It also helps to distinguish the real
> > -ENODEV return code of fake one when of_dma_controller_register is not
> > implemented.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> This should have no impact on the object code at all, since everything
> inside of the #ifdef is be dropped by the compiler anyway if
> of_dma_controller_register is stubbed out.

Right.


> I generally prefer to have all driver code be compiled  all the time
> to catch build regressions independent of the configuration, and leave
> the #ifdefs in header files that provide the interfaces.

I don't. For checking we have special make targets:

  allnoconfig     - New config where all options are answered with no
  allyesconfig    - New config where all options are accepted with yes
  allmodconfig    - New config selecting modules when possible
  alldefconfig    - New config with all symbols set to default

> > -	if (pdev->dev.of_node) {
> > -		err = of_dma_controller_register(pdev->dev.of_node,
> > -						 dw_dma_of_xlate, dw);
> > -		if (err && err != -ENODEV)
> > -			dev_err(&pdev->dev,
> > -				"could not register of_dma_controller\n");
> > -	}
> > +	if (pdev->dev.of_node)
> > +		dw_dma_of_controller_register(dw);
> 
> If you want to remove the "err != -ENODEV" check here, we could rewrite
> this as 
> 
> 	if (IS_ENABLED(CONFIG_OF)) && pdev->dev.of_node) {
> 		err = of_dma_controller_register(pdev->dev.of_node,
> 						 dw_dma_of_xlate, dw);
> 		if (err)
> 			dev_err(&pdev->dev,
> 				"could not register of_dma_controller\n");
> 	}
> 
> Or alternatively, we can change the of_dma_controller_register() stub to
> return 0 if CONFIG_OF is disabled. That would also take care of similar
> code in other dma engine drivers.

Actually to be aligned with other dmaengine code it should return
-ENOSYS. And by description ENOSYS seems  suitable for "not implemented"
cases.


What about to move all CONFIG_OF stuff into separate file?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
