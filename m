Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbaDKJWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:22:42 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42987 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbaDKJWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:22:32 -0400
Date: Fri, 11 Apr 2014 10:22:25 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for
 pci_host_bridge.
Message-ID: <20140411092225.GW985@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
 <6144916.rD76jOL8sv@wuerfel>
 <20140410145304.GS985@e106497-lin.cambridge.arm.com>
 <6459805.ygy4tBNDNz@wuerfel>
MIME-Version: 1.0
In-Reply-To: <6459805.ygy4tBNDNz@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 11 Apr 2014 09:22:42.0362 (UTC) FILETIME=[973159A0:01CF5567]
X-MC-Unique: 114041110222904801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 09:46:36PM +0100, Arnd Bergmann wrote:
> On Thursday 10 April 2014 15:53:04 Liviu Dudau wrote:
> > On Thu, Apr 10, 2014 at 03:07:44PM +0100, Arnd Bergmann wrote:
> 
> > > This mirrors how we treat devices: a pci_device has an embedded device,
> > > and so on, in other subsystems we can have multiple layers.
> > > 
> > > In this example, the tegra pcie driver then allocates its own tegra_pcie
> > > structure, fills out the fields it needs, and registers it with the
> > > ARM architecture code, passing just the pci_sys_data pointer. That function
> > > in turn passes a pointer to the embedded pci_host_bridge down to the
> > > generic code. Ideally we should try to eliminate the architecture specific
> > > portion here, but that is a later step.
> > 
> > So Arnd seems to agree with me: we should try to get out of architecture specific
> > pci_sys_data and link the host bridge driver straight into the PCI core. The
> > core then can call into arch code via pcibios_*() functions.
> > 
> > Arnd, am I reading correctly into what you are saying?
> 
> Half of it ;-)
> 
> I think it would be better to not have an architecture specific data
> structure, just like it would be better not to have architecture specific
> pcibios_* functions that get called by the PCI core. Note that the
> architecture specific functions are the ones that rely on the architecture
> specific data structures as well. If they only use the common fields,
> it should also be possible to share the code.

While I've come to like the pcibios_*() interface (and yes, it could be
formalised and abstracted into a pci_xxxx_ops structure) I don't like the fact
that those functions use architectural data in order to function. I know it
might sound strange, as they *are* supposed to be implemented by the arches,
but in my mind the link between generic code and arch code for PCI should be
done by the host bridge driver. That's how PCI spec describes it, and I see no
reason why we should not be able to adopt the same view.

To be more precise, what I would like to happen in the case of some functions
would be for the PCI core code to call a pci_host_bridge_ops method which
in turn will call the arch specific code if it needs to. Why I think that would
be better? Because otherwise you put in the architectural side code to cope
with a certain host bridge, then another host bridge comes in and you add
more architectural code, but then when you port host bridge X to arch B you
discover that you need to add code there as well for X. And it all ends up in
the mess we currently have where the drivers in drivers/pci/host are not capable
of being ported to a different architecture because they rely on infrastructure
only present in arm32 that is not properly documented.

> 
> I also don't realistically think we can get there on a lot of architectures
> any time soon. Note that most architectures only have one PCI host
> implementation, so the architecture structure is the same as the host
> driver structure anyway.
> 
> For architectures like powerpc and arm that have people actively working
> on them, we have a chance to clean up that code in the way we want it
> (if we can agree on the direction), but it's still not trivial to do.
> 
> Speaking of arm32 in particular, I think we will end up with a split
> approach: modern platforms (multiplatform, possibly all DT based) using
> PCI core infrastructure directly and no architecture specific PCI
> code on the one side, and a variation of today's code for the legacy
> platforms on the other.

Actually, if we could come up with a compromise for the pci_fixup_*() functions
(are they still used by functional hardware?) then I think we could convert
most of the arm32 arch code to re-direct the calls to the infrastructure code.
But yes, there might be a lot of resistance to change due to lack of resources
when changing old platforms.

Best regards,
Liviu

> 
> 	Arnd
> 
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

