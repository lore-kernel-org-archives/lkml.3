Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3BDUPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:15:48 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39239 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab3BDUPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:15:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 6/7] PCI/PM: warn about incomplete actions in ->runtime_suspend() callback
Date: Mon, 04 Feb 2013 21:22:03 +0100
Message-ID: <2146717.YNnkIQ37Mr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130204115612.5569.49895.stgit@zurg>
References: <20130204115246.5569.85829.stgit@zurg> <20130204115612.5569.49895.stgit@zurg>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 04, 2013 03:56:12 PM Konstantin Khlebnikov wrote:
> Documentation/power/pci.txt says:
> | It is expected that the device driver's pm->runtime_suspend() callback will
> | not attempt to prepare the device for signaling wakeup or to put it into a
> | low-power state.  The driver ought to leave these tasks to the PCI subsystem
> | that has all of the information necessary to perform them.
> 
> After commit 42eca2302146fed51335b95128e949ee6f54478f
> ("PCI: Don't touch card regs after runtime suspend D3")
> | If the driver takes care of state saving, don't touch any registers on it.
> pci_pm_runtime_suspend() thinks if state has been saved by ->runtime_suspend()
> that means device alredy prepared for wakeup and probably no longer accessible.
> 
> Thus driver must either do all actions or leave all these tasks to PCI subsystem.

I don't like this one, because it will generate noise for drivers that
legitimately use pci_save_state() in their runtime suspend callbacks
and know what they are doing.

Thanks,
Rafael


> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/pci-driver.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index f9aa311..2b0ff9a 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -1009,12 +1009,19 @@ static int pci_pm_runtime_suspend(struct device *dev)
>  		return 0;
>  	}
>  
> -	if (!pci_dev->state_saved) {
> -		pci_save_state(pci_dev);
> -		pci_finish_runtime_suspend(pci_dev);
> +	if (pci_dev->state_saved) {
> +		WARN_ONCE(pci_dev->current_state == prev,
> +			"PCI PM: Power state of device not changed by %pF\n",
> +			pm->runtime_suspend);
> +		WARN_ONCE(pci_dev_run_wake(pci_dev) &&
> +				!pci_dev->wakeup_prepared,
> +			"PCI PM: Waking of device not configured by %pF\n",
> +			pm->runtime_suspend);
> +		return 0;
>  	}
>  
> -	return 0;
> +	pci_save_state(pci_dev);
> +	return pci_finish_runtime_suspend(pci_dev);
>  }
>  
>  static int pci_pm_runtime_resume(struct device *dev)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
