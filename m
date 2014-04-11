Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaDKFCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 01:02:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:50151 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaDKFCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 01:02:13 -0400
Message-ID: <1397192469.19518.11.camel@pasglop>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for
 pci_host_bridge.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 11 Apr 2014 15:01:09 +1000
In-Reply-To: <6459805.ygy4tBNDNz@wuerfel>
References: <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
	 <6144916.rD76jOL8sv@wuerfel>
	 <20140410145304.GS985@e106497-lin.cambridge.arm.com>
	 <6459805.ygy4tBNDNz@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 22:46 +0200, Arnd Bergmann wrote:

> Half of it ;-)
> 
> I think it would be better to not have an architecture specific data
> structure, just like it would be better not to have architecture specific
> pcibios_* functions that get called by the PCI core. Note that the
> architecture specific functions are the ones that rely on the architecture
> specific data structures as well. If they only use the common fields,
> it should also be possible to share the code.

I don't understand... we'll never get rid of architecture specific hooks
in one form or another.

We'll always need to some things in an architecture or host-bridge
specific way. Now if you don't want to call them arch hooks, then call
them host bridge ops, but they are needed and thus they will need some
kind of architecture specific extension to the base host bridge 
structure.

EEH is one big nasty example on powerpc.

Another random one that happens to be hot in my brain right now because
we just finished debugging it: On powernv, we are just fixing a series
of bugs caused by the generic code trying to do hot resets on PCIe "by
hand" by directly toggling the secondary reset register in bridges.

Well, on our root complexes, this triggers a link loss which triggers
a fatal EEH "ER_all" interrupt which we escalate into a fence and all
hell breaks loose.

We need to mask some error traps in the hardware before doing something
that can cause an intentional link loss... and unmask them when done.
(Among other things, there are other issues on P7 with hot reset).

So hot reset must be an architecture hook.

PERST (fundamental reset) can *only* be a hook. The way to generate a
PERST is not specified. In fact, on our machines, we have special GPIOs
we can use to generate PERST on individual slots below a PLX bridge
and a different methods for slots directly on a PHB.

Eventually most of those hooks land into firmware, and as such it's akin
to ACPI which also keeps a separate state structure and a pile of hooks.

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
> 
> 	Arnd


