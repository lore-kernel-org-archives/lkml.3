Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab3CEAf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 19:35:27 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59331 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3CEAfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 19:35:05 -0500
Date: Tue, 5 Mar 2013 08:34:23 +0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
Message-ID: <20130305003423.GA23996@kroah.com>
References: <1362033418-7332-1-git-send-email-vbyravarasu@nvidia.com>
 <512F9F0B.1040303@wwwdotorg.org>
 <D958900912E20642BCBC71664EFECE3E6E4F7216C0@BGMAIL02.nvidia.com>
 <5134D210.3060405@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5134D210.3060405@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 09:55:44AM -0700, Stephen Warren wrote:
> On 03/04/2013 12:55 AM, Venu Byravarasu wrote:
> > Stephen Warren wrote at Thursday, February 28, 2013 11:47 PM:
> >> On 02/27/2013 11:36 PM, Venu Byravarasu wrote:
> >>> To clear any configurations made by U-Boot on Tegra USB controller,
> >>> reset it before init in probe.
> >>
> >>> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> >>
> >>> @@ -691,6 +692,10 @@ static int tegra_ehci_probe(struct platform_device
> >> *pdev)
> >>>  	if (err)
> >>>  		goto fail_clk;
> >>>
> >>> +	tegra_periph_reset_assert(tegra->clk);
> >>> +	udelay(1);
> >>> +	tegra_periph_reset_deassert(tegra->clk);
> >>
> >> I think this patch might cause unintended consequences.
> >>
> >> When the Tegra PHY code is converted to a driver (i.e. has its own
> >> probe), the initial order of execution of the PHY and EHCI driver probes
> >> will not be guaranteed.
> >>
> >> In particular, since the EHCI probe will attempt to "find" the PHY
> >> device, and defer the EHCI probe until it can do so, this guarantees
> >> that the PHY's probe() will have completed before EHCI's probe()
> >> completes (although EHCI's probe may start running first some number of
> >> times, and be retried with -EPROBE_DEFERRED for a variety of reasons).
> >>
> >> Now, if the PHY driver's probe() actually touches HW and sets up some
> >> registers, isn't this reset call going to trash any of that register
> >> setup? Or, will PHY probe() not touch registers, but only do so during
> >> the standard PHY open/init "op"/API calls?
> >  
> > Yes, PHY driver probe does not touch any registers. It just sets up the PHY API hooks.
> > These APIs will be called from ehci-tegra.c as part of ehci tegra probe function, after
> > getting  PHY handle, which in turn happens after issuing above reset.
> > 
> > Thanks to Stephen & Alan, for the review comments.
> 
> OK, in that case I have no objection to this patch.
> 
> I'd like to hold off on applying this though; I suspect I'll want to
> take the Tegra USB patches through the Tegra tree rather than the USB
> tree again for the 3.10 kernel cycle. I think I may have screwed the
> pooch on the DT binding I set up for the USB controller clocks, and
> fixing this may require some Tegra DT changes, which would be easiest
> taken through the Tegra tree, and so to reduce conflicts in the USB
> code, taking the rest through there migth just be easiest.
> 
> Alan, Greg, if you're OK with this patch now, or for any revised
> version, an Ack so I can take it through the Tegra tree would be great,
> thanks.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
