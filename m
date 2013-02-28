Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3B1SQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:16:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46741 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3B1SQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:16:46 -0500
Message-ID: <512F9F0B.1040303@wwwdotorg.org>
Date: Thu, 28 Feb 2013 11:16:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
References: <1362033418-7332-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1362033418-7332-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 11:36 PM, Venu Byravarasu wrote:
> To clear any configurations made by U-Boot on Tegra USB controller,
> reset it before init in probe.

> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c

> @@ -691,6 +692,10 @@ static int tegra_ehci_probe(struct platform_device *pdev)
>  	if (err)
>  		goto fail_clk;
>  
> +	tegra_periph_reset_assert(tegra->clk);
> +	udelay(1);
> +	tegra_periph_reset_deassert(tegra->clk);

I think this patch might cause unintended consequences.

When the Tegra PHY code is converted to a driver (i.e. has its own
probe), the initial order of execution of the PHY and EHCI driver probes
will not be guaranteed.

In particular, since the EHCI probe will attempt to "find" the PHY
device, and defer the EHCI probe until it can do so, this guarantees
that the PHY's probe() will have completed before EHCI's probe()
completes (although EHCI's probe may start running first some number of
times, and be retried with -EPROBE_DEFERRED for a variety of reasons).

Now, if the PHY driver's probe() actually touches HW and sets up some
registers, isn't this reset call going to trash any of that register
setup? Or, will PHY probe() not touch registers, but only do so during
the standard PHY open/init "op"/API calls?

I think the way to solve this is to put the reset call into the PHY
driver. I assume it has access to the appropriate clock object. This may
also address Alan's query re: when the unexpected interrupt occurs; it's
triggered by (or correlated with at least) the PHY (or USB port in
general) being in device mode due to the boot ROM setting it up this
way, then switching to host mode via the Linux driver. I /think/ that
device/host mode switching is more related to the PHY than EHCI driver,
although I could well be wrong here.
