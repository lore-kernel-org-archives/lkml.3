Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaGBO7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:59:24 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:52689 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaGBO7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:59:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <liviu@dudau.co.uk>, Sinan Kaya <okaya@codeaurora.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper function.
Date: Wed, 02 Jul 2014 16:58:58 +0200
Message-ID: <5997020.x4BWezXjnq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140702142303.GJ2173@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <7343032.WUqPgbXNQS@wuerfel> <20140702142303.GJ2173@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VEQ1d2ngTJ+XW4WJQDLdmfHbT8V3DTcrded8uCMgZFp
 86Y6spGeZiCIT7rjVJSClji/5xyLQfOUHUw/5jC3px4mt1DRYo
 mP16QXuz7Dw5fUqMBBlFTYECEIyZHCo+XLlkiSTDTlIYi+Kf/4
 DJqOseOl7nlXWZ7se8/v0eMCPN0jGIGniD5r2EsAr56lTt53Jo
 8+20x9uzKWSizuAqZVp7GDrDsxzb2R/sHJ0mvFYv0jOSqNRypD
 4ADs/GO2GC4C0gKp5wzihYM1ZwmwbQX8Hge8A1b9Dip2dtaZG/
 Wu8j5Urup+lno6AqYhPq6O3YejOdvzqCDHnu6j17Eul4M04Rhf
 z3jU0SzFAQO4xSFXBQOw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2014 15:23:03 Liviu Dudau wrote:
> > 
> > Your solution looks correct to me, just using different
> > tradeoffs to what I was expecting: You get a working pci_address_to_pio()
> > function, which is probably never needed, but in turn you need to
> > keep the state of each host bridge in a global list.
> 
> Just a reminder that with my patchset I *do* start using pci_address_to_pio()
> in order to correctly parse the IO ranges from DT.

Yes, what I meant is that it would be easier not to do that. All existing
drivers expect of_pci_range_to_resource() to return the CPU address for
an I/O space register, not the Linux I/O port number that we want to 
pass to the PCI core. This is suboptimal because it's not obvious how
it works, but it lets us get away without an extra registration step.
Once all probe functions in PCI host drivers have been changed to the
of_create_pci_host_bridge, that should not matter any more, because
there is only one place left that calls it and we only have to get it
right once.

Also, when you change that of_pci_range_to_resource, you also have to 
audit all callers of that function and ensure they can deal with the new
behavior.

	Arnd
