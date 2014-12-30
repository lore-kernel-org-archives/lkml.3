Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaL3KNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:13:50 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:58332 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaL3KNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:13:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Rob Herring <robh+dt@kernel.org>,
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
Date: Tue, 30 Dec 2014 11:12:51 +0100
Message-ID: <1456155.YPH2fYoGgF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJ1gpc0uniw3F3O9nxTLHp9M2boxrOACYDB=fgruhLOLdqg9yA@mail.gmail.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com> <20141222155936.GB12815@saruman> <CAJ1gpc0uniw3F3O9nxTLHp9M2boxrOACYDB=fgruhLOLdqg9yA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:yqUZZ07mJsIzIfb5z0rTq4oxC5IR2QonwKm0VDELdfUey4FoPop
 SPEeYBLRMx259wmOAQCdC9gomHy7wYKNfdp685smCe9Cn2XbmNAeIkesfUYg+WzQeEBQe3/
 gS48tJF9xG4itOLqZljJDCFaNI8SG4Ji2w7vVVD2W60iujmvzWDOViLoluLf4tqatOO+J7W
 sAOTrfeWo/FouWv709fTA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2014 01:52:04 Sneeker Yeh wrote:
> > > +static int dwc3_mb86s70_remove_child(struct device *dev, void *unused)
> > > +{
> > > +     struct platform_device *pdev = to_platform_device(dev);
> > > +
> > > +     of_device_unregister(pdev);
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static u64 dwc3_mb86s70_dma_mask = DMA_BIT_MASK(32);
> >
> > why ? Use dma_coerce_mask_and_coherent().
> >
> 
> okay.

Actually that is still wrong: we use dma_coerce_mask_and_coherent() to
annotate drivers that have traditionally been forcing their own dma mask
by some other means and that need to be changed to something proper (after
finding out why they did it in the first place).

Since this is about a child device, the correct interface is to use
platform_device_register_full().

Note that this will still only work on machines that have no dma offset,
iommu, swiotlb, special coherency requirements, or ones that need a
platform specific dma_map_ops. To make any of those work, the driver
would need to be changed to pass the correct device pointer into any
dma-mapping interfaces, so the settings can get set by the platform
code. We will need to do that for arm64 I assume.

	Arnd
