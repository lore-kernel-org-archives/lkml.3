Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab3CVPTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:19:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3CVPTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:19:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 3/4] dw_dmac: make build of DT related methods optional
Date: Fri, 22 Mar 2013 15:19:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>
References: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com> <1363963401-7924-4-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1363963401-7924-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221519.14108.arnd@arndb.de>
X-Provags-ID: V02:K0:9BtDgd+ePhfWZefm3dxZEz6++2e76Ycd9kfd9qT8oqU
 uZiR3OkSns+JvEmlr1pKdtolxpH/klOwgwOqyyc+SLaWnjRtHN
 XJKQyvjFog+HdIkYFLK4Jyp1ySPL5C1ADvVgRsJBr8bfpdbKXX
 +hqg4ymlwqT+qgwzKiQJCVTj0+x10J0OfbUgbUckRrN1wsAkyM
 /SwsMVkmAseoSmF5yUG2n1HherZ8UFxkGa4LyglERnGppaiau9
 54cHvYOTVwuyZj1m2FlZES4VRl7BZhBUE8/q+GjuohtfbSb3Se
 +6rgddyNW23tPk+8BLQbFCVVF2a4g73ye2wlvFOeNuaL0/kTcy
 hJLNIMEyhD0xqM57nwHg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 March 2013, Andy Shevchenko wrote:
> There is no reason to build custom filter function and translation function
> inside the driver in case we have no DT platform.
> 
> This patch introduces new method dw_dma_of_controller_register() and moves all
> DT related stuff under #ifdef CONFIG_OF. It also helps to distinguish the real
> -ENODEV return code of fake one when of_dma_controller_register is not
> implemented.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This should have no impact on the object code at all, since everything
inside of the #ifdef is be dropped by the compiler anyway if
of_dma_controller_register is stubbed out.

I generally prefer to have all driver code be compiled  all the time
to catch build regressions independent of the configuration, and leave
the #ifdefs in header files that provide the interfaces.

> -	if (pdev->dev.of_node) {
> -		err = of_dma_controller_register(pdev->dev.of_node,
> -						 dw_dma_of_xlate, dw);
> -		if (err && err != -ENODEV)
> -			dev_err(&pdev->dev,
> -				"could not register of_dma_controller\n");
> -	}
> +	if (pdev->dev.of_node)
> +		dw_dma_of_controller_register(dw);

If you want to remove the "err != -ENODEV" check here, we could rewrite
this as 

	if (IS_ENABLED(CONFIG_OF)) && pdev->dev.of_node) {
		err = of_dma_controller_register(pdev->dev.of_node,
						 dw_dma_of_xlate, dw);
		if (err)
			dev_err(&pdev->dev,
				"could not register of_dma_controller\n");
	}

Or alternatively, we can change the of_dma_controller_register() stub to
return 0 if CONFIG_OF is disabled. That would also take care of similar
code in other dma engine drivers.

	Arnd
