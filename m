Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbbAEP3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:29:09 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:64008 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbbAEP3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:29:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Cc: Sneeker Yeh <sneeker.yeh@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH 2/3] usb: dwc3: add Fujitsu Specific Glue layer
Date: Mon, 05 Jan 2015 16:28:34 +0100
Message-ID: <3428284.QtTr113xXr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150103012128.GA11373@saruman>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com> <1456155.YPH2fYoGgF@wuerfel> <20150103012128.GA11373@saruman>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:UBq4jKNHXYKMPDHY7sLPoS45I4aqZ2CDLl3bkPaC/CfD71FDaEW
 TVWk0WC6e38ilU2azwtG/M7FpmH9S+BvpcOYrOqzZ8G/sD53wCJU1EK8r1mDauX97L06xVA
 Q2v6wl/4X4QWRvyARx1sZU8wXm3evYKTtOD+ns3fun2QTW7Xv0nV5kkZoEJQfBI73iUNcYt
 EhXhNG8+Ev4ChPAXD7ABA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2015 19:21:28 Felipe Balbi wrote:
> 
> On Tue, Dec 30, 2014 at 11:12:51AM +0100, Arnd Bergmann wrote:
> > On Monday 29 December 2014 01:52:04 Sneeker Yeh wrote:
> > > > > +static int dwc3_mb86s70_remove_child(struct device *dev, void *unused)
> > > > > +{
> > > > > +     struct platform_device *pdev = to_platform_device(dev);
> > > > > +
> > > > > +     of_device_unregister(pdev);
> > > > > +
> > > > > +     return 0;
> > > > > +}
> > > > > +
> > > > > +static u64 dwc3_mb86s70_dma_mask = DMA_BIT_MASK(32);
> > > >
> > > > why ? Use dma_coerce_mask_and_coherent().
> > > >
> > > 
> > > okay.
> > 
> > Actually that is still wrong: we use dma_coerce_mask_and_coherent() to
> > annotate drivers that have traditionally been forcing their own dma mask
> > by some other means and that need to be changed to something proper (after
> > finding out why they did it in the first place).
> > 
> > Since this is about a child device, the correct interface is to use
> > platform_device_register_full().
> 
> no, that's wrong. He's essentially fixing the default set by OF core,
> which is always 32-bits anyway, so this can actually be removed. Your
> suggestion would just make it worse.

Ah, so this was for a device that gets probed from DT? Yes, then no
change is needed here at all.

Note that I'm working on a patch set to change the DT initialization to
be a little smarter about the mask. Specifically any device whose parent
has a smaller dma-ranges window than 4GB needs to start out with the
smaller mask, and the dma_set_mask function that is called to allow 64-bit
DMA on a device will check if the bus can actually support it.

	Arnd
