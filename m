Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3CDHzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:55:23 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4073 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab3CDHzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:55:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 03 Mar 2013 23:49:32 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 4 Mar 2013 13:25:15 +0530
Subject: RE: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
Thread-Topic: [PATCH] usb: host: tegra: Reset Tegra USB controller before
 init
Thread-Index: Ac4V38qsJmIsWN4iSta66h5EBMG1cQAn7SvQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6E4F7216C0@BGMAIL02.nvidia.com>
References: <1362033418-7332-1-git-send-email-vbyravarasu@nvidia.com>
 <512F9F0B.1040303@wwwdotorg.org>
In-Reply-To: <512F9F0B.1040303@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Thursday, February 28, 2013 11:47 PM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
> 
> On 02/27/2013 11:36 PM, Venu Byravarasu wrote:
> > To clear any configurations made by U-Boot on Tegra USB controller,
> > reset it before init in probe.
> 
> > diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> 
> > @@ -691,6 +692,10 @@ static int tegra_ehci_probe(struct platform_device
> *pdev)
> >  	if (err)
> >  		goto fail_clk;
> >
> > +	tegra_periph_reset_assert(tegra->clk);
> > +	udelay(1);
> > +	tegra_periph_reset_deassert(tegra->clk);
> 
> I think this patch might cause unintended consequences.
> 
> When the Tegra PHY code is converted to a driver (i.e. has its own
> probe), the initial order of execution of the PHY and EHCI driver probes
> will not be guaranteed.
> 
> In particular, since the EHCI probe will attempt to "find" the PHY
> device, and defer the EHCI probe until it can do so, this guarantees
> that the PHY's probe() will have completed before EHCI's probe()
> completes (although EHCI's probe may start running first some number of
> times, and be retried with -EPROBE_DEFERRED for a variety of reasons).
> 
> Now, if the PHY driver's probe() actually touches HW and sets up some
> registers, isn't this reset call going to trash any of that register
> setup? Or, will PHY probe() not touch registers, but only do so during
> the standard PHY open/init "op"/API calls?
 
Yes, PHY driver probe does not touch any registers. It just sets up the PHY API hooks.
These APIs will be called from ehci-tegra.c as part of ehci tegra probe function, after
getting  PHY handle, which in turn happens after issuing above reset.

Thanks to Stephen & Alan, for the review comments.
 
> 
> I think the way to solve this is to put the reset call into the PHY
> driver. I assume it has access to the appropriate clock object. 

