Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab3BLR7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:59:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:9297 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933540Ab3BLR7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:59:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="261618449"
Date: Tue, 12 Feb 2013 09:34:35 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line
 base
Message-ID: <20130212173435.GA17659@intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
 <20130212155334.GK3789@intel.com>
 <20130212164351.GA20771@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212164351.GA20771@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 06:43:51PM +0200, Mika Westerberg wrote:
> On Tue, Feb 12, 2013 at 07:53:34AM -0800, Vinod Koul wrote:
> > On Tue, Jan 29, 2013 at 10:29:43AM +0530, Viresh Kumar wrote:
> > > Next time, please direct these mails to my Linaro id :)
> > > 
> > > On Mon, Jan 28, 2013 at 4:34 PM, Andy Shevchenko
> > > <andriy.shevchenko@linux.intel.com> wrote:
> > > > On some hardware configurations we have got the request line with the offset.
> > > > The patch introduces convert_slave_id() helper for that cases. The request line
> > > > base is got from the platform device resources provided by the IORESOURCE_DMA
> > > > type.
> > > 
> > > @Vinod: Is IORESOURCE_DMA suitable for this purpose?
> > Looks unlikely...
> > 
> > But why do we need this in first place?
> > 
> > I know this is due to common platform probe. Clearly one size not fitting all.
> > If you had dedicated PCI probe you wouldnt worrry right?
> 
> This is all related to new ACPI 5.0 features for devices enumerated from
> ACPI namespace, such as SPI controller.
> 
> ACPI 5.0 allows BIOS to specify DMA request lines and channels used by a
> slave device with FixedDMA() descriptors, such as:
> 
> 	FixedDMA (0x0010, 0x0000, Width32bit,) // TX
> 	FixedDMA (0x0011, 0x0001, Width32bit,) // RX
> 
> The first field (0x10, 0x11) is the request line assigned to the device. In
> this particular case it is the SPI controller.
> 
> Now there is only one DMA controller in this platform but the request lines
> still start from 0x10 (16).
> 
> Then there is another ACPI table called CSRT (Core System Resources Table)
> that assings request line range to the DMA controller itself. This range
> starts from 0x10 (16) for this platform.
> 
> So what we do is that we parse this CSRT table, create platform device for
> the DMA controller of found and pass the request line range as
> IORESOURCE_DMA resource with the platform device.
Okay, who parses the CSRT table and how is this presented to OS.

Can we do this in platform data and complete the base calculation.

In ACPI 5, is DMA a PCI device or platfrom device?
--
~Vinod
> 
> In this patch then Andy uses that resource to map the FixedDMA() request
> line to the actual hardware request line, which is for the SPI case:
> 
> 	0x10 -> 0
> 	0x11 -> 1
> 
> Unfortunately we didn't find any better way to pass this information than
> IORESOURCE_DMA. However, if you have better solution we certainly can
> change that :)
