Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbaFQP4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:56:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40037 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339AbaFQP4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:56:51 -0400
Message-ID: <53A0653F.7090001@wwwdotorg.org>
Date: Tue, 17 Jun 2014 09:56:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: EHCI: tegra: Fix use-after-free in .remove()
References: <1403014660-15509-1-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1403014660-15509-1-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 08:17 AM, Tuomas Tynkkynen wrote:
> The tegra_ehci_hcd structure is located in the private space allocated
> by the core USB code so it must not be accessed after the HCD is
> freed.

> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c

This seems to be a persistent problem. Witness commit ecc8a0cdca18 "usb:
host: tegra: fix warning messages in ehci_remove". So, I wonder if ...

> @@ -479,10 +479,11 @@ static int tegra_ehci_remove(struct platform_device *pdev)
>  
>  	usb_phy_shutdown(hcd->phy);
>  	usb_remove_hcd(hcd);
> -	usb_put_hcd(hcd);
>  
>  	clk_disable_unprepare(tegra->clk);
>  

It's worth putting a comment here:

	/* This must be last, since *tegra is part of *hcd */
> +	usb_put_hcd(hcd);
> +
>  	return 0;
>  }

Of course, that could be a separate commit if you want.
