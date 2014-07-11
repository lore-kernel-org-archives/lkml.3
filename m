Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaGKSC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:02:29 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:56689 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751886AbaGKSC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:02:27 -0400
Date: Fri, 11 Jul 2014 19:02:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 6/9] pci: Introduce a domain number for
 pci_host_bridge.
Message-ID: <20140711180151.GH16321@arm.com>
References: <1404240214-9804-7-git-send-email-Liviu.Dudau@arm.com>
 <20140708005954.GC22939@google.com>
 <20140708104655.GC6501@e106497-lin.cambridge.arm.com>
 <CAErSpo75ovmGoeSHKJN0nckGDy-0gpn8kLPfHQ79CtcXxhPydw@mail.gmail.com>
 <20140708224847.GC4980@e106497-lin.cambridge.arm.com>
 <CAErSpo5rBt0iF2HGeDD-UH6_sPCoC647VCw0Q1v_0Rdpvcir-w@mail.gmail.com>
 <20140710094758.GA6501@e106497-lin.cambridge.arm.com>
 <CAErSpo5ZNCY31NztT0cLFbRVsBZqMsZ0LbTFNOTQCZUU3F7qJA@mail.gmail.com>
 <20140711141115.GB16321@arm.com>
 <CAErSpo7C8qzmdp+XgVi2ysXj_NcgvVY7RVfBZ2PHimLzrzANMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7C8qzmdp+XgVi2ysXj_NcgvVY7RVfBZ2PHimLzrzANMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:02:56PM +0100, Bjorn Helgaas wrote:
> On Fri, Jul 11, 2014 at 8:11 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Thu, Jul 10, 2014 at 11:36:10PM +0100, Bjorn Helgaas wrote:
> >> Most of the rest of the v7 discussion was about "Introduce a domain
> >> number for pci_host_bridge."  I think we should add arm64 using the
> >> existing pci_scan_root_bus() and keep the domain number in the arm64
> >> sysdata structure like every other arch does.  Isn't that feasible?
> >> We can worry about domain unification later.
> >
> > I think that's what we were trying to avoid, adding an arm64-specific
> > pci_sys_data structure (and arm64-specific API). IIUC, avoiding this
> > would allow the host controller drivers to use the sysdata pointer for
> > their own private data structures.
> >
> > Also since you can specify the domain number via DT (and in Liviu's
> > v8 patches read by of_create_pci_host_bridge), I think it would make
> > sense to have it stored in some generic data structures (e.g.
> > pci_host_bridge) rather than in an arm64 private sysdata.
> 
> It would definitely be nice to keep the domain in a generic data
> structure rather than an arm64-specific one.  But every other arch
> keeps it in an arch-specific structure today, and I think following
> that existing pattern is the quickest way forward.

In this case we end up with an arm64-specific struct pci_sys_data and I
assume some API that takes care of this data structure to populate the
domain nr.

In Liviu's implementation, of_create_pci_host_bridge() is called by the
host controller driver directly and reads the domain_nr from the DT. It
also gets a void *host_data which it stores as sysdata in the pci_bus
structure (but that's specific to the host controller driver rather than
arm64). Since sysdata is opaque to of_create_pci_host_bridge(), it
cannot set the domain_nr.

If we go for arm64 sysdata, the host controller driver would have to
call some arm64 pci* function (maybe with its own private data as
argument) which would have to parse the DT, assign the domain nr and
eventually call pci_create_root_bus(). But it means that significant
part of of_create_pci_host_bridge() would be moved under arch/arm64 (an
alternative is for each host driver to implement its own
of_create_pci_host_bridge()).

In addition, host drivers would retrieve their private data from the
arm64 specific sysdata structure and we were trying to make host drivers
depend only on generic data structures and API rather than arch
specific.

> But you mentioned arm64-specific API, too.  What do you have in mind
> there?  I know there will be arm64 implementations of various
> pcibios_*() functions (just like for every other arch), but it sounds
> like there might be something else?

Not much left which is arm64 specific, just some callbacks:

http://linux-arm.org/git?p=linux-ld.git;a=commitdiff;h=82ebbce34506676528b9a7ae8f8fbc84b6b6248e

AFAICT, there isn't anything that host drivers need to call directly.
Basically we want to decouple the PCI host driver model from the arch
specific data structures/API.

-- 
Catalin
