Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaCJOoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:44:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45409 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbaCJOoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:44:17 -0400
Date: Mon, 10 Mar 2014 14:44:14 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [PATCH v6 6/6] pci: Add support for creating a generic
 host_bridge from device tree
Message-ID: <20140310144414.GT6457@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com>
 <1394020137-1830-7-git-send-email-Liviu.Dudau@arm.com>
 <201403081815.08829.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201403081815.08829.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 10 Mar 2014 14:44:15.0419 (UTC) FILETIME=[358838B0:01CF3C6F]
X-MC-Unique: 114031014441509001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 05:15:08PM +0000, Arnd Bergmann wrote:
> On Wednesday 05 March 2014, Liviu Dudau wrote:
> > +
> > +	pr_debug("Parsing ranges property...\n");
> > +	for_each_of_pci_range(&parser, &range) {
> > +		/* Read next ranges element */
> > +		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
> > +				range.pci_space, range.pci_addr);
> > +		pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
> > +					range.cpu_addr, range.size);
> > +
> > +		/*
> > +		 * If we failed translation or got a zero-sized region
> > +		 * then skip this range
> > +		 */
> > +		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> > +			continue;
> > +
> > +		res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> > +		if (!res)
> > +			return -ENOMEM;
> > +
> > +		of_pci_range_to_resource(&range, dev, res);
> > +
> > +		if (resource_type(res) == IORESOURCE_IO)
> > +			*io_base = range.cpu_addr;
> > +
> > +		pci_add_resource_offset(resources, res,
> > +				res->start - range.pci_addr);
> > +	}
> 
> As mentioned regarding the pci_register_io_range() helper, x86
> would not enter the 'resource_type(res) == IORESOURCE_IO' code path,
> which on the one hand is fine so we can return an error from
> pci_register_io_range() there, but I think it will lead to
> io_base getting an uninitialized content.
> 
> There could also be other reasons why pci_register_io_range() fails,
> e.g. because the space is exhausted, and I think we should try to
> catch that here and skip the pci_add_resource_offset() and io_base
> assignment then.

Hi Arnd,

I will try to improve the error handling in the next patchset version.
However I am still confused about the earlier discussion on
pci_register_io_range(). Your suggestion initially was to return an
error in the default weak implementation, but in your last email you
are talking about returning 'port'. My idea when I've introduced the
helper function was that it would return an error if it fails to
register the IO range and zero otherwise. I agree that we can treat
the default 'do nothing with the IO range' case as an error, with
the caveat that will force architectures that use this code to
provide their own implementation of pci_register_io_range() in order
to avoid failure, even for the cases where the architecture has a 1:1
mapping between IO and CPU addresses.

I've just noticed that my home server has silently dropped my reply
to you from the 7th of March, so I'm going to resend it using ARM's
setup.

Best regards,
Liviu


> 
> 	Arnd
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

