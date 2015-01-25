Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbbAYRyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 12:54:36 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:53129 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbbAYRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 12:54:34 -0500
Date: Sun, 25 Jan 2015 17:54:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>, stable@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tyler Baker <tyler.baker@linaro.org>
Subject: Re: [PATCH] mmc: sdhci: Don't signal the sdio irq if it's not setup
Message-ID: <20150125175411.GG26493@n2100.arm.linux.org.uk>
References: <1421705229-20260-1-git-send-email-sjoerd.simons@collabora.co.uk>
 <20150125174516.GC6467@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125174516.GC6467@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 09:45:16AM -0800, Greg KH wrote:
> On Mon, Jan 19, 2015 at 11:07:09PM +0100, Sjoerd Simons wrote:
> > With 3.14.29 (and older kernels) some of my I.mx6 Sabrelite boards were
> > crashing with the following oops:
> > 
> >   sdhci: Secure Digital Host Controller Interface driver
> >   sdhci: Copyright(c) Pierre Ossman
> >   sdhci-pltfm: SDHCI platform and OF driver helper
> >   sdhci-esdhc-imx 2198000.usdhc: could not get ultra high speed state, work on normal mode
> >   mmc0: no vqmmc regulator found
> >   mmc0: SDHCI controller on 2198000.usdhc [2198000.usdhc] using ADMA
> >   Unable to handle kernel NULL pointer dereference at virtual address 00000000
> >   pgd = c0004000
> >   [00000000] *pgd=00000000
> >   Internal error: Oops: 5 [#1] SMP ARM
> >   Modules linked in:
> >   CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.29 #1
> >   task: c08a7120 ti: c089c000 task.ti: c089c000
> >   PC is at wake_up_process+0x8/0x40
> >   LR is at sdhci_irq+0x748/0x9c4
> > 
> > Full boot log can be found at:
> >   http://storage.kernelci.org/stable/v3.14.29/arm-multi_v7_defconfig/lab-collabora/boot-imx6q-sabrelite.html
> > 
> > This happens if the sdhci interrupt status contains SDHCI_INT_CARD_INT,
> > while the sdio irq was never setup.  This patch fixes that in a minimal
> > way by checking if the sdio irq was setup.
> > 
> > In more recent kernels this bug went away due to refactoring done by
> > Russel King. So an alternative (potentially better?) fix for this patch
> > is to cherrypick the following patches from a recent kernel:
> > 
> > 18258f7239a6 - genirq: Provide synchronize_hardirq()
> > bf3b5ec66bd0 - mmc: sdio_irq: rework sdio irq handling
> > 41005003bcaf - mmc: sdhci: clean up interrupt handling
> > 781e989cf593 - mmc: sdhci: convert to new SDIO IRQ handling
> > 
> > Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> > ---
> >  drivers/mmc/host/sdhci.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> I don't understand, either take 4 patches, or this single-line patches?

The four patches are to do with making the driver more correct, and
fixing quite a horrid pile of crap in the MMC core for SDIO interrupts.
It's entirely possible that they also fix some other additional problems
which a single line patch would also fix.

The sdhci driver is a stinking shitpile which needs to be rewritten from
scratch - it's had quirk after quirk added to it which makes it a total
unmaintainable mess, and I've seen nothing recent which suggests that
process is going to stop.  I think eventually, every single real line
in the driver is going to depend on a quirk bit so that users of it can
pick and choose which statements get executed.  Really, that's the
direction it seems to be heading, and no one seems to be saying "stop,
no, that's not a maintainable way forward."

I seemed to be the only one who decided to put some effort in to try
and reverse that trend with my mega patch set for it a few kernel
cycles ago which included the above four patches.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
