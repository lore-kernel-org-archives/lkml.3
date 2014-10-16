Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaJPD7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:59:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:59397 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaJPD67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:58:59 -0400
Message-ID: <1413431917.11213.56.camel@pasglop>
Subject: Re: of/pci: Fix the conversion of IO ranges into IO resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>, Michael Ellerman <mpe@ellerman.id.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>
Date: Thu, 16 Oct 2014 14:58:37 +1100
In-Reply-To: <1413428148.20705.2.camel@concordia>
References: <20141009200235.55E5166107E@gitolite.kernel.org>
	 <1413358507.4748.4.camel@pasglop>
	 <20141015090239.GB18070@e106497-lin.cambridge.arm.com>
	 <1413428148.20705.2.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 13:55 +1100, Michael Ellerman wrote:
> Yes, we already provide our own version of pci_address_to_pio().
> 
> The problem is it's too early to call it when we come in from
> find_and_init_phbs() -> pci_process_bridge_OF_ranges(), so it returns junk.
> 
> I think you were expecting us to hit the #ifndef PCI_IOBASE case, which looks
> like it might have worked.
> 
> For now we're just going to stop using of_pci_range_to_resource().

Right, this is a band-aid to fix things now. For the long run, I think we could
exploit Liviu's code with a few changes:

 - We would want to add a variant of pci_register_io_range() that takes the actual
PIO address as an argument so we can use it to "register" our ranges on ppc64
since we decide where in IO space they go using our own algorithm and we don't
want to change that. That would make the generic pci_pio_to_address() and
pci_address_to_pio() work for us. At least for ppc64.

 - For ppc32, we might want to consider changing the horrible pointer arithmetic
we do today (which keeps breaking) and just switch to the allocator inside
pci_register_io_range() and use it like ARM does.

 - I object to of_pci_range_to_resource() implicitly doing the allocation/registration
of the range. It should fail if the range isn't registered. The architecture code
should explicitly register the IO ranges before trying to turn them into resources.

Now, this will take a bit more time to sort out (and the latter comment will
mean, if addressed, some changes to the new ARM code which I don't think I have
the bandwidth to do), so I'm happy to settle for whatever band-aid Michael is
coming up with for 3.18 but we should consider improving things for .19

Cheers,
Ben.


