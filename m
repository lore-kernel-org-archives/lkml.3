Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab3EFVsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:48:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51370 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab3EFVsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 17:48:08 -0400
Date: Mon, 6 May 2013 23:49:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Ortiz, Lance E" <lance.oritz@hp.com>
Cc: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Dall, Elizabeth J (MCLinux)" <betty.dall@hp.com>
Subject: Re: WARNING at drivers/pci/search.c:214 for 3.9
Message-ID: <20130506214913.GE22041@pd.tnic>
References: <20130506162112.6b79b7b1@pluto.restena.lu>
 <20130506150757.GC22041@pd.tnic>
 <A961433CDFF2F640A2866803152E61F951772648@G9W0715.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A961433CDFF2F640A2866803152E61F951772648@G9W0715.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 09:20:04PM +0000, Ortiz, Lance E wrote:
> Right Boris, looks like we are hitting the WARN_ON(in_interrupt)
> in pci_get_dev_by_id(). We recently started seeing this on our
> test systems when injecting errors.

Ok, I think I have it. That comes from cper_print_pcie(), i.e. your
enhanced PCIe logging in 1d5210008bd3a26daf4b06aed9d6c330dd4c83e2 which
came in 3.9. And since 3.9 is just out now, people are starting to see
the issue.

If you look at the call stack, you land in cper_print_pcie() down
from ghes_proc() which can be called from the polling routine
ghes_poll_func() but also from the interrupt handler ghes_irq_func.

> The only reason we are calling pci_get_domain_bus_and_slot() is to get
> the pci_dev* to pass into cper_print_aer() so we can have the device's
> name to put into the trace event for AER. If we can find another way
> to get the device name for the trace event we could remove this call
> to pci_get_domain_bus_and_slot(). I will continue to look into an
> alternative. If you have any ideas on how to get the device data from
> this context let me know.

Hmm, not sure.

Off the top of my head, maybe add the whole code around:

#ifdef CONFIG_ACPI_APEI_PCIEAER
...

#endif

in cper_print_pcie() into a separate function which is called from a
workqueue right after the interrupt is done.. Or something to that
effect.

> I'm not sure why the pci_get_domain_bus_and_slot() is failing to find
> the PCI device though. We are not hitting that issue. We are just
> seeing the in_interrupt warning.

Well, it could be corrupted error info or such because it used to say

[   65.782664] {1}[Hardware Error]: device_id: 0000:00:02.3

but he doesn't have a 02.3 device in the lspci output.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
