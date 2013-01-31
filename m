Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3AaBRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:17:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34970 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab3AaBRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:17:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH 1/5] e1000e: fix resuming from runtime-suspend
Date: Thu, 31 Jan 2013 02:23:27 +0100
Message-ID: <4689665.USakedKCym@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130118114214.6698.24975.stgit@zurg>
References: <20130118113019.6698.25941.stgit@zurg> <20130118114214.6698.24975.stgit@zurg>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 18, 2013 03:42:14 PM Konstantin Khlebnikov wrote:
> Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
> ("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: e1000-devel@lists.sourceforge.net
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index fbf75fd..2853c11 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -5691,14 +5691,17 @@ static int e1000_runtime_suspend(struct device *dev)
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct net_device *netdev = pci_get_drvdata(pdev);
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
> +	int retval;
> +	bool wake;
>  
> -	if (e1000e_pm_ready(adapter)) {
> -		bool wake;
> +	if (!e1000e_pm_ready(adapter))
> +		return 0;
>  
> -		__e1000_shutdown(pdev, &wake, true);
> -	}
> +	retval = __e1000_shutdown(pdev, &wake, true);
> +	if (!retval)
> +		e1000_power_off(pdev, true, wake);

That needs to be pci_finish_runtime_suspend() (which needs to be exported
for this purpose) or remove the pci_save_state() from __e1000_shutdown().

If the latter works, I'd very much prefer it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
