Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaIXBsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:48:54 -0400
Received: from dliviu.plus.com ([80.229.23.120]:59221 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbaIXBsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:48:52 -0400
Date: Wed, 24 Sep 2014 02:48:09 +0100
From: Liviu Dudau <liviu@dudau.co.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v12 10/12] PCI: Assign unassigned bus resources in
 pci_scan_root_bus()
Message-ID: <20140924014809.GF32643@bart.dudau.co.uk>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <1411498874-9864-11-git-send-email-Liviu.Dudau@arm.com>
 <20140924011851.GD32643@bart.dudau.co.uk>
 <CAErSpo5DR+TPYXBWGKRj9SRPjsbJ6kjZmAH1AXT12txEjGdZGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo5DR+TPYXBWGKRj9SRPjsbJ6kjZmAH1AXT12txEjGdZGQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Sep 24 02:48:50 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,542223023114567116023
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:41:35PM -0600, Bjorn Helgaas wrote:
> On Tue, Sep 23, 2014 at 7:18 PM, Liviu Dudau <liviu@dudau.co.uk> wrote:
> > On Tue, Sep 23, 2014 at 08:01:12PM +0100, Liviu Dudau wrote:
> >> If the firmware has not assigned all the bus resources and
> >> we are not just probing the PCIe busses, it makes sense to
> >> assign the unassigned resources in pci_scan_root_bus().
> >>
> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> >> Cc: Rob Herring <robh+dt@kernel.org>
> >> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> >> ---
> >>  drivers/pci/probe.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> >> index ef891d2..508cf61 100644
> >> --- a/drivers/pci/probe.c
> >> +++ b/drivers/pci/probe.c
> >> @@ -1953,6 +1953,9 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
> >>       if (!found)
> >>               pci_bus_update_busn_res_end(b, max);
> >>
> >> +     if (!pci_has_flag(PCI_PROBE_ONLY))
> >> +             pci_assign_unassigned_bus_resources(b);
> >> +
> >>       pci_bus_add_devices(b);
> >>       return b;
> >>  }
> >> --
> >> 2.1.0
> >>
> >
> > Bjorn,
> >
> > If you are OK with this patch, can you let me know how do you feel about
> > making pci_scan_root_bus() set up the bus->msi pointer as well?
> 
> I'm not opposed to it, but I have the same question as for setting up
> the domain: how does pci_scan_root_bus() learn what to assign to
> bus->msi?  It currently only gets a "void *sysdata" so there's no
> obvious place to put it there.  You could add a pcibios interface to
> retrieve it, I suppose, but I'm starting to get uncomfortable with
> adding more of those because we have such a mess of them already.

My long term view is that the creation of the pci_host_bridge structure
needs to be separated from the creation and scanning of the root bus.
Then we can add host bridge ops or some other API to the structure
that should allow for less friction in passing information to the bridge.

Best regards,
Liviu

> 
> Bjorn
> 
> > Side note: I don't know exactly how to do it now, but setting bus->msi is
> > needed by platforms that are based on my patches and want to use MSI,
> > otherwise they have to open code pci_scan_root_bus() to set it. I haven't
> > made any attempts to do it in this series as the GICv2m patches are not
> > ready yet, but I can see the need arriving soon.
> >
> > Best regards,
> > Liviu
> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>

