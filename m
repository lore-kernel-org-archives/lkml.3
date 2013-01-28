Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3A1XF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:05:56 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61400 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3A1XFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:05:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130118114214.6698.24975.stgit@zurg>
References: <20130118113019.6698.25941.stgit@zurg> <20130118114214.6698.24975.stgit@zurg>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Jan 2013 16:05:33 -0700
Message-ID: <CAErSpo4G=hQ79KJg_6QgoO9nmG-B5xA_ooph7G6Uu-9wGkrnTQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] e1000e: fix resuming from runtime-suspend
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael, author of patch you cited]

On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
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
>         struct pci_dev *pdev = to_pci_dev(dev);
>         struct net_device *netdev = pci_get_drvdata(pdev);
>         struct e1000_adapter *adapter = netdev_priv(netdev);
> +       int retval;
> +       bool wake;
>
> -       if (e1000e_pm_ready(adapter)) {
> -               bool wake;
> +       if (!e1000e_pm_ready(adapter))
> +               return 0;
>
> -               __e1000_shutdown(pdev, &wake, true);
> -       }
> +       retval = __e1000_shutdown(pdev, &wake, true);
> +       if (!retval)
> +               e1000_power_off(pdev, true, wake);
>
> -       return 0;
> +       return retval;
>  }
>
>  static int e1000_idle(struct device *dev)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
