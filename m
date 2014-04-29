Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965100AbaD2T3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:29:55 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:57285 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398AbaD2T3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:29:52 -0400
MIME-Version: 1.0
In-Reply-To: <535F0837.2020102@amd.com>
References: <20140419025308.2408.51252.stgit@amt.stowe> <20140419025345.2408.99229.stgit@amt.stowe>
 <20140420105419.GB19676@pd.tnic> <CAL-B5D1_fns=mu7Cw6jeVHO0XPeKYakUrPv-JgO=ma1rjCoQvg@mail.gmail.com>
 <53554D27.1010803@numascale.com> <535F0837.2020102@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 29 Apr 2014 13:29:32 -0600
Message-ID: <CAErSpo77c5F0vftHEOFFwvXLa7S2DZzPdTjO4v6zRGcpJmjj3w@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] PCI: Remove redundant 'quirk_amd_nb_node'
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Daniel J Blueman <daniel@numascale.com>,
        Myron Stowe <myron.stowe@gmail.com>, Borislav Petkov <bp@suse.de>,
        Myron Stowe <myron.stowe@redhat.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        kim.naru@amd.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 <x86@kernel.org>, Steffen Persvold <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 8:02 PM, Suravee Suthikulanit
<suravee.suthikulpanit@amd.com> wrote:

> Sorry for late reply.  My concern is that removing the "quirk_amd_nb_node()"
> will affect the value of "numa_node" of the host bridge devices (i.e.
> X:00.[18|19|1a|1b|1c|1d|1e|1f].X).  I am not sure if any code is using this
> information.  But in theory, these host-bridge devices are not on the same
> node as where the PCI root complex lives (e.g. 0 and 4 from the example
> above).

I doubt anything in the kernel uses the node number for these devices
(00:[18|19|...]).  The only place the PCI core uses it is to run a
driver probe method on the same node as the device.  Are there even
drivers for these devices?

They aren't PCI-to-PCI bridges, so there are no devices below them
that would be affected by their node numbers.

> If we want the "numa_node" to really representing the actual node, then the
> quirk has to stay for now.  We might need to come up with a different logic
> to replace the quirks here, which would automatically determine the actual
> node value for these host-bridge devices.

It sounds like the numa_node for these devices in sysfs is misleading
unless we have a quirk like this.  If that's important, I think it
could be fixed by having the BIOS provide _PXM methods for them.  But
I don't think it is, and I'm inclined to remove the quirk.

I'm pushing hard to get rid of CPU-specific code like this because
there are generic methods to do it, e.g., _PXM, and the CPU-specific
code is a perennial maintenance headache.

Bjorn
