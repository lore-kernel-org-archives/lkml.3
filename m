Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaD2HGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:06:18 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:35433 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaD2HGN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:2>);
	Tue, 29 Apr 2014 03:06:13 -0400
Message-Id: <535F6B7F020000780000D2DB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Tue, 29 Apr 2014 08:06:07 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Bjorn Helgaas" <bhelgaas@google.com>
Cc: "Aravind Gopalakrishnan" <aravind.gopalakrishnan@amd.com>,
        <kim.naru@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        "Myron Stowe" <myron.stowe@gmail.com>,
        "Robert Richter" <rric@kernel.org>, "x86" <x86@kernel.org>,
        "Yinghai Lu" <yinghai@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Daniel J Blueman" <daniel@numascale.com>,
        "Steffen Persvold" <sp@numascale.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Myron Stowe" <myron.stowe@redhat.com>, "Borislav Petkov" <bp@suse.de>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range
 capabilities
References: <20140419025308.2408.51252.stgit@amt.stowe>
 <20140419025323.2408.88764.stgit@amt.stowe>
 <20140419135219.GC8109@pd.tnic> <20140420075936.GA19672@pd.tnic>
 <CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com>
 <20140426091031.GA10166@pd.tnic>
 <CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
In-Reply-To: <CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.04.14 at 22:50, <bhelgaas@google.com> wrote:
>>> > There's a enable_pci_io_ecs() which enables ECS through the NB_CFG MSR
>>> > which is called as part of the notifier *and* there's a PCI write to
>>> > that same bit in pci_enable_pci_io_ecs() which iterates over all NBs.
>>> >
>>> > So, AFAICT, we do it twice and the second time is not needed. Which
>>> > means, you probably can drop pci_enable_pci_io_ecs() completely and use
>>> > solely the notifier?
>>>
>>> It does look as if there is some duplication with respect to setting
>>> MSR_AMD64_NB_CFG's (which is aliased at D18F3x8c [1])
>>> ENABLE_CF8_EXT_CFG enable bit but there are at least a couple of
>>> differences.
>>>
>>> enable_pci_io_ecs() only sets the bit on one NB whereas
>>> pci_enable_pci_io_ecs iterates over all the NBs (as you mentioned
>>> above).  The other difference has something to do with Xen; see the
>>> origin of pci_enable_pci_io_ecs - commit 24d9b70b8.

As stated there - Xen Dom0 is running on virtual CPUs, i.e. which
physical CPU the code gets executed on is unknown, and hence the
MSR based approach just does not reliably work there.

Of course, with (since then) grown needs to access extended config
space in Xen itself, this enabling could be moved into the hypervisor.
Back then the hypervisor didn't have much need for this, so it seemed
more reasonable (albeit I'm rather certain Borislav is going to disagree
with this) to augment the Dom0 side code.

> This is probably obvious, but my interest here is to (1) make sure all
> systems in the field run well (so we need quirks to work around BIOS
> and other issues), and (2) eliminate the need for kernel changes to
> support future systems.  So far we seem to be concentrating on (1) and
> neglecting (2), which means we're always reacting to things that are
> broken.
> 
> This I/O ECS thing seems likely to cause future problems.  My
> understanding (based on sec 2.8 of [1]) is that enable_pci_io_ecs()
> and pci_enable_pci_io_ecs() are there to enable access to extended
> config space (offsets 256-4095) via the 0xcf8/0xcfc I/O ports.
> 
> Per sec 4.1.1 of [2], we should be using ECAM (the memory-mapped
> enhanced configuration mechanism, i.e., MMCONFIG) to access extended
> config space, and the BIOS should supply an MCFG table.
> 
> So why do we need to enable I/O access to ECS on AMD chips at all?  Is
> this a workaround for a broken BIOS that doesn't supply an MCFG table?

Yes. Rather than leaving such systems entirely without access to
extended config space, it seemed (and still seems to me) better to
at least have this fallback in place. If after this discussion you decide
to drop this code here, it would be nice if you could let us know up
front, so we can decide whether to add the code to the hypervisor
instead or - just like on Intel systems - rely on MCFG being properly
exposed by the firmware.

Jan

