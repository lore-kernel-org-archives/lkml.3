Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbaD2LT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:19:29 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:59990 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbaD2LTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:19:25 -0400
Date: Tue, 29 Apr 2014 13:19:19 +0200
From: Robert Richter <rric@kernel.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>,
        herrmann.der.user@gmail.com, Myron Stowe <myron.stowe@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        kim.naru@amd.com, Daniel J Blueman <daniel@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range
 capabilities
Message-ID: <20140429111919.GI32718@rric.localhost>
References: <20140419025308.2408.51252.stgit@amt.stowe>
 <20140419025323.2408.88764.stgit@amt.stowe>
 <20140419135219.GC8109@pd.tnic>
 <20140420075936.GA19672@pd.tnic>
 <CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com>
 <20140426091031.GA10166@pd.tnic>
 <CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
 <20140428214036.GA32143@pd.tnic>
 <20140429073309.GE10997@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429073309.GE10997@alberich>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.04.14 09:33:09, Andreas Herrmann wrote:
> On Mon, Apr 28, 2014 at 11:40:36PM +0200, Borislav Petkov wrote:
> > On Mon, Apr 28, 2014 at 02:50:29PM -0600, Bjorn Helgaas wrote:
> > > This I/O ECS thing seems likely to cause future problems.  My
> > > understanding (based on sec 2.8 of [1]) is that enable_pci_io_ecs()
> > > and pci_enable_pci_io_ecs() are there to enable access to extended
> > > config space (offsets 256-4095) via the 0xcf8/0xcfc I/O ports.
> > > 
> > > Per sec 4.1.1 of [2], we should be using ECAM (the memory-mapped
> > > enhanced configuration mechanism, i.e., MMCONFIG) to access extended
> > > config space, and the BIOS should supply an MCFG table.

This is due to the non-atomic access to 0xcf8/0xcfc.

IIRC, another problem with io cfg space access is that it is bound to
register rax or so. The kernel implementation may not change here.

Otherall mmconfig access is much better implemented and thus
recommended to use by the os, while io cfg is used mainly by the bios.

> > > So why do we need to enable I/O access to ECS on AMD chips at all?  Is
> > > this a workaround for a broken BIOS that doesn't supply an MCFG table?
> > 
> > That's a good question. 831d991821dae doesn't say but I have a hunch
> > Andreas and/or Robert should know. I seem to vaguely remember it
> > might've been because of a missing MCFG but have flushed it out of the
> > cache long time ago.
> > 
> > Let's ask them.
> > 
> > Andreas, Robert, guys, do you remember why we did the PCI IO ECS access?
> > B0rked BIOSes?
> 
> 
> I am sure, it's because some server systems had MMIO ECS access not
> enabled in BIOS. I can't remember which systems were affected.

Yes, mmio ecs was not enabled on some systems by the bios. We needed
to use cf8/cfc io access.

If MMCONFIG is available it is the default, cf8/cfc is only used
otherwise. Also, some kernel configs may disable MMCONFIG.

PCI ECS was especially needed to enable the IBS interrupt for hw
profiling.

-Robert
