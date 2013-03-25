Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3CYIix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:38:53 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:45349 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3CYIiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:38:51 -0400
Date: Mon, 25 Mar 2013 09:38:47 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Andrew Murray <andrew.murray@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] PCI: Introduce MSI chip infrastructure
Message-ID: <20130325093847.7474dc0e@skate>
In-Reply-To: <20130325075810.GA28935@avionic-0098.mockup.avionic-design.de>
References: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
	<20130322093027.GA521@arm.com>
	<20130324120649.6fb8c05d@skate>
	<20130325075810.GA28935@avionic-0098.mockup.avionic-design.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thierry Reding,

Thanks for your feedback!

On Mon, 25 Mar 2013 08:58:10 +0100, Thierry Reding wrote:

> That sounds very much like one of the use-cases that were discussed. The
> easiest solution would probably be to add an API to look up an MSI chip
> from a DT phandle, so that the PCIe controller's device node could have
> it as a property, somewhat like this:
> 
> 	msi: interrupt-controller {
> 	};
> 
> 	pcie-controller {
> 		...
> 		marvell,msi = <&msi>;
> 		...
> 	};

I'm not sure how to handle this msi interrupt controller with the main
interrupt controller. For now, I have:

        mpic: interrupt-controller@d0020000 {
              reg = <0xd0020a00 0x2d0>,
                    <0xd0021070 0x58>;
        };

	[...]

	soc {
                interrupt-parent = <&mpic>;
		[...]
	};

And the MSI interrupt controller shares the same registers as the MPIC.
So should it be something like:

	interrupt-controller {
		reg = <0xd0020a00 0x2d0>,
                    <0xd0021070 0x58>;

		mpic {
			/* Not sure what to have here */
		};

		msi {

			/* Here either */
		};
	};

	soc {
                interrupt-parent = <&mpic>;

		pcie-controller {
			marvell,msi = <&msi>;
		};
	};

Or some other idea?

> Then add some basic infrastructure to register the MSI chip with a
> global list, call that from the interrupt controller initialization:
> 
> 	...
> 	msi_chip_add(&msi);
> 	...
> 
> And finally look it up from the PCIe controller driver:
> 
> 	node = of_parse_phandle(dev->of_node, "marvell,msi", 0);
> 	if (node)
> 		msi = of_find_msi_chip_by_node(node);
> 
> That's roughly what other subsystems do. I wrote something similar once
> for backlight devices, though the registration step (msi_chip_add)
> wasn't necessary there since backlight devices all go into a common
> struct class so class_find_device() can be used instead of going through
> a separate registry.

Ok, that part sounds good to me. I'm still unsure about the DT
representation, though (see above), and experience has shown that's
it's a pretty good idea to discuss a little bit the DT representation
before going on with some code :)

Thanks again for your feedback!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
