Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab3FSPmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:42:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58312 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab3FSPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:42:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/11] MSM DT based multi-platform support
Date: Wed, 19 Jun 2013 17:42:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-msm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Rohit Vaswani <rvaswani@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306191742.26491.arnd@arndb.de>
X-Provags-ID: V02:K0:3Bwy0STTV5t4ydiNnotUoiLy144pbyCqYzq60kLNx2x
 SXNww+rrPseX4M1l0u8kB6k78p4liSLP47LFJknDisWpxxMM0I
 kB4yPLwiF3j9DrFg1Vq7XVEf91AGqXtAtzrpl1855xphaBDQTU
 78/hLO/+QZ1KUkI9AuuTsJIyHRnHPAN85zn8ia9xUY1bDE9XEp
 vzGM+xlQxLvLXxhEjI1OQopZtpvDNV7qBN+tImJ6B9MCEeyIGs
 FjddNlC7noorZgg5PoXg7lAb1PryeWo0EqMNfmLSh3fODpizS1
 ZIoj5sI5wLpb8+W34tcpEhDL5xsdp+YHoBbbndBfdSRo3XLksN
 595leAgewdBnmsmTyAps=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Stephen Boyd wrote:
> This patchset allows me to compile and run the DT based MSM
> platforms in the multi-platform ARM kernel. This is built on
> top of a couple patches I've sent out already (specifically
> the debug_ll patch series and the clocksource_of conversion)
> as well a patch from Rohit that didn't seem to make it into 
> MSM's for-next branch.

Very nice!

> There is one problem though, the last two patches cause compile
> failures if you turn on MSM's sdcc or USB_OTG driver. It seems
> that the sdcc driver depends on the clk_reset() API and the custom
> DMA interface provided by mach layers. And the USB_OTG driver depends
> on clk_reset.
> 
> The simplest solution is to make these two drivers depend on the
> non-dt based MSM support so that they can't be compiled in the
> multi-platform config. Otherwise, we'll need to replace the clk_reset()
> calls with the new reset controller API, but doing that would
> require us to convert all MSM platforms over to devicetree or
> we'll need to add support to the reset controller API for non-DT based
> controllers. Even with that, the sdcc driver uses custom DMA things
> so we may need to put that all behind some #ifdef.

The msm_serial_hs driver also seems to require the custom DMA
interface.

I think for the DMA stuff, the solution is clearly to move that
driver to use the dmaengine API, wich I assume you are already
planning to do anyway. Do you have a time line for that?

For the clk_reset interface, maybe you can move those calls int
platform_data callbacks for the non-DT machines to get them out
of the way?

You could have something like

	if (pdata && pdata->reset)
		pdata->reset(dev, clk);
	else
		reset_device(dev);

That wouldn't be too ugly. For the time being, disabling the
drivers on multiplatform sounds reasonable. I don't think you
actually have to have the drivers conflict with DT support:
you should be able to allow the DT based boards with non-multiplatform
to enable the two or three drivers anyway.

	Arnd
