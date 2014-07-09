Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaGIGsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:48:06 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55779 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaGIGsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:48:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v8 8/9] pci: Add support for creating a generic host_bridge from device tree
Date: Wed, 9 Jul 2014 08:47:40 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <20140708223737.GA19512@google.com> <20140708225755.GE4980@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140708225755.GE4980@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201407090847.41303.arnd@arndb.de>
X-Provags-ID: V02:K0:0lHnJJ3qOCTEP3IZnyC19oQWEevzYljit1AJtu8+ELZ
 /DollOi9ga1oJ9hBApBKiGlxoRuZ4s08knLKBtuXu7U0YDTx8q
 1X3N4v6K6Unswl03q0mPRdwYjiYmF0HlXsOptGeVlNnQ7cWTJY
 97/XLN+CPwSQnEHh5ajuYcqlRxtmxQYPGOS7yNdSvQg+eIv1Kw
 DjokVmcTmeAMQLcblUjPkPRbckh2CKmZCZ9IBo4p+aA2T2nTYQ
 XDRqGTCbu7cLH8wCBh52o8tQ5XhDxEKTneTBTLE47O0pZpK97d
 3wZj++ERVsdpg+J5DK8ZLo9pqkRkvyk9WRIpDKU8+3Etci+mE1
 n/u81Mxzglc3c5SDYV0bdTTAlgqbr9mZD+zltxZGj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014, Liviu Dudau wrote:
> On Tue, Jul 08, 2014 at 11:37:37PM +0100, Bjorn Helgaas wrote:
> > On Tue, Jul 08, 2014 at 11:27:38PM +0100, Liviu Dudau wrote:
> > > > > > > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > > > > > > index 7e7b939..556dc5f 100644
> > > > > > > --- a/include/linux/pci.h
> > > > > > > +++ b/include/linux/pci.h
> > > > > > > @@ -402,6 +402,7 @@ struct pci_host_bridge {
> > > > > > >       struct device dev;
> > > > > > >       struct pci_bus *bus;            /* root bus */
> > > > > > >       int domain_nr;
> > > > > > > +     resource_size_t io_base;        /* physical address for the start of I/O area */
> > > > > > 
> > > > > > I don't see where this is used yet.
> > > > > 
> > > > > It's used in pci_host_bridge_of_get_ranges() (earlier in this patch).
> > > > 
> > > > of_create_pci_host_bridge() fills in bridge->io_base, but I don't see
> > > > anything that ever reads bridge->io_base.
> > > 
> > > Ah, understood. It is used by the host bridge drivers to set their ATR registers to the
> > > correct CPU address values.

Actually, as we just discovered with one of the pci_dw drivers, it may
be the wrong number: what you program in the ATR registers is not
necessarily the same as the address visible to the CPU. What you need
instead is the address at the bus immediately above the PCI host bridge.

I think for now we can leave out this part from common code and add
the infrastructure later. Host drivers can have their own loop
around the ranges if they need to set up these registers. Ideally
at least on arm64, they should be set up by the firmware already.

	Arnd
