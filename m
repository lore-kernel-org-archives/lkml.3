Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaKEBdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:33:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:55314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbaKEBdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:33:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,316,1413270000"; 
   d="scan'208";a="602415957"
Message-ID: <54597E5B.2030701@intel.com>
Date: Wed, 05 Nov 2014 09:33:15 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>, bhelgaas@google.com,
        tj@kernel.org, rjw@rjwysocki.net, mister.freeman@laposte.net
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
References: <1415149665-26669-1-git-send-email-chuansheng.liu@intel.com>
In-Reply-To: <1415149665-26669-1-git-send-email-chuansheng.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 09:07 AM, Chuansheng Liu wrote:
> The JMicron chip 361/363/368 contains one SATA controller and
> one PATA controller, they are brother-relation ship in PCI tree,
> but for powering on these both controller, we must follow the
> sequence one by one, otherwise one of them can not be powered on
> successfully.
> 
> So here we disable the async suspend method for Jmicron chip.
>

Place the buglink here?

  Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=84861
  Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=81551
> Cc: stable@vger.kernel.org # 3.15+
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>

Patch looks good to me, thanks for fixing this!

-Aaron

> ---
>  drivers/pci/pci.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 625a4ac..53128f0 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2046,7 +2046,17 @@ void pci_pm_init(struct pci_dev *dev)
>  	pm_runtime_forbid(&dev->dev);
>  	pm_runtime_set_active(&dev->dev);
>  	pm_runtime_enable(&dev->dev);
> -	device_enable_async_suspend(&dev->dev);
> +
> +	/*
> +	 * The JMicron chip 361/363/368 contains one SATA controller and
> +	 * one PATA controller, they are brother-relation ship in PCI tree,
> +	 * but for powering on these both controller, we must follow the
> +	 * sequence one by one, otherwise one of them can not be powered on
> +	 * successfully, so here we disable the async suspend method for
> +	 * Jmicron chip.
> +	 */
> +	if (dev->vendor != PCI_VENDOR_ID_JMICRON)
> +		device_enable_async_suspend(&dev->dev);
>  	dev->wakeup_prepared = false;
>  
>  	dev->pm_cap = 0;
> 

